#import "MSHAppPrefsListController.h"

@implementation MSHAppPrefsListController

- (id)specifiers {
    return _specifiers;
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {
    NSString *app = [specifier propertyForKey:@"MSHApp"];
    if (!app) return;
    NSString *prefix = [@"MSH" stringByAppendingString:app];
    NSString *title = [specifier name];

    _specifiers = [[self loadSpecifiersFromPlistName:@"App" target:self] retain];

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

        [self reloadSpecifier:specifier];
    }

    NSMutableArray *extra = [[self loadSpecifiersFromPlistName:[NSString stringWithFormat:@"Apps/%@", app] target:self] retain];
    if (extra) {
        for (PSSpecifier *specifier in extra) {
            [self insertSpecifier:specifier afterSpecifierID:@"otherSettings"];
        }
    }
    [self setTitle:title];
    [self.navigationItem setTitle:title];
}

- (void)setSpecifier:(PSSpecifier *)specifier {
	[self loadFromSpecifier:specifier];
	[super setSpecifier:specifier];
}

- (bool)shouldReloadSpecifiersOnResume {
    return false;
}
@end