#import <MitsuhaForever/MSHFConfig.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>

@interface PSListController (Method)
-(BOOL)containsSpecifier:(id)arg1;
@end

@interface MSHFAppPrefsListController : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@property (nonatomic, retain) NSString *appName;
@end
