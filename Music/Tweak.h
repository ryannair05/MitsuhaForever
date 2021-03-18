//
//  Tweak.h
//  Mitsuha2
//
//  Created by c0ldra1n on 12/10/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <MitsuhaForever/MSHFConfig.h>

@interface MusicArtworkComponentImageView : UIImageView
@end

@interface MusicNowPlayingControlsViewController : UIViewController
@property(retain, nonatomic) MSHFView *mshfView;
@end

@interface CFWPrefsManager : NSObject
+ (id)sharedInstance;
@end

@interface CFWColorInfo : NSObject
@property (nonatomic, strong, readwrite) UIColor *primaryColor;
@end

@interface CFWMusicStateManager : NSObject
@property (atomic, strong, readonly) CFWColorInfo *colorInfo;
+ (id)sharedInstance;
@end
