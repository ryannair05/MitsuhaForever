#import "Tweak.h"

// bool MSHFNeedsFirstPlayerInit = YES;

%group MitsuhaVisuals

MSHFConfig *config = NULL;

WaveFormController *waveController;

%hook PlayerArtworkView

-(void)layoutSubviews{
    %orig;
    if ([config view] == NULL) return;
    if (!self.superview) return;
    if (!self.superview.nextResponder) return;
    if (![NSStringFromClass([self.superview.nextResponder class]) isEqualToString:@"TrackPlayerViewController"]) return;

    if (config.colorMode != 2) {
        [self readjustWaveColor];
    }

    [self addObserver:self forKeyPath:@"artworkImage" options:NSKeyValueObservingOptionNew context:NULL];
}

%new;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"artworkImage"] && config.colorMode != 2) {
        [self readjustWaveColor];
    }
}

%new;
-(void)readjustWaveColor{
    [config colorizeView:((PlayerArtworkView*)self).artworkImage];
}

%end

%hook TrackPlayerViewController

%property (retain,nonatomic) MSHFView *mshfView;

-(void)loadView {
    %orig;

    NSLog(@"[Mitsuha]: viewLoaded");

    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);

    [config initializeViewWithFrame:CGRectMake(0, height + config.waveOffset, width, height)];

    self.mshfView = [config view];
    [self.view insertSubview:self.mshfView atIndex:20];

}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"[Mitsuha]: viewWillAppear");

    %orig;
    
    self.view.clipsToBounds = 1;

    [self.mshfView start];
}

%end

%end

%ctor{
    config = [MSHFConfig loadConfigForApplication:@"SoundCloud"];
    config.waveOffsetOffset = -130;
    
    if(config.enabled){
        %init(MitsuhaVisuals);
    }
}