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

        NSMutableDictionary *dict = [specifier propertyForKey:@"libcolorpicker"];
        if (dict) {
            dict[@"key"] = [prefix stringByAppendingString:dict[@"key"]];
            [specifier setProperty:dict forKey:@"libcolorpicker"];
        }

        if ([specifier.name isEqualToString:@"%APP_NAME%"]) {
            specifier.name = title;
        }

        else if ([specifier propertyForKey:@"id"]) {
			[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
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
        
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {

    [super setPreferenceValue:value specifier:specifier];

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
