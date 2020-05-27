#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <spawn.h>
#import <MitsuhaForever/MSHFUtils.h>

@interface MSHFPrefsListController : HBListController
    - (void)resetPrefs:(id)sender;
    - (void)respring:(id)sender;
    - (void)restartmsd:(id)sender;
@end