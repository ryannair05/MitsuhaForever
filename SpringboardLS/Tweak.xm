#import "Tweak.h"
#import <MediaRemote/MediaRemote.h>
#import <notify.h>

bool moveIntoPanel = false;
MSHConfig *mshConfig;

%group MitsuhaVisualsNotification

%hook SBMediaController

-(void)setNowPlayingInfo:(id)arg1 {
    %orig;
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary *dict = (__bridge NSDictionary *)information;

        if (dict && dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
            [mshConfig colorizeView:[UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]];
        }
    });
}

%end

%hook SBDashBoardMediaControlsViewController

%property (retain,nonatomic) MSHView *mshView;

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

    if (![mshConfig view]) [mshConfig initializeViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 16, self.view.frame.size.height)];	
    self.mshView = [mshConfig view];

    if (!moveIntoPanel) {
        [self.view addSubview:self.mshView];
        [self.view sendSubviewToBack:self.mshView];
    } else {
        [mcpvc.view insertSubview:self.mshView atIndex:1];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    self.view.superview.layer.cornerRadius = 13;
    self.view.superview.layer.masksToBounds = TRUE;

    [[mshConfig view] start];
    [mshConfig view].center = CGPointMake([mshConfig view].center.x, mshConfig.waveOffset);
}

-(void)viewDidAppear:(BOOL)animated {
    [[mshConfig view] start];
}

-(void)viewDidDisappear:(BOOL)animated{
    %orig;
    [[mshConfig view] stop];
}

%end

%end

static void screenDisplayStatus(CFNotificationCenterRef center, void* o, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
    uint64_t state;
    int token;
    notify_register_check("com.apple.iokit.hid.displayStatus", &token);
    notify_get_state(token, &state);
    notify_cancel(token);
    if ([mshConfig view]) {
        if (state) {
            [[mshConfig view] start];
        } else {
            [[mshConfig view] stop];
        }
    }
}

%ctor{
    mshConfig = [MSHConfig loadConfigForApplication:@"Springboard"];
    mshConfig.waveOffsetOffset = 500;

    if(mshConfig.enabled){
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)screenDisplayStatus, (CFStringRef)@"com.apple.iokit.hid.displayStatus", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
        //Check if Artsy is installed
        bool artsyEnabled = false;
        bool artsyLsEnabled = false;
        bool artsyPresent = [[NSFileManager defaultManager] fileExistsAtPath: ArtsyTweakDylibFile] && [[NSFileManager defaultManager] fileExistsAtPath: ArtsyTweakPlistFile];

        if (artsyPresent) {
            NSLog(@"[MitsuhaInfinity] Artsy found");
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
                NSLog(@"[MitsuhaInfinity] Artsy lsEnabled = true");
                moveIntoPanel = true;
            }
        }

        %init(MitsuhaVisualsNotification);
    }
}
