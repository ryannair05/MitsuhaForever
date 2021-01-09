#import "Tweak.h"
#import <MediaRemote/MediaRemote.h>
#import <notify.h>
#import <dlfcn.h>

bool moveIntoPanel = false;
static MSHFConfig *config = NULL;

%group MitsuhaVisualsNotification

%hook SBMediaController

-(void)setNowPlayingInfo:(NSDictionary *)arg1 {
    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary *dict = (__bridge NSDictionary *)information;

        if (dict && dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
            [config colorizeView:[UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]];
        }
    });
}

%end

%end 

%group Quart

%hook QRTMediaModuleViewController
%property (retain,nonatomic) MSHFView *mshfView;

-(void)loadView {
    %orig;

    if (![config view]) [config initializeViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];	
    self.mshfView = [config view];

    [self.view addSubview:self.mshfView];
    [self.view sendSubviewToBack:self.mshfView];
}

-(void)setArtworkContainer:(id)arg1 {

    %orig;
    if ([[%c(SBMediaController) sharedInstance] isPlaying]) {
        [[config view] start];
    }
    [config view].center = CGPointMake([config view].center.x, config.waveOffset);

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary *dict = (__bridge NSDictionary *)information;

        if (dict && dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
            [config colorizeView:[UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]];
        }
    });
}

-(void)viewDidDisappear:(BOOL)animated{
    %orig;
    [[config view] stop];
}
%end

%end

%group ios13

%hook CSMediaControlsViewController

%property (retain,nonatomic) MSHFView *mshfView;

-(void)loadView{
    %orig;
    self.view.clipsToBounds = 1;

    MRPlatterViewController *pvc = nil;

    if ([self valueForKey:@"_platterViewController"]) {
        pvc = (MRPlatterViewController*)[self valueForKey:@"_platterViewController"];
    }
    
    if (!pvc) return;

    if (![config view]) [config initializeViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];	
    self.mshfView = [config view];

    if (!moveIntoPanel) {
        [self.view addSubview:self.mshfView];
        [self.view sendSubviewToBack:self.mshfView];
    } else {
        [pvc.view insertSubview:self.mshfView atIndex:1];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    self.view.superview.layer.cornerRadius = 13;
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wunguarded-availability-new"
    self.view.superview.layer.cornerCurve = kCACornerCurveContinuous;
    #pragma clang diagnostic pop
    self.view.superview.layer.masksToBounds = TRUE;
}

-(void)viewDidAppear:(BOOL)animated {
    %orig;
    if ([[%c(SBMediaController) sharedInstance] isPlaying]) {
        [[config view] start];
    }
    [config view].center = CGPointMake([config view].center.x, config.waveOffset);

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary *dict = (__bridge NSDictionary *)information;

        if (dict && dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
            [config colorizeView:[UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]];
        }
    });
}

-(void)viewDidDisappear:(BOOL)animated{
    %orig;
    [[config view] stop];
}

%end

%end

%group old
%hook SBDashBoardMediaControlsViewController

%property (retain,nonatomic) MSHFView *mshfView;

%new
-(id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

-(void)loadView{
    %orig;
    self.view.clipsToBounds = 1;

    MediaControlsPanelViewController *mcpvc = (MediaControlsPanelViewController*)[self valueForKey:@"_mediaControlsPanelViewController"];
    
    if (!mcpvc && [self valueForKey:@"_platterViewController"]) {
        mcpvc = (MediaControlsPanelViewController*)[self valueForKey:@"_platterViewController"];
    }

    if (!mcpvc) return;
    
    if (![config view]) [config initializeViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 16, self.view.frame.size.height)];
    self.mshfView = [config view];

    if (!moveIntoPanel) {
        [self.view addSubview:self.mshfView];
        [self.view sendSubviewToBack:self.mshfView];
    } else {
        [mcpvc.view insertSubview:self.mshfView atIndex:1];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    self.view.superview.layer.cornerRadius = 13;
    self.view.superview.layer.masksToBounds = TRUE;

    if ([[%c(SBMediaController) sharedInstance] isPlaying]) {
        [[config view] start];
    }
    [config view].center = CGPointMake([config view].center.x, config.waveOffset);
}

// -(void)viewDidAppear:(BOOL)animated {
//     [[config view] start];
// }

-(void)viewDidDisappear:(BOOL)animated{
    %orig;
    [[config view] stop];
}

%end

%end

static void screenDisplayStatus(CFNotificationCenterRef center, void* o, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
    if ([[%c(SBMediaController) sharedInstance] isPlaying]) {
        uint64_t state;
        int token;
        notify_register_check("com.apple.iokit.hid.displayStatus", &token);
        notify_get_state(token, &state);
        notify_cancel(token);
        if ([config view]) {
            if (state) {
                    [[config view] start];
            } else {
                [[config view] stop];
            }
        }
    } else {
        [[config view] stop];
    }
}

%ctor{
    config = [MSHFConfig loadConfigForApplication:@"Springboard"];

    if(config.enabled){
        NSFileManager *fileManager = [NSFileManager defaultManager];

        bool const flowPresent = [fileManager fileExistsAtPath: FlowTweakDylibFile];
        if(flowPresent) {
            return;
        }

        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)screenDisplayStatus, (CFStringRef)@"com.apple.iokit.hid.displayStatus", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
        %init(MitsuhaVisualsNotification);

        bool quartPresent = [fileManager fileExistsAtPath: QuartTweakDylibFile];

        if (quartPresent) {

            NSDictionary *quartPrefs = [[NSDictionary alloc] initWithContentsOfFile: QuartPreferencesFile];
            if (quartPrefs) {
                quartPresent = [([quartPrefs objectForKey:@"enable"] ?: @(YES)) boolValue];
                if (quartPresent)
                    quartPresent = [([quartPrefs objectForKey:@"enableMedia"] ?: @(YES)) boolValue];
            }
            
            if (quartPresent) {
                void *Quart = dlopen("/Library/MobileSubstrate/DynamicLibraries/Quart.dylib", RTLD_LAZY);
                if ([([quartPrefs objectForKey:@"largerMedia"] ?: @(NO)) boolValue]) {
                    config.waveOffsetOffset = 385;
                }
                else {
                    config.waveOffsetOffset = 375;
                }
                %init(Quart);
                dlclose(Quart);
                return;
            }
        }

        bool const artsyPresent = [fileManager fileExistsAtPath: ArtsyTweakDylibFile]; // Check if Artsy is installed

        if (artsyPresent) {
            NSLog(@"[MitsuhaForever] Artsy found");
            
            NSDictionary *artsyPrefs = [[NSDictionary alloc] initWithContentsOfFile:ArtsyPreferencesFile];
            if (artsyPrefs) { //Check if Artsy is enabled
                bool const artsyEnabled = [([artsyPrefs objectForKey:@"enabled"] ?: @(YES)) boolValue];
                if (artsyEnabled)
                    moveIntoPanel = [([artsyPrefs objectForKey:@"lsEnabled"] ?: @(YES)) boolValue];
            }
            else { //It's enabled by default when Artsy is installed
                NSLog(@"[MitsuhaForever: ARTSY] lsEnabled = true");
                moveIntoPanel = true;
            }
        }

        config.waveOffsetOffset = 500;
        if (@available(iOS 13.0, *)) {
            %init(ios13)
        } else {
            %init(old)
        }
    }
}