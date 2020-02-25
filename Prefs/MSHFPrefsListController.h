#import "../MSHFUtils.h"
#import <CTDPrefs/CTDPrefs.h>
#import <spawn.h>

@interface MSHFPrefsListController : CTDListController
- (void)resetPrefs:(id)sender;
- (void)respring:(id)sender;
- (void)restartmsd:(id)sender;
@end