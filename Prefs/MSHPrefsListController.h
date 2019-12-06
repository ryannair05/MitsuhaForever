#import "../MSHUtils.h"
#import <Cephei/HBPreferences.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <CepheiPrefs/HBRootListController.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <spawn.h>

@interface MSHPrefsListController : HBListController
- (void)resetPrefs:(id)sender;
- (void)respring:(id)sender;
- (void)restartmsd:(id)sender;
@end