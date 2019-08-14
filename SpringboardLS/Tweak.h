//
//  Tweak.h
//  Mitsuha2
//
//  Created by c0ldra1n on 12/10/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Mitsuha/MSHView.h>
#import <MitsuhaInfinity/MSHConfig.h>

#import "../MSHUtils.h"

@interface MediaControlsHeaderView : UIView
@property (retain,nonatomic) UIImageView *artworkView;
@end

@interface MediaControlsTimeControl : UIControl
@property (retain,nonatomic) UILabel *elapsedTimeLabel;
@property (retain,nonatomic) UIView *elapsedTrack;

@property (retain,nonatomic) UILabel *remainingTimeLabel;
@property (retain,nonatomic) UIView *remainingTrack;

@property (retain,nonatomic) UIView *knobView;

@property (retain,nonatomic) UIImageView *liveBackground;
@property (retain,nonatomic) UILabel *liveLabel;
@end

@interface MediaControlsTransportButton : UIButton

@end

@interface MediaControlsTransportStackView : UIView
@property (retain,nonatomic) MediaControlsTransportButton *leftButton;
@property (retain,nonatomic) MediaControlsTransportButton *middleButton;
@property (retain,nonatomic) MediaControlsTransportButton *rightButton;
@end

@interface MediaControlsContainerView : UIView
@property (retain,nonatomic) MediaControlsTimeControl *mediaControlsTimeControl;
@property (retain,nonatomic) MediaControlsTransportStackView *mediaControlsTransportStackView;

-(void)setStyle:(NSInteger)style;
@end

@interface MediaControlsParentContainerView : UIView
@property (retain,nonatomic) MediaControlsContainerView *mediaControlsContainerView;
@end

@interface MediaControlsPanelViewController : UIViewController
@property (retain,nonatomic) MediaControlsHeaderView *headerView;
@property (nonatomic,retain) MediaControlsHeaderView *nowPlayingHeaderView;
@property (retain,nonatomic) MediaControlsParentContainerView *parentContainerView;
@property (retain,nonatomic) MSHView *mshView;
@property (retain,nonatomic) NSString *label;

-(BOOL)handleEvent:(id)event;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
-(void)readjustWaveColor;
-(void)setStyle:(NSInteger)style;
@end

@interface SBDashBoardMediaControlsViewController : UIViewController {
    MediaControlsPanelViewController *_mediaControlsPanelViewController;
}
@property (retain,nonatomic) MSHView *mshView;

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
-(void)readjustWaveColor;
-(void)readjustUIColor:(UIColor*)currentColor;
-(BOOL)handleEvent:(id)event;
@end