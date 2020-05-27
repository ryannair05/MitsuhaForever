#import "Tweak.h"

%group MitsuhaVisuals

static MSHFConfig *config = NULL;

%hook MusicArtworkComponentImageView

-(void)layoutSubviews{
    %orig;
    if ([config view] == NULL) return;

    UIView *me = (UIView *)self;

    if(@available(iOS 13.0, *)) {
		if ([NSStringFromClass([me.superview class]) isEqualToString:@"MusicApplication.NowPlayingContentView"]) {
            if (config.colorMode != 2) {
                [self readjustWaveColor];
            }

            [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
        }
	} else {
		if ([NSStringFromClass([me.superview class]) isEqualToString:@"Music.NowPlayingContentView"]) {
            if (config.colorMode != 2) {
                [self readjustWaveColor];
            }

            [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
        }
    }
}

%new;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"] && config.colorMode != 2) {
        [self readjustWaveColor];
    }
}

%new;
-(void)readjustWaveColor{
    [config colorizeView:((MusicArtworkComponentImageView*)self).image];
}

%end

%hook MusicNowPlayingControlsViewController

%property (retain,nonatomic) MSHFView *mshfView;


-(void)viewDidLoad{
    %orig;

    self.view.subviews[3].clipsToBounds = 1;
    [config initializeViewWithFrame:CGRectMake(0, -150, self.view.frame.size.width, (self.view.frame.size.height / 2) - 100)];
    
    self.mshfView = [config view];
    [self.view.subviews[3] addSubview:[config view]];
    [self.view.subviews[3] sendSubviewToBack:[config view]];

    if(self.mshfView.superview == NULL) {
        self.mshfView = [config view];
        [self.view addSubview:[config view]];
        [self.view sendSubviewToBack:[config view]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    [[config view] start];
    [config view].center = CGPointMake([config view].center.x, 150);
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [[config view] stop];
}

-(void)viewDidLayoutSubviews {
    %orig;
    for (UIView *subview in self.view.subviews) {
        subview.backgroundColor = [UIColor clearColor];
    }
}

%end

%end

%ctor{
    config = [MSHFConfig loadConfigForApplication:@"Music"];
    config.waveOffsetOffset = 70;
    if(config.enabled){
        NSString *classString = nil;
        if(@available(iOS 13.0, *)) {
            classString = @"MusicApplication.ArtworkComponentImageView";
	    } else {
		    classString = @"Music.ArtworkComponentImageView";
        }
        
        %init(MitsuhaVisuals, MusicArtworkComponentImageView = NSClassFromString(classString));
    }
}
