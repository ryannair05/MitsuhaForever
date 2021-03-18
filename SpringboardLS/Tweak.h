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
#define QuartTweakDylibFile                                                    \
  @"/Library/MobileSubstrate/DynamicLibraries/Quart.dylib"
#define FlowTweakDylibFile                                                     \
  @"/Library/MobileSubstrate/DynamicLibraries/Flow.dylib"
#define ArtsyPreferencesFile                                                   \
@"/var/mobile/Library/Preferences/ch.mdaus.artsy.plist"
#define QuartPreferencesFile                                                   \
@"/var/mobile/Library/Preferences/com.laughingquoll.quartprefs.plist"

@interface CSMediaControlsViewController : UIViewController
@property(retain, nonatomic) MSHFView *mshfView;
@end

@interface MRPlatterViewController : UIViewController
@end

@interface MediaControlsPanelViewController : UIViewController
@property(retain, nonatomic) MSHFView *mshfView;
@end

@interface SBDashBoardMediaControlsViewController : UIViewController
@property(retain, nonatomic) MSHFView *mshfView;
@end

@interface QRTMediaModuleViewController : UIViewController
@property(strong, nonatomic) MSHFView *mshfView;
@end

@interface SBDashBoardFixedFooterViewController : UIViewController

@property(strong, nonatomic) MSHFView *mshfview;

@end

@interface CSFixedFooterViewController : UIViewController

@property(strong, nonatomic) MSHFView *mshfview;

@end