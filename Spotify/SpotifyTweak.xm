#import "Tweak.h"
#define CFWBackgroundViewTagNumber 896541

bool MSHFColorFlowSpotifyEnabled = NO;
static SPTUniversalController *currentBackgroundMusicVC;

%group MitsuhaVisuals

MSHFConfig *config = NULL;

%hook SPTNowPlayingCoverArtImageView

-(void)setImage:(UIImage*)image {
    %orig;
    [config colorizeView:self.image];
}

%end


%hook SPTNowPlayingContentCell

-(void)setSelected:(BOOL)selected {
    %orig;
    if (selected) {
        if ([self respondsToSelector:@selector(cellContentRepresentation)]) {
                [config colorizeView:self.cellContentRepresentation];
        }
    }
}

%end


%hook SPTNowPlayingShowsFormatBackgroundViewController
%property (retain,nonatomic) MSHFView *mshfview;

-(void)viewDidLoad{
    %orig;

    NSLog(@"[Mitsuha]: viewDidLoad");
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;

    CGFloat height = CGRectGetHeight(self.view.bounds) - config.waveOffset;
    
    [config initializeViewWithFrame:CGRectMake(0, config.waveOffset, self.view.bounds.size.width, height)];
    self.mshfview = [config view];
    [self.view addSubview:self.mshfview];
    [self applyCustomLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    [[config view] start];
    %orig;
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height/2 + config.waveOffset);
        
    } completion:nil];
    
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;
    
    //  Copied from NowPlayingImpl
    if(MSHFColorFlowSpotifyEnabled){
        CFWSpotifyStateManager *stateManager = [%c(CFWSpotifyStateManager) sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [[config view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [[config view] stop];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height + config.waveOffset);
    } completion:^(BOOL finished){
    }];
}

-(void)viewDidLayoutSubviews{
    %orig;
    [self applyCustomLayout];
}

%new
-(void)applyCustomLayout{
    [self.view bringSubviewToFront:[config view]];
}

%end

%hook SPTNowPlayingViewController

%property (retain,nonatomic) MSHFView *mshfview;

-(void)viewDidLoad{
    %orig;

    NSLog(@"[Mitsuha]: viewDidLoad");
    
    CGFloat height = CGRectGetHeight(self.view.bounds) - config.waveOffset;
    [config initializeViewWithFrame:CGRectMake(0, config.waveOffset, self.view.bounds.size.width, height)];
    self.mshfview = [config view];
    [self.view insertSubview:self.mshfview atIndex:0];
}

-(void)viewWillAppear:(BOOL)animated{
    [[config view] start];
    %orig;
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height/2 + config.waveOffset);
        
    } completion:nil];
    
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;
    
    //  Copied from NowPlayingImpl
    if(MSHFColorFlowSpotifyEnabled){
        CFWSpotifyStateManager *stateManager = [%c(CFWSpotifyStateManager) sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [[config view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [[config view] stop];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height + config.waveOffset);
    } completion:^(BOOL finished){
    }];
}

%end

%hook SPTNowPlayingBackgroundMusicViewController

%property (retain,nonatomic) MSHFView *mshfview;

-(void)viewDidLoad{
    %orig;

    NSLog(@"[Mitsuha]: viewDidLoad");
    
    CGFloat height = CGRectGetHeight(self.view.bounds) - config.waveOffset;
    [config initializeViewWithFrame:CGRectMake(0, config.waveOffset, self.view.bounds.size.width, height)];
    self.mshfview = [config view];
    [self.view addSubview:self.mshfview];
    [self applyCustomLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    [[config view] start];
    %orig;
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height/2 + config.waveOffset);
        
    } completion:nil];
    
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;
    
    //  Copied from NowPlayingImpl
    if(MSHFColorFlowSpotifyEnabled){
        CFWSpotifyStateManager *stateManager = [%c(CFWSpotifyStateManager) sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [[config view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [[config view] stop];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height + config.waveOffset);
    } completion:^(BOOL finished){
    }];
}

-(void)viewDidLayoutSubviews{
    %orig;
    [self applyCustomLayout];
}

%new
-(void)applyCustomLayout{
    [self.view bringSubviewToFront:[config view]];
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
    if(MSHFColorFlowSpotifyEnabled){
        if([self viewWithTag:CFWBackgroundViewTagNumber]){
            [[self viewWithTag:CFWBackgroundViewTagNumber] removeFromSuperview];
        }
    }
}

%new
-(void)updateGradientDark:(BOOL)darkbackground{
    if(MSHFColorFlowSpotifyEnabled){
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
    if(MSHFColorFlowSpotifyEnabled){
        if(!config.ignoreColorFlow){
            CFWColorInfo *colorInfo = [[%c(CFWSpotifyStateManager) sharedManager] mainColorInfo];
            UIColor *backgroundColor = [[colorInfo backgroundColor] colorWithAlphaComponent:0.5];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[config view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
                // [currentBackgroundMusicVC.backgroundView.backgroundImageBlurView updateGradientDark:colorInfo.backgroundDark];
            });
        }
    }
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
    config = [MSHFConfig loadConfigForApplication:@"Spotify"];
    
    if(config.enabled){
        config.waveOffsetOffset = 520;
        
        if ([%c(CFWPrefsManager) class] && MSHookIvar<BOOL>([%c(CFWPrefsManager) sharedInstance], "_spotifyEnabled") && !config.ignoreColorFlow) {
            MSHFColorFlowSpotifyEnabled = YES;
        }
        %init(MitsuhaVisuals);
        if (config.enableCoverArtBugFix) %init(MitsuhaSpotifyCoverArtFix)
        
    }
}