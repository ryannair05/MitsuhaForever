#import "MSHFPrefsListController.h"
#import "MSHFAppPrefsListController.h"

@implementation MSHFPrefsListController
- (instancetype)init {
    self = [super init];

    if (self) {
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        appearanceSettings.tintColor = [UIColor colorWithRed:238.0f / 255.0f
                                                   green:100.0f / 255.0f
                                                    blue:92.0f / 255.0f
                                                   alpha:1];
        appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
        self.hb_appearanceSettings = appearanceSettings;

        UIBarButtonItem *respringItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(respring:)];
    self.navigationItem.rightBarButtonItem = respringItem;
    }

    return self;
}

- (id)specifiers {
    return _specifiers;
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {
    _specifiers = [[self loadSpecifiersFromPlistName:@"Prefs" target:self] retain];

    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *directory = MSHFAppSpecifiersDirectory;
    NSArray *appPlists = [manager contentsOfDirectoryAtPath:directory error:nil];
    NSMutableArray *appSpecifiers = [NSMutableArray new];
    
    for (NSString *filename in appPlists) {
        NSString *path = [directory stringByAppendingPathComponent:filename];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:path];

        if (plist) {
            NSString *name = plist[@"name"] ?: [filename stringByReplacingOccurrencesOfString:@".plist" withString:@""];
            NSString *title = plist[@"title"] ?: name;
            PSSpecifier *spec = [PSSpecifier preferenceSpecifierNamed:title target:nil set:nil get:nil detail:[MSHFAppPrefsListController class] cell:2 edit:nil];
            [spec setProperty:name forKey:@"MSHFApp"];
            
            if (plist[@"important"]) {
                [appSpecifiers insertObject:spec atIndex:0];
            } else {
                [appSpecifiers addObject:spec];
            }
        }
    }

    for (PSSpecifier *spec in [appSpecifiers reverseObjectEnumerator]) {
        [self insertSpecifier:spec afterSpecifierID:@"apps"];
    }

    [self setTitle:@"Mitsuha Forever"];
    [self.navigationItem setTitle:@"Mitsuha Forever"];
}

- (void)setSpecifier:(PSSpecifier *)specifier {
	[self loadFromSpecifier:specifier];
	[super setSpecifier:specifier];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;
	
    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.translucent = YES;
}

- (void)resetPrefs:(id)sender {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:MSHFPreferencesIdentifier];
    [prefs removeAllObjects];

    HBPreferences *colors = [[HBPreferences alloc] initWithIdentifier:MSHFColorsIdentifier];
    [colors removeAllObjects];

    [self respring:sender];
}

- (void)respring:(id)sender {
	pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (void)restartmsd:(id)sender {
	pid_t pid;
    const char* args[] = {"killall", "mediaserverd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (bool)shouldReloadSpecifiersOnResume {
    return false;
}
@end