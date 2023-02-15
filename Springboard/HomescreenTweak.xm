#import "Tweak.h"
#import <MediaRemote/MediaRemote.h>
#import <notify.h>

static MSHFConfig *mshConfig;

%group SBMediaHook
%hook SBMediaController

-(void)setNowPlayingInfo:(id)arg1 {
    %orig;
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        if (information && CFDictionaryContainsKey(information, kMRMediaRemoteNowPlayingInfoArtworkData)) {
            [mshConfig colorizeView:[UIImage imageWithData:(__bridge NSData*)CFDictionaryGetValue(information, kMRMediaRemoteNowPlayingInfoArtworkData)]];
        }
    });
}
%end
%end

%hook SBIconController

%property (strong,nonatomic) MSHFView *mshfView;

-(void)loadView{
    %orig;
    mshConfig.waveOffsetOffset = self.view.bounds.size.height - 200;
    if (![mshConfig view]) [mshConfig initializeViewWithFrame:self.view.bounds];
    self.mshfView = [mshConfig view];
    
    [[self view] insertSubview:self.mshfView atIndex:1];

    self.mshfView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mshfView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.mshfView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.mshfView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.mshfView.heightAnchor constraintEqualToConstant:self.mshfView.frame.size.height].active = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    [self.mshfView start];
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [self.mshfView stop];
}

%end

static void screenDisplayStatus(CFNotificationCenterRef center, void* o, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
    if(@available(iOS 13.0, *)) {
        [[mshConfig view] stop];
    }
    else if ([[%c(SBMediaController) sharedInstance] isPlaying]) {
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
    else {
        [[mshConfig view] stop];
    }
}

%ctor{
    mshConfig = [MSHFConfig loadConfigForApplication:@"HomeScreen"];
    if(mshConfig.enabled){
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)screenDisplayStatus, (CFStringRef)@"com.apple.iokit.hid.displayStatus", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
        
        %init;
        %init(SBMediaHook);
    }
}
