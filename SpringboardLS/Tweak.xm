#import "Tweak.h"
#import <MediaRemote/MediaRemote.h>
#import <notify.h>

bool moveIntoPanel = false;
MSHFConfig *config;
MSHFView *mshfview;

%group MitsuhaVisualsNotification

%hook SBMediaController

-(void)setNowPlayingInfo:(id)arg1 {
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

%group ios13
%hook CSMediaControlsViewController

%new
-(id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

-(void)loadView{
    %orig;
    self.view.clipsToBounds = 1;

    MRPlatterViewController *pvc = nil;

    if ([self valueForKey:@"_platterViewController"]) {
        pvc = (MRPlatterViewController*)[self valueForKey:@"_platterViewController"];
    }
    
    if (!pvc) return;

    if (![config view]) [config initializeViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 16, self.view.frame.size.height)];	
    mshfview = [config view];

    if (!moveIntoPanel) {
        [self.view addSubview:mshfview];
        [self.view sendSubviewToBack:mshfview];
    } else {
        [pvc.view insertSubview:mshfview atIndex:1];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    self.view.superview.layer.cornerRadius = 13;
    self.view.superview.layer.masksToBounds = TRUE;

    [[config view] start];
    [config view].center = CGPointMake([config view].center.x, config.waveOffset);
}

-(void)viewDidAppear:(BOOL)animated {
    [[config view] start];
}

-(void)viewDidDisappear:(BOOL)animated{
    %orig;
    [[config view] stop];
}

%end

%end

%group old
%hook SBDashBoardMediaControlsViewController

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
    mshfview = [config view];

    if (!moveIntoPanel) {
        [self.view addSubview:mshfview];
        [self.view sendSubviewToBack:mshfview];
    } else {
        [mcpvc.view insertSubview:mshfview atIndex:1];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    self.view.superview.layer.cornerRadius = 13;
    self.view.superview.layer.masksToBounds = TRUE;

    [[config view] start];
    [config view].center = CGPointMake([config view].center.x, config.waveOffset);
}

-(void)viewDidAppear:(BOOL)animated {
    [[config view] start];
}

-(void)viewDidDisappear:(BOOL)animated{
    %orig;
    [[config view] stop];
}

%end

%end

static void screenDisplayStatus(CFNotificationCenterRef center, void* o, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
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
}

%ctor{
    config = [MSHFConfig loadConfigForApplication:@"Springboard"];
    config.waveOffsetOffset = 500;

    if(config.enabled){
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)screenDisplayStatus, (CFStringRef)@"com.apple.iokit.hid.displayStatus", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
        //Check if Artsy is installed
        bool artsyEnabled = false;
        bool artsyLsEnabled = false;
        bool artsyPresent = [[NSFileManager defaultManager] fileExistsAtPath: ArtsyTweakDylibFile] && [[NSFileManager defaultManager] fileExistsAtPath: ArtsyTweakPlistFile];

        if (artsyPresent) {
            NSLog(@"[MitsuhaForever] Artsy found");
            artsyEnabled = true; //it's enabled by default when Artsy is installed
            artsyLsEnabled = true;
            
            //Check if Artsy is enabled
            NSMutableDictionary *artsyPrefs = [[NSMutableDictionary alloc] initWithContentsOfFile:ArtsyPreferencesFile];
            if (artsyPrefs) {
                artsyEnabled = [([artsyPrefs objectForKey:@"enabled"] ?: @(YES)) boolValue];
                artsyLsEnabled = [([artsyPrefs objectForKey:@"lsEnabled"] ?: @(YES)) boolValue];
            }
        }

        if (artsyEnabled) {
            if (artsyLsEnabled) {
                NSLog(@"[MitsuhaForever: ARTSY] lsEnabled = true");
                moveIntoPanel = true;
            }
        }
        
        if(@available(iOS 13.0, *)) {
		    NSLog(@"[MitsuhaForever] Current version is iOS 13!");
		    %init(ios13)
	    } else {
            %init(old)
        }

        %init(MitsuhaVisualsNotification);
    }
}
