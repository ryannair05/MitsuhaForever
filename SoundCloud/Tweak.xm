#import "Tweak.h"

%group MitsuhaVisuals

MSHFConfig *MSHFConfig = NULL;

%hook PlayerArtworkView

-(void)layoutSubviews{
    %orig;
    if ([MSHFConfig view] == NULL) return;
    if (!self.superview) return;
    if (!self.superview.nextResponder) return;
    if (![NSStringFromClass([self.superview.nextResponder class]) isEqualToString:@"TrackPlayerViewController"]) return;

    if (MSHFConfig.colorMode != 2) {
        [self readjustWaveColor];
    }

    [self addObserver:self forKeyPath:@"artworkImage" options:NSKeyValueObservingOptionNew context:NULL];
}

%new;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"artworkImage"] && MSHFConfig.colorMode != 2) {
        [self readjustWaveColor];
    }
}

%new;
-(void)readjustWaveColor{
    [MSHFConfig colorizeView:((PlayerArtworkView*)self).artworkImage];
}

%end

%hook TrackPlayerViewController

%property (retain,nonatomic) MSHFView *MSHFView;

-(void)loadView {
    %orig;

    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.view.clipsToBounds = 1;
    
    [MSHFConfig initializeViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];

    self.MSHFView = [MSHFConfig view];
    [self.view insertSubview:[MSHFConfig view] atIndex:2];
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    
    [[MSHFConfig view] removeFromSuperview];
    [self.view insertSubview:[MSHFConfig view] atIndex:2];

    [[MSHFConfig view] start];
    [MSHFConfig view].center = CGPointMake([MSHFConfig view].center.x, [MSHFConfig view].frame.size.height);
}

%end

%end

%ctor{
    MSHFConfig = [MSHFConfig loadConfigForApplication:@"SoundCloud"];
    MSHFConfig.waveOffsetOffset = 70;
    
    if(MSHFConfig.enabled){
        %init(MitsuhaVisuals);
    }
}
