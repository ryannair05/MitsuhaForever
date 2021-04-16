//
//  Tweak.h
//  Mitsuha2
//
//  Created by c0ldra1n on 12/10/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//


#import <MitsuhaForever/MSHFConfig.h>

#define ArtsyTweakDylibFile                                                    \
  @"/Library/MobileSubstrate/DynamicLibraries/Artsy.dylib"
#define PrysmTweakDylibFile                                                    \
  @"/Library/MobileSubstrate/DynamicLibraries/Prysm.dylib"
#define QuartTweakDylibFile                                                    \
  @"/Library/MobileSubstrate/DynamicLibraries/Quart.dylib"
#define FlowTweakDylibFile                                                     \
  @"/Library/MobileSubstrate/DynamicLibraries/Flow.dylib"
#define OrionTweakDylibFile                                                     \
  "/Library/MobileSubstrate/DynamicLibraries/OrionSpringboard.dylib"
#define ArtsyPreferencesFile                                                   \
@"/var/mobile/Library/Preferences/ch.mdaus.artsy.plist"
#define QuartPreferencesFile                                                   \
@"/var/mobile/Library/Preferences/com.laughingquoll.quartprefs.plist"
#define PrysmPreferencesFile                                                   \
@"/var/mobile/Library/Preferences/com.laughingquoll.prysmprefs.plist"

@interface MRUCoverSheetViewController : UIViewController
@property(retain, nonatomic) MSHFView *mshfView;
@end

@interface CSMediaControlsViewController : UIViewController
@property(retain, nonatomic) MSHFView *mshfView;
@end

@interface MRPlatterViewController : UIViewController
@property(retain, nonatomic) MSHFView *mshfView;
@end

@interface MRUNowPlayingViewController : UIViewController
@property(retain, nonatomic) MSHFView *mshfView;
@end

@interface MediaControlsPanelViewController : UIViewController
@property(retain, nonatomic) MSHFView *mshfView;
@end

@interface MediaControlsInteractionRecognizer : UIGestureRecognizer
@end

@interface SBDashBoardMediaControlsViewController : UIViewController
@property(retain, nonatomic) MSHFView *mshfView;
@end

@interface QRTMediaModuleViewController : UIViewController
@property(strong, nonatomic) MSHFView *mshfView;
@property(strong, nonatomic) UIImageView *artworkView;
@end

@interface SBDashBoardFixedFooterViewController : UIViewController

@property(strong, nonatomic) MSHFView *mshfview;

@end

@interface CSFixedFooterViewController : UIViewController

@property(strong, nonatomic) MSHFView *mshfview;

@end

@interface CFWPrefsManager : NSObject
+ (id)sharedInstance;
- (BOOL)lockScreenFullScreenEnabled;
@end

@interface OrionColorizer : NSObject
@property (nonatomic, strong, readonly) UIColor *secondaryColor;
+ (id)sharedInstance;
@end

@interface CFWColorInfo : NSObject
@property (nonatomic, strong, readwrite) UIColor *primaryColor;
@end

@interface CFWMusicStateManager : NSObject
@property (atomic, strong, readonly) CFWColorInfo *colorInfo;
+ (id)sharedInstance;
@end

@interface SBIconController : UIViewController
@property (nonatomic,retain) MSHFView * mshfView;     
@end

@interface MRUControlCenterViewController : UIViewController
@property (nonatomic,retain) MSHFView * mshfView;     
@end

@interface PrysmMediaModuleViewController : UIViewController
@property (nonatomic,retain) MSHFView * mshfView;     
@end