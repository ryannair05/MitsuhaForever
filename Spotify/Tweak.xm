#import "Tweak.h"
#define CFWBackgroundViewTagNumber 896541
#define MSHColorFlowInstalled [%c(CFWPrefsManager) class]
#define MSHColorFlowMusicEnabled MSHookIvar<BOOL>([%c(CFWPrefsManager) sharedInstance], "_musicEnabled")
#define MSHColorFlowSpotifyEnabled MSHookIvar<BOOL>([%c(CFWPrefsManager) sharedInstance], "_spotifyEnabled")
#define MSHCustomCoverInstalled [%c(CustomCoverAPI) class]

static SPTUniversalController *currentBackgroundMusicVC;
UIColor *const kTrans = [[UIColor whiteColor] colorWithAlphaComponent:0.5];

%group MitsuhaVisuals

MSHConfig *mshConfig = NULL;

%hook SPTGeniusNowPlayingViewCoverArtView

-(void)layoutSubviews {
    %orig;
    [mshConfig colorizeView:self.image];
}

%end

%hook SPTNowPlayingContentCell

-(void)setSelected:(BOOL)selected {
    %orig;
    if (selected) {
        [mshConfig colorizeView:self.cellContentRepresentation];
    }
}

%end

%hook SPTNowPlayingCoverArtViewCell

-(void)setSelected:(BOOL)selected {
    %orig;
    if (selected) {
        [mshConfig colorizeView:self.cellContentRepresentation];
    }
}

%end

%hook SPTNowPlayingShowsFormatBackgroundViewController
%property (retain,nonatomic) MSHView *mshView;

-(void)viewDidLoad{
    %orig;

    NSLog(@"[Mitsuha]: viewDidLoad");
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;

    CGFloat height = CGRectGetHeight(self.view.bounds) - mshConfig.waveOffset;
    
    [mshConfig initializeViewWithFrame:CGRectMake(0, mshConfig.waveOffset, self.view.bounds.size.width, height)];
    self.mshView = [mshConfig view];
    [self.view addSubview:self.mshView];
    [self applyCustomLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    [[mshConfig view] start];
    %orig;
    [mshConfig view].shouldUpdate = true;
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [mshConfig view].center = CGPointMake([mshConfig view].center.x, [mshConfig view].frame.size.height/2 + mshConfig.waveOffset);
        
    } completion:nil];
    
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;
    
    //  Copied from NowPlayingImpl
    if(MSHColorFlowInstalled && MSHColorFlowSpotifyEnabled){
        CFWSpotifyStateManager *stateManager = [%c(CFWSpotifyStateManager) sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [[mshConfig view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [[mshConfig view] stop];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [mshConfig view].center = CGPointMake([mshConfig view].center.x, [mshConfig view].frame.size.height + mshConfig.waveOffset);
    } completion:^(BOOL finished){
        [mshConfig view].shouldUpdate = false;
    }];
}

-(void)viewDidLayoutSubviews{
    %orig;
    [self applyCustomLayout];
}

%new
-(void)applyCustomLayout{
    [self.view bringSubviewToFront:[mshConfig view]];
}

%end

%hook SPTNowPlayingScrollViewController

%property (retain,nonatomic) MSHView *mshView;

-(void)viewDidLoad{
    %orig;

    NSLog(@"[Mitsuha]: viewDidLoad");
    
    CGFloat height = CGRectGetHeight(self.view.bounds) - mshConfig.waveOffset;
    [mshConfig initializeViewWithFrame:CGRectMake(0, mshConfig.waveOffset, self.view.bounds.size.width, height)];
    self.mshView = [mshConfig view];
    [self.view insertSubview:self.mshView atIndex:2];
}

-(void)viewWillAppear:(BOOL)animated{
    [[mshConfig view] start];
    %orig;
    [mshConfig view].shouldUpdate = true;
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [mshConfig view].center = CGPointMake([mshConfig view].center.x, [mshConfig view].frame.size.height/2 + mshConfig.waveOffset);
        
    } completion:nil];
    
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;
    
    //  Copied from NowPlayingImpl
    if(MSHColorFlowInstalled && MSHColorFlowSpotifyEnabled){
        CFWSpotifyStateManager *stateManager = [%c(CFWSpotifyStateManager) sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [[mshConfig view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [[mshConfig view] stop];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [mshConfig view].center = CGPointMake([mshConfig view].center.x, [mshConfig view].frame.size.height + mshConfig.waveOffset);
    } completion:^(BOOL finished){
        [mshConfig view].shouldUpdate = false;
    }];
}

%end

%hook SPTNowPlayingBackgroundMusicViewController

%property (retain,nonatomic) MSHView *mshView;

-(void)viewDidLoad{
    %orig;

    NSLog(@"[Mitsuha]: viewDidLoad");
    
    CGFloat height = CGRectGetHeight(self.view.bounds) - mshConfig.waveOffset;
    [mshConfig initializeViewWithFrame:CGRectMake(0, mshConfig.waveOffset, self.view.bounds.size.width, height)];
    self.mshView = [mshConfig view];
    [self.view addSubview:self.mshView];
    [self applyCustomLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    [[mshConfig view] start];
    %orig;
    [mshConfig view].shouldUpdate = true;
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [mshConfig view].center = CGPointMake([mshConfig view].center.x, [mshConfig view].frame.size.height/2 + mshConfig.waveOffset);
        
    } completion:nil];
    
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;
    
    //  Copied from NowPlayingImpl
    if(MSHColorFlowInstalled && MSHColorFlowSpotifyEnabled){
        CFWSpotifyStateManager *stateManager = [%c(CFWSpotifyStateManager) sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [[mshConfig view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [[mshConfig view] stop];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [mshConfig view].center = CGPointMake([mshConfig view].center.x, [mshConfig view].frame.size.height + mshConfig.waveOffset);
    } completion:^(BOOL finished){
        [mshConfig view].shouldUpdate = false;
    }];
}

-(void)viewDidLayoutSubviews{
    %orig;
    [self applyCustomLayout];
}

%new
-(void)applyCustomLayout{
    [self.view bringSubviewToFront:[mshConfig view]];
}

%end

%hook SPTImageBlurView

-(void)layoutSubviews{
    %orig;
    [self applyCustomLayout];
}

-(void)updateBlurIntensity{
    %orig;
    [self applyCustomLayout];
}

-(void)updateFocusIfNeeded{
    %orig;
    [self applyCustomLayout];
}

%new
-(void)applyCustomLayout{
    if(MSHColorFlowInstalled){
        if([self viewWithTag:CFWBackgroundViewTagNumber]){
            [[self viewWithTag:CFWBackgroundViewTagNumber] removeFromSuperview];
        }
    }
}

%new
-(void)updateGradientDark:(BOOL)darkbackground{
    if(MSHColorFlowInstalled && MSHColorFlowSpotifyEnabled){
        NSArray<UIColor *> *colors;
        
        if(darkbackground){
            colors = @[(id)[UIColor colorWithWhite:0 alpha:0.6].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor, (id)[UIColor clearColor].CGColor];
        }else{
            colors = @[(id)[UIColor colorWithWhite:0 alpha:1].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.5].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.25].CGColor];
        }
        
        for(CALayer *layer in [self.tintView.layer sublayers]){
            if([layer.name isEqualToString:@"GLayer"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"[Mitsuha]: Dark Background? %d\n%@", darkbackground, colors);
                    CAGradientLayer *gradient = (CAGradientLayer *)layer;
                    gradient.colors = colors;
                    [gradient setNeedsDisplay];
                });
            }
        }
    }
}

