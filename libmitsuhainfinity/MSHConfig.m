#import "public/MSHConfig.h"
#import "../MSHUtils.h"
#import <Cephei/HBPreferences.h>
#import <Nepeta/NEPColorUtils.h>
#import <libcolorpicker.h>

void notificationCallback(CFNotificationCenterRef center, void * observer, CFStringRef name, void const * object, CFDictionaryRef userInfo) {
    NSLog(@"[MitsuhaInfinity] prefs changed");
    MSHConfig *ob = (MSHConfig *)observer;
    [ob reloadConfig];
}

@implementation MSHConfig

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setDictionary:dict];
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), (CFNotificationCallback)notificationCallback, (CFStringRef)MSHPreferencesChanged, NULL, kNilOptions);
    }
    return self;
}

-(void)initializeViewWithFrame:(CGRect)frame {
    UIView *superview = nil;
    NSUInteger index;

    if (_view) {
        if ([_view superview]) {
            superview = [_view superview];
            index = [superview.subviews indexOfObject:_view];
        }

        [_view stop];
        [_view removeFromSuperview];
    }

    switch (_style) {
        case 1:
            self.view = [[MSHBarView alloc] initWithFrame:frame];
            [((MSHBarView*)_view) setBarSpacing:self.barSpacing];
            [((MSHBarView*)_view) setBarCornerRadius:self.barCornerRadius];
            break;
        case 2:
            self.view = [[MSHLineView alloc] initWithFrame:frame];
            [((MSHLineView*)_view) setLineThickness:self.lineThickness];
            break;
        case 3:
            self.view = [[MSHDotView alloc] initWithFrame:frame];
            [((MSHDotView*)_view) setBarSpacing:self.barSpacing];
            break;
        default:
            self.view = [[MSHJelloView alloc] initWithFrame:frame];
    }

    if (superview) {
        if (index == NSNotFound) {
            [superview addSubview:_view];
        } else {
            [superview insertSubview:_view atIndex:index];
        }
    }

    [self configureView];
}

-(void)configureView {
    _view.autoHide = self.enableAutoHide;
    _view.displayLink.preferredFramesPerSecond = self.fps;
    _view.numberOfPoints = self.numberOfPoints;
    _view.waveOffset = self.waveOffset + self.waveOffsetOffset;
    _view.gain = self.gain;
    _view.limiter = self.limiter;
    _view.sensitivity = self.sensitivity;
    _view.audioProcessing.fft = self.enableFFT;
    _view.disableBatterySaver = self.disableBatterySaver;

    if (self.colorMode == 2 && self.waveColor && self.subwaveColor) {
        [_view updateWaveColor:[self.waveColor copy] subwaveColor:[self.waveColor copy]];
    } else if (self.calculatedColor) {
        [_view updateWaveColor:[self.calculatedColor copy] subwaveColor:[self.calculatedColor copy]];
    }
}

-(void)colorizeView:(UIImage *)image {
    if (self.view == NULL) return;
    UIColor *color = self.waveColor;

    if (self.colorMode == 1) {
        color = [NEPColorUtils averageColorNew:image withAlpha:self.dynamicColorAlpha];
    } else if (self.colorMode == 0) {
        color = [NEPColorUtils averageColor:image withAlpha:self.dynamicColorAlpha];
    }

    self.calculatedColor = color;
    [self.view updateWaveColor:[color copy] subwaveColor:[color copy]];
}

-(void)setDictionary:(NSDictionary *)dict {
    _application = [dict objectForKey:@"application"];
    _enabled = [([dict objectForKey:@"enabled"] ?: @(YES)) boolValue];

    _enableDynamicGain = [([dict objectForKey:@"enableDynamicGain"] ?: @(NO)) boolValue];
    _style = [([dict objectForKey:@"style"] ?: @(0)) intValue];
    _colorMode = [([dict objectForKey:@"colorMode"] ?: @(0)) intValue];
    _enableAutoUIColor = [([dict objectForKey:@"enableAutoUIColor"] ?: @(YES)) boolValue];
    _ignoreColorFlow = [([dict objectForKey:@"ignoreColorFlow"] ?: @(NO)) boolValue];
    _enableCircleArtwork = [([dict objectForKey:@"enableCircleArtwork"] ?: @(NO)) boolValue];
    _enableCoverArtBugFix = [([dict objectForKey:@"enableCoverArtBugFix"] ?: @(NO)) boolValue];
    _disableBatterySaver = [([dict objectForKey:@"disableBatterySaver"] ?: @(NO)) boolValue];
    _enableFFT = [([dict objectForKey:@"enableFFT"] ?: @(NO)) boolValue];
    _enableAutoHide = [([dict objectForKey:@"enableAutoHide"] ?: @(YES)) boolValue];
    
    if ([dict objectForKey:@"waveColor"]){
        if ([[dict objectForKey:@"waveColor"] isKindOfClass:[UIColor class]]) {
            _waveColor = [dict objectForKey:@"waveColor"];
        } else if ([[dict objectForKey:@"waveColor"] isKindOfClass:[NSString class]]) {
            _waveColor = [LCPParseColorString([dict objectForKey:@"waveColor"], @"#000000:0.5") retain];
        } else {
            _waveColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        }
    } else {
        _waveColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    
    if ([dict objectForKey:@"subwaveColor"]) {
        if ([[dict objectForKey:@"subwaveColor"] isKindOfClass:[UIColor class]]) {
            _subwaveColor = [dict objectForKey:@"subwaveColor"];
        } else if ([[dict objectForKey:@"subwaveColor"] isKindOfClass:[NSString class]]) {
            _subwaveColor = [LCPParseColorString([dict objectForKey:@"subwaveColor"], @"#000000:0.5") retain];
        } else {
            _subwaveColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        }
    } else {
        _subwaveColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    
    _gain = [([dict objectForKey:@"gain"] ?: @(50)) doubleValue];
    _limiter = [([dict objectForKey:@"limiter"] ?: @(0)) doubleValue];
    _numberOfPoints = [([dict objectForKey:@"numberOfPoints"] ?: @(8)) unsignedIntegerValue];
    _sensitivity = [([dict objectForKey:@"sensitivity"] ?: @(1)) doubleValue];
    _dynamicColorAlpha = [([dict objectForKey:@"dynamicColorAlpha"] ?: @(0.6)) doubleValue];

    _barSpacing = [([dict objectForKey:@"barSpacing"] ?: @(5)) doubleValue];
    _barCornerRadius = [([dict objectForKey:@"barCornerRadius"] ?: @(0)) doubleValue];
    _lineThickness = [([dict objectForKey:@"lineThickness"] ?: @(5)) doubleValue];

    _waveOffset = [([dict objectForKey:@"waveOffset"] ?: @(0)) doubleValue];
    _waveOffset = ([([dict objectForKey:@"negateOffset"] ?: @(false)) boolValue] ? _waveOffset * -1 : _waveOffset);

    _fps = [([dict objectForKey:@"fps"] ?: @(24)) doubleValue];
}

+(NSDictionary *)parseConfigForApplication:(NSString *)name {
    NSMutableDictionary *prefs = [@{} mutableCopy];
    [prefs setValue:name forKey:@"application"];

    HBPreferences *file = [[HBPreferences alloc] initWithIdentifier:MSHPreferencesIdentifier];

    NSLog(@"[Mitsuha] Preferences: %@", file);
    for (NSString *key in [file.dictionaryRepresentation allKeys]) {
        [prefs setValue:[file objectForKey:key] forKey:key];
    }

    NSMutableDictionary *colors = [[NSMutableDictionary alloc] initWithContentsOfFile:MSHColorsFile];
    NSLog(@"[Mitsuha] Colors: %@", colors);
    for (NSString *key in [colors allKeys]) {
        [prefs setValue:[colors objectForKey:key] forKey:key];
    }
    
    for (NSString *key in [prefs allKeys]) {
        NSString *removedKey = [key stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"MSH%@", name] withString:@""];
        NSString *loweredFirstChar = [[removedKey substringWithRange:NSMakeRange(0, 1)] lowercaseString];
        NSString *newKey = [removedKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:loweredFirstChar];

        [prefs setValue:[prefs objectForKey:key] forKey:newKey];
    }

    prefs[@"gain"] = [prefs objectForKey:@"gain"] ?: @(50);
    prefs[@"subwaveColor"] = prefs[@"waveColor"];
    prefs[@"waveOffset"] = ([prefs objectForKey:@"waveOffset"] ?: @(0));

    return prefs;
}

-(void)reloadConfig {
    int oldStyle = self.style;
    [self setDictionary:[MSHConfig parseConfigForApplication:self.application]];
    if (self.view) {
        if (self.style != oldStyle) {
            [self initializeViewWithFrame:self.view.frame];
            [[self view] start];
        } else {
            [self configureView];
        }
    }
}

+(MSHConfig *)loadConfigForApplication:(NSString *)name{
    return [[MSHConfig alloc] initWithDictionary:[MSHConfig parseConfigForApplication:name]];
}

@end