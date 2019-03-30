#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <spawn.h>
#import "../MSHUtils.h"

@interface MSHPrefsListController : HBListController
    - (void)resetPrefs:(id)sender;
    - (void)respring:(id)sender;
    - (void)restartmsd:(id)sender;
@end