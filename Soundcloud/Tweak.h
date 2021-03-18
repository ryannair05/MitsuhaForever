//
//  Tweak.h
//  Mitsuha2
//
//  Created by c0ldra1n on 12/10/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <MitsuhaForever/MSHFConfig.h>

@interface PlayerArtworkView : UIView

@property(retain, nonatomic) UIImage *artworkImage;
@property(retain, nonatomic) UIImageView *artworkImageView;
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;
- (void)readjustWaveColor;

@end

@interface WaveFormController : UIView

@end

@interface TrackPlayerViewController : UIViewController

@property(retain, nonatomic) MSHFView *mshfView;

@end