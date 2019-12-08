#import "Tweak.h"
#import <MediaRemote/MediaRemote.h>
#import <notify.h>

bool moveIntoPanel = false;
MSHConfig *mshConfig;

%group MitsuhaVisuals

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

%hook SBDashBoardFixedFooterViewController

%property (retain,nonatomic) MSHView *mshView;

-(void)loadView{
    %orig;
    mshConfig.waveOffsetOffset = self.view.bounds.size.height - 200;

    if (![mshConfig view]) [mshConfig initializeViewWithFrame:self.view.bounds];
    self.mshView = [mshConfig view];
    
    [self.view addSubview:self.mshView];
    [self.view bringSubviewToFront:self.mshView];
}

-(void)viewDidLayoutSubviews {
    %orig;
    [self.view bringSubviewToFront:self.mshView];
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    [self.mshView start];
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [self.mshView stop];
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
    mshConfig = [MSHConfig loadConfigForApplication:@"LockScreen"];
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)screenDisplayStatus, (CFStringRef)@"com.apple.iokit.hid.displayStatus", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    %init(MitsuhaVisuals);
}
