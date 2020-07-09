//
//  Tweak.h
//  Mitsuha2
//
//  Created by c0ldra1n on 12/10/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//


#import <MitsuhaForever/MSHFConfig.h>
#import <MitsuhaForever/MSHFView.h>

#import "../MSHFUtils.h"

@interface CSMediaControlsViewController : UIViewController
@property(retain, nonatomic) MSHFView *mshfView;

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;
- (void)readjustWaveColor;
- (void)readjustUIColor:(UIColor *)currentColor;
- (BOOL)handleEvent:(id)event;
@end

@interface MRPlatterViewController : UIViewController
@end

@interface MediaControlsHeaderView : UIView
@property(retain, nonatomic) UIImageView *artworkView;
@end

@interface MediaControlsPanelViewController : UIViewController
@property(retain, nonatomic) MediaControlsHeaderView *headerView;
@property(nonatomic, retain) MediaControlsHeaderView *nowPlayingHeaderView;
@property(retain, nonatomic) MSHFView *mshfview;
@property(retain, nonatomic) NSString *label;

- (BOOL)handleEvent:(id)event;
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;
- (void)readjustWaveColor;
- (void)setStyle:(NSInteger)style;
@end

@interface SBDashBoardMediaControlsViewController : UIViewController {
  MediaControlsPanelViewController *_mediaControlsPanelViewController;
}
@property(retain, nonatomic) MSHFView *mshfView;

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;
- (void)readjustWaveColor;
- (void)readjustUIColor:(UIColor *)currentColor;
- (BOOL)handleEvent:(id)event;
@end