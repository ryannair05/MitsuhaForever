#import "Tweak.h"

%group MitsuhaVisuals

MSHConfig *mshConfig = NULL;

%hook PlayerArtworkView

-(void)layoutSubviews{
    %orig;
    if ([mshConfig view] == NULL) return;
    if (!self.superview) return;
    if (!self.superview.nextResponder) return;
    if (![NSStringFromClass([self.superview.nextResponder class]) isEqualToString:@"TrackPlayerViewController"]) return;

    if (mshConfig.colorMode != 2) {
        [self readjustWaveColor];
    }

    [self addObserver:self forKeyPath:@"artworkImage" options:NSKeyValueObservingOptionNew context:NULL];
}

%new;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"artworkImage"] && mshConfig.colorMode != 2) {
        [self readjustWaveColor];
    }
}

%new;
-(void)readjustWaveColor{
    [mshConfig colorizeView:((PlayerArtworkView*)self).artworkImage];
}

%end

%hook TrackPlayerViewController

%property (retain,nonatomic) MSHView *mshView;

-(void)loadView {
    %orig;

    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.view.clipsToBounds = 1;
    
    [mshConfig initializeViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];

    self.mshView = [mshConfig view];
    [self.view insertSubview:[mshConfig view] atIndex:2];
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    
    [[mshConfig view] removeFromSuperview];
    [self.view insertSubview:[mshConfig view] atIndex:2];

    [[mshConfig view] start];
    [mshConfig view].center = CGPointMake([mshConfig view].center.x, [mshConfig view].frame.size.height);
}

%end

%end

%ctor{
    mshConfig = [MSHConfig loadConfigForApplication:@"SoundCloud"];
    mshConfig.waveOffsetOffset = 70;
    
    if(mshConfig.enabled){
        %init(MitsuhaVisuals);
    }
}
