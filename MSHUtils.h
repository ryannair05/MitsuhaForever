//
//  MSHUtils.h
//  Mitsuha
//
//  Created by c0ldra1n on 2/6/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MSHPreferencesIdentifier @"me.conorthedev.mitsuhaforever"
#define MSHColorsIdentifier @"me.conorthedev.mitsuhaforever.colors"
#define MSHPreferencesChanged @"me.conorthedev.mitsuhaforever/ReloadPrefs"
#define MSHColorsFile                                                          \
  @"/var/mobile/Library/Preferences/"                                          \
  @"me.conorthedev.mitsuhaforever.colors.plist"
#define MSHAppSpecifiersDirectory                                              \
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
#define MSHAudioBufferSize 1024
#define ASSPort 43333