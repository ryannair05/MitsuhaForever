#import <MitsuhaForever/MSHFConfig.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBListController.h>

@interface PSListController (Method)
-(BOOL)containsSpecifier:(id)arg1;
@end

@interface MSHFAppPrefsListController : HBListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@property (nonatomic, retain) NSString *appName;
@end
