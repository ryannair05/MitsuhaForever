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

@interface MusicArtworkComponentImageView : UIImageView
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
-(void)readjustWaveColor;
@end

@interface MusicNowPlayingControlsViewController : UIViewController
@property (retain,nonatomic) MSHView *mshView;
@end
