//
//  Tweak.h
//  Mitsuha2
//
//  Created by c0ldra1n on 12/10/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <MitsuhaForever/MSHFConfig.h>
#import <MitsuhaForever/MSHFView.h>
#import <UIKit/UIKit.h>

@interface MusicArtworkComponentImageView : UIImageView
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;
- (void)readjustWaveColor;
@end

@interface MusicNowPlayingControlsViewController : UIViewController
@property(retain, nonatomic) MSHFView *mshview;
@end
