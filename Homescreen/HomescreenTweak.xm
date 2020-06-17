#import "Tweak.h"
#import <MediaRemote/MediaRemote.h>
#import <notify.h>

bool moveIntoPanel = false;
static MSHFConfig *mshConfig;

%group SBMediaHook
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
%end

%group ios13
%hook SBHomeScreenView

%property (nonatomic, strong) MSHFView *mshfView;

-(void)willMoveToSuperview:(UIView*)newSuperview {
    %orig;
    mshConfig.waveOffsetOffset = self.bounds.size.height - 200;

    if (![mshConfig view]) [mshConfig initializeViewWithFrame:self.bounds];
    self.mshfView = [mshConfig view];
    
    [self addSubview:self.mshfView];
    [self sendSubviewToBack:self.mshfView];
}

-(void)didMoveToWindow {
    %orig;
    [[mshConfig view] start];
}

-(void)didMoveToSuperview {
    %orig;
    
    if (!self.superview) {
        [[mshConfig view] stop];
    }
}

%end
%end

%group old
%hook SBIconController

%property (strong,nonatomic) MSHFView *mshfView;

-(void)loadView{
    %orig;
    mshConfig.waveOffsetOffset = self.view.bounds.size.height - 200;

    if (![mshConfig view]) [mshConfig initializeViewWithFrame:self.view.bounds];
    self.mshfView = [mshConfig view];
    
    [self.view addSubview:self.mshfView];
    [self.view sendSubviewToBack:self.mshfView];
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
    mshConfig = [MSHFConfig loadConfigForApplication:@"HomeScreen"];
    if(mshConfig.enabled){
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)screenDisplayStatus, (CFStringRef)@"com.apple.iokit.hid.displayStatus", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
        
        if(@available(iOS 13.0, *)) {
		    %init(ios13)
	    } else {
            %init(old)
        }

        %init(SBMediaHook);
    }
}
