#import "Tweak.h"
#define CFWBackgroundViewTagNumber 896541
#define MSHFColorFlowInstalled [%c(CFWPrefsManager) class]
#define MSHFColorFlowMusicEnabled MSHookIvar<BOOL>([%c(CFWPrefsManager) sharedInstance], "_musicEnabled")
#define MSHFColorFlowSpotifyEnabled MSHookIvar<BOOL>([%c(CFWPrefsManager) sharedInstance], "_spotifyEnabled")
#define MSHFCustomCoverInstalled [%c(CustomCoverAPI) class]

static SPTUniversalController *currentBackgroundMusicVC;
UIColor *const kTrans = [[UIColor whiteColor] colorWithAlphaComponent:0.5];

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
        [config colorizeView:self.cellContentRepresentation];
    }
}

%end

%hook SPTNowPlayingCoverArtCell

-(void)setSelected:(BOOL)selected {
    %orig;
    [config colorizeView:self.imageView.image];
    [self.imageView layoutSubviews];
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
    [config view].shouldUpdate = true;
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height/2 + config.waveOffset);
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;
    
    //  Copied from NowPlayingImpl
    if(MSHFColorFlowInstalled && MSHFColorFlowSpotifyEnabled){
        CFWSpotifyStateManager *stateManager = [%c(CFWSpotifyStateManager) sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [[config view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [[config view] stop];
    [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height + config.waveOffset);
    [config view].shouldUpdate = false;
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

%hook SPTNowPlayingScrollViewController

%property (retain,nonatomic) MSHFView *mshfview;

-(void)viewDidLoad{
    %orig;

    NSLog(@"[Mitsuha]: viewDidLoad");
    
    CGFloat height = CGRectGetHeight(self.view.bounds) - config.waveOffset;
    [config initializeViewWithFrame:CGRectMake(0, config.waveOffset, self.view.bounds.size.width, height)];
    self.mshfview = [config view];
    [self.view insertSubview:self.mshfview atIndex:2];
}

-(void)viewWillAppear:(BOOL)animated{
    [[config view] start];
    %orig;
    [config view].shouldUpdate = true;
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height/2 + config.waveOffset);

    currentBackgroundMusicVC = (SPTUniversalController*)self;
    
    //  Copied from NowPlayingImpl
    if(MSHFColorFlowInstalled && MSHFColorFlowSpotifyEnabled){
        CFWSpotifyStateManager *stateManager = [%c(CFWSpotifyStateManager) sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [[config view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [[config view] stop];
    [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height + config.waveOffset);
    [config view].shouldUpdate = false;
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
    [config view].shouldUpdate = true;
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;        
    [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height/2 + config.waveOffset);    
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;
    
    //  Copied from NowPlayingImpl
    if(MSHFColorFlowInstalled && MSHFColorFlowSpotifyEnabled){
        CFWSpotifyStateManager *stateManager = [%c(CFWSpotifyStateManager) sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [[config view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [[config view] stop];
    [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height + config.waveOffset);
    [config view].shouldUpdate = false;
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
    if(MSHFColorFlowInstalled){
        if([self viewWithTag:CFWBackgroundViewTagNumber]){
            [[self viewWithTag:CFWBackgroundViewTagNumber] removeFromSuperview];
        }
    }
}

%new
-(void)updateGradientDark:(BOOL)darkbackground{
    if(MSHFColorFlowInstalled && MSHFColorFlowSpotifyEnabled){
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
    if(MSHFColorFlowInstalled && MSHFColorFlowSpotifyEnabled){
        if(!config.ignoreColorFlow){
            CFWColorInfo *colorInfo = [[%c(CFWSpotifyStateManager) sharedManager] mainColorInfo];
            UIColor *backgroundColor = [[colorInfo backgroundColor] colorWithAlphaComponent:0.5];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[config view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
                //[currentBackgroundMusicVC.backgroundView.backgroundImageBlurView updateGradientDark:colorInfo.backgroundDark];
            });
        }
    }
}

%end

%hook SpotifyAppDelegate

static BOOL registered;

-(void)applicationDidEnterBackground:(UIApplication *)application{
    [config view].shouldUpdate = false;
    
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
    [config view].shouldUpdate = true;
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
    
    self.view.coverArtView.alpha = 1.0;
    self.view.coverArtView.center = CGPointMake(center.x, originalCenterY * 0.8);
    if(self.view.coverArtView.center.y != originalCenterY * 0.8){    //  For some reason I can't explain
        self.view.coverArtView.center = CGPointMake(center.x, originalCenterY * 0.8);
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    
    CGPoint center = self.view.coverArtView.center;
    
    self.view.coverArtView.alpha = 0;
    self.view.coverArtView.center = CGPointMake(center.x, originalCenterY);
}

%end

%end

%ctor{
    config = [MSHFConfig loadConfigForApplication:@"Spotify"];
    config.waveOffsetOffset = 520;

    if(config.enabled){
        %init(MitsuhaVisuals)
        if (config.enableCoverArtBugFix) %init(MitsuhaSpotifyCoverArtFix)
    }
}