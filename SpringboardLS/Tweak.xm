#import "Tweak.h"
#import <notify.h>

bool moveIntoPanel = false;
MSHConfig *mshConfig;

%group MitsuhaVisualsNotification

%hook SBDashBoardMediaControlsViewController

%property (retain,nonatomic) MSHView *mshView;

-(void)loadView{
    %orig;
    self.view.clipsToBounds = 1;

    MediaControlsPanelViewController *mcpvc = (MediaControlsPanelViewController*)[self valueForKey:@"_mediaControlsPanelViewController"];
    [mcpvc.headerView.artworkView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
    
    [mshConfig initializeViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 15, self.view.frame.size.height)];
    self.mshView = [mshConfig view];

    if (!moveIntoPanel) {
        [self.view addSubview:self.mshView];
        [self.view sendSubviewToBack:self.mshView];
    } else {
        [mcpvc.view insertSubview:self.mshView atIndex:1];
    }
}

%new;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self readjustWaveColor];
}

%new;
-(void)readjustWaveColor{
    MediaControlsPanelViewController *mcpvc = (MediaControlsPanelViewController*)[self valueForKey:@"_mediaControlsPanelViewController"];
    [mshConfig colorizeView:mcpvc.headerView.artworkView.image];
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    self.view.superview.layer.cornerRadius = 13;
    self.view.superview.layer.masksToBounds = TRUE;
    
    [self readjustWaveColor];

    [[mshConfig view] start];
    [mshConfig view].center = CGPointMake([mshConfig view].center.x, mshConfig.waveOffset);
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
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)screenDisplayStatus, (CFStringRef)@"com.apple.iokit.hid.displayStatus", NULL, kNilOptions);
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