%end

%hook SPTNowPlayingModel

-(void)player:(id)arg1 stateDidChange:(id)arg2 fromState:(id)arg3{
    %orig;
    [self applyColorChange];
}

-(void)updateWithPlayerState:(id)arg1{
    %orig;
    [self applyColorChange];
}

%new
-(void)applyColorChange{
    if(MSHColorFlowInstalled && MSHColorFlowSpotifyEnabled){
        if(!mshConfig.ignoreColorFlow){
            CFWColorInfo *colorInfo = [[%c(CFWSpotifyStateManager) sharedManager] mainColorInfo];
            UIColor *backgroundColor = [[colorInfo backgroundColor] colorWithAlphaComponent:0.5];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[mshConfig view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
                //[currentBackgroundMusicVC.backgroundView.backgroundImageBlurView updateGradientDark:colorInfo.backgroundDark];
            });
        }
    }
}

%end

%hook SpotifyAppDelegate

static BOOL registered;

-(void)applicationDidEnterBackground:(UIApplication *)application{
    [mshConfig view].shouldUpdate = false;
    
    if(!registered){
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(enableWave)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        registered = true;
    }
    
    %orig;
}

%new
-(void)enableWave{
    [mshConfig view].shouldUpdate = true;
}

%end

%end

%group MitsuhaSpotifyCoverArtFix

%hook SPTNowPlayingCarouselAreaViewController

static CGFloat originalCenterY = 0;

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    
    NSLog(@"[Mitsuha]: originalCenterY: %lf", originalCenterY);
    
    CGPoint center = self.view.coverArtView.center;
    
    self.view.coverArtView.alpha = 0;
    self.view.coverArtView.center = CGPointMake(center.x, originalCenterY);
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    
    NSLog(@"[Mitsuha]: viewDidAppear");
    
    CGPoint center = self.view.coverArtView.center;
    
    if(originalCenterY == 0){
        originalCenterY = center.y;
    }
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.coverArtView.alpha = 1.0;
        self.view.coverArtView.center = CGPointMake(center.x, originalCenterY * 0.8);
    } completion:^(BOOL finished){
        if(self.view.coverArtView.center.y != originalCenterY * 0.8){    //  For some reason I can't explain
            [UIView animateWithDuration:0.25 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.view.coverArtView.center = CGPointMake(center.x, originalCenterY * 0.8);
            } completion:nil];
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    
    CGPoint center = self.view.coverArtView.center;
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.coverArtView.alpha = 0;
        self.view.coverArtView.center = CGPointMake(center.x, originalCenterY);
    } completion:nil];
}

%end

%end

%ctor{
    mshConfig = [MSHConfig loadConfigForApplication:@"Spotify"];
    mshConfig.waveOffsetOffset = 520;

    if(mshConfig.enabled){
        %init(MitsuhaVisuals)
        if (mshConfig.enableCoverArtBugFix) %init(MitsuhaSpotifyCoverArtFix)
    }
}