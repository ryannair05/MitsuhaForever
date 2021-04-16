#import "MSHFAppPrefsListController.h"

@implementation MSHFAppPrefsListController

- (NSArray *)specifiers {
    return _specifiers;
}

- (void)setSpecifier:(PSSpecifier *)specifier {
    [super setSpecifier:specifier];

    self.appName = [specifier propertyForKey:@"MSHFApp"];
    if (!self.appName) return;
    NSString *prefix = [@"MSHF" stringByAppendingString:self.appName];
    NSString *title = [specifier name];
    self.savedSpecifiers = [[NSMutableDictionary alloc] init];

    _specifiers = [self loadSpecifiersFromPlistName:@"App" target:self];

    for (PSSpecifier *specifier in _specifiers) {
        NSString *key = [specifier propertyForKey:@"key"];
        if (key) {
            [specifier setProperty:[prefix stringByAppendingString:key] forKey:@"key"];
        }

        if ([specifier.name isEqualToString:@"%APP_NAME%"]) {
            specifier.name = title;
        }

        else if ([specifier propertyForKey:@"id"]) {
			[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
		}
    }

    NSArray *extra = [self loadSpecifiersFromPlistName:[NSString stringWithFormat:@"Apps/%@", self.appName] target:self];
    if (extra) {
        for (PSSpecifier *specifier in extra) {
            [self insertSpecifier:specifier afterSpecifierID:@"otherSettings"];
        }
    }

    [self setTitle:title];
}

-(void)removeBarText:(bool)animated {
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"BarText"]] animated:animated];
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"BarSpacingText"]] animated:animated];
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"BarSpacing"]] animated:animated];
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"BarRadiusText"]] animated:animated];
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"BarRadius"]] animated:animated];
}
-(void)removeLineText:(bool)animated {
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"LineText"]] animated:animated];
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"LineThicknessText"]] animated:animated];
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"LineThickness"]] animated:animated];
}

-(void)viewDidLoad {
    [super viewDidLoad];

    MSHFConfig *config = [MSHFConfig loadConfigForApplication:self.appName];

    if (config.style != 1) {
        [self removeBarText:NO];
        if (config.style != 2) {
            [self removeLineText:NO];
        }
    } else {
        [self removeLineText:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    self.table.separatorColor = [UIColor colorWithWhite:0 alpha:0];

    UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] firstObject];

    if ([keyWindow respondsToSelector:@selector(setTintColor:)]) {
        keyWindow.tintColor = [UIColor colorWithRed:238.0f / 255.0f
                                                green:100.0f / 255.0f
                                                blue:92.0f / 255.0f
                                                alpha:1]; 
	}

    [UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]].onTintColor = [UIColor colorWithRed:238.0f / 255.0f
                                            green:100.0f / 255.0f
                                            blue:92.0f / 255.0f
                                            alpha:1]; 


	if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
	}
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
  NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
  NSMutableDictionary *settings = [NSMutableDictionary dictionary];
  [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];

  return ([settings objectForKey:specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {

    NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];

    [settings setObject:value forKey:specifier.properties[@"key"]];
    [settings writeToFile:path atomically:YES];

    CFStringRef notificationName = (__bridge CFStringRef) specifier.properties[@"PostNotification"];
    if (notificationName) {
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"com.ryannair05.mitsuhaforever/ReloadPrefs" object:nil];
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
    }

    NSString const *key = [specifier propertyForKey:@"key"];

    if ([key containsString:@"Style"]){
        if ([value integerValue] == 1) {
            if (![self containsSpecifier:self.savedSpecifiers[@"BarText"]]) {

                [self insertContiguousSpecifiers:@[self.savedSpecifiers[@"BarText"]] afterSpecifierID:@"NumberOfPoints" animated:YES];
                [self insertContiguousSpecifiers:@[self.savedSpecifiers[@"BarSpacingText"]] afterSpecifierID:@"BarText" animated:YES];
                [self insertContiguousSpecifiers:@[self.savedSpecifiers[@"BarSpacing"]] afterSpecifierID:@"BarSpacingText" animated:YES];
                [self insertContiguousSpecifiers:@[self.savedSpecifiers[@"BarRadiusText"]] afterSpecifierID:@"BarSpacing" animated:YES];
                [self insertContiguousSpecifiers:@[self.savedSpecifiers[@"BarRadius"]] afterSpecifierID:@"BarRadiusText" animated:YES];

                if ([self containsSpecifier:self.savedSpecifiers[@"LineText"]]) {
                    [self removeLineText:YES];
                }
            }
        }
        else if ([value integerValue] == 2) {

            if (![self containsSpecifier:self.savedSpecifiers[@"LineText"]]) {

                if ([self containsSpecifier:self.savedSpecifiers[@"BarText"]]) {
                    [self removeBarText:YES];
                }

                [self insertContiguousSpecifiers:@[self.savedSpecifiers[@"LineText"]] afterSpecifierID:@"NumberOfPoints" animated:YES];
                [self insertContiguousSpecifiers:@[self.savedSpecifiers[@"LineThicknessText"]] afterSpecifierID:@"LineText" animated:YES];
                [self insertContiguousSpecifiers:@[self.savedSpecifiers[@"LineThickness"]] afterSpecifierID:@"LineThicknessText" animated:YES];

            }
        }
        else if ([self containsSpecifier:self.savedSpecifiers[@"BarText"]]) {
            [self removeBarText:YES];
        }
        else if ([self containsSpecifier:self.savedSpecifiers[@"LineText"]]) {
            [self removeLineText:YES];
        }
    }

}

- (bool)shouldReloadSpecifiersOnResume {
    return NO;
}
@end
