//
//  MSHFUtils.h
//  Mitsuha
//
//  Created by c0ldra1n on 2/6/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MSHFPreferencesIdentifier @"me.conorthedev.mitsuhaforever"
#define MSHFColorsIdentifier @"me.conorthedev.mitsuhaforever.colors"
#define MSHFPreferencesChanged @"me.conorthedev.mitsuhaforever/ReloadPrefs"
#define MSHFColorsFile                                                         \
  @"/var/mobile/Library/Preferences/"                                          \
  @"me.conorthedev.mitsuhaforever.colors.plist"
#define MSHFAppSpecifiersDirectory                                             \
  @"/Library/PreferenceBundles/MitsuhaForeverPrefs.bundle/Apps"
#define SylphPreferencesFile                                                   \
  @"/var/mobile/Library/Preferences/ch.mdaus.sylph.plist"
#define SylphTweakDylibFile                                                    \
  @"/Library/MobileSubstrate/DynamicLibraries/Sylph.dylib"
#define SylphTweakPlistFile                                                    \
  @"/Library/MobileSubstrate/DynamicLibraries/Sylph.plist"
#define ArtsyPreferencesFile                                                   \
  @"/var/mobile/Library/Preferences/ch.mdaus.artsy.plist"
#define ArtsyTweakDylibFile                                                    \
  @"/Library/MobileSubstrate/DynamicLibraries/Artsy.dylib"
#define ArtsyTweakPlistFile                                                    \
  @"/Library/MobileSubstrate/DynamicLibraries/Artsy.plist"
#define MSHFAudioBufferSize 1024
#define ASSPort 44333

@interface NSUserDefaults (Private)
- (instancetype)_initWithSuiteName:(NSString *)suiteName
                         container:(NSURL *)container;
@end