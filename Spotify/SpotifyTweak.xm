#import "Tweak.h"
#define CFWBackgroundViewTagNumber 896541

bool MSHFColorFlowSpotifyEnabled = NO;

%group MitsuhaVisuals

MSHFConfig *config = NULL;

%hook SPTNowPlayingCoverArtImageView

-(void)setImage:(UIImage*)image {
    %orig;
    [config colorizeView:image];
}

%end

%hook SPTVideoDisplayView
- (void)refreshVideoRect {
    %orig;

    AVPlayer *displayView = [self player];
    AVAsset *asset = displayView.currentItem.asset;

    AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    UIImage* image = [UIImage imageWithCGImage:[generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
    if (image) [config colorizeView:image];
}

%end

%hook SPTNowPlayingViewController

%property (retain,nonatomic) MSHFView *mshfview;

-(void)viewDidLoad{
    %orig;

    NSLog(@"[Mitsuha]: viewDidLoad");
    
    if (![config view]) [config initializeViewWithFrame:CGRectMake(0, config.waveOffset, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mshfview = [config view];
    [self.mshfview setUserInteractionEnabled:NO];

    [self.view insertSubview:self.mshfview atIndex:1];

    self.mshfview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mshfview.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.mshfview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.mshfview.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.mshfview.heightAnchor constraintEqualToConstant:self.mshfview.frame.size.height].active = YES;

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
    
    [[config view] resetWaveLayers];

    if (config.colorMode == 1) {
        [config colorizeView:nil];
    }
    //  Copied from NowPlayingImpl
    else if(MSHFColorFlowSpotifyEnabled){
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