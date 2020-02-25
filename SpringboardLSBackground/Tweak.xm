#import "Tweak.h"
#import <MediaRemote/MediaRemote.h>
#import <notify.h>

bool moveIntoPanel = false;
MSHFConfig *config;

%group ios13

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

%hook CSFixedFooterViewController

%property (retain,nonatomic) MSHFView *mshfview;

-(void)loadView{
    %orig;
    config.waveOffsetOffset = self.view.bounds.size.height - 200;

    if (![config view]) [config initializeViewWithFrame:self.view.bounds];
    self.mshfview = [config view];
    
    [self.view addSubview:self.mshfview];
    [self.view bringSubviewToFront:self.mshfview];
}

-(void)viewDidLayoutSubviews {
    %orig;
    [self.view bringSubviewToFront:self.mshfview];
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    if(self.mshfview && [config view]) {
        [self.mshfview start];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    if(self.mshfview && [config view]) {
        [self.mshfview stop];
    }
}

%end

%end

%group old

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

%hook SBDashBoardFixedFooterViewController

%property (retain,nonatomic) MSHFView *mshfview;

-(void)loadView{
    %orig;
    config.waveOffsetOffset = self.view.bounds.size.height - 200;

    if (![config view]) [config initializeViewWithFrame:self.view.bounds];
    self.mshfview = [config view];
    
    [self.view addSubview:self.mshfview];
    [self.view bringSubviewToFront:self.mshfview];
}

-(void)viewDidLayoutSubviews {
    %orig;
    [self.view bringSubviewToFront:self.mshfview];
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    if(self.mshfview && [config view]) {
        [self.mshfview start];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    if(self.mshfview && [config view]) {
        [self.mshfview stop];
    }
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
    config = [MSHFConfig loadConfigForApplication:@"LockScreen"];
    
    if(config.enabled){
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)screenDisplayStatus, (CFStringRef)@"com.apple.iokit.hid.displayStatus", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
        if(@available(iOS 13.0, *)) {
		    NSLog(@"[MitsuhaForever: SpringboardLSBackground] Current version is iOS 13!");
		    %init(ios13)
	    } else {
            %init(old)
        }
    }
}
