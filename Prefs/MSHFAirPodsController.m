#import "MSHFAirPodsController.h"
#import "MSHFPrefsListController.h"

@implementation MSHFAirPodsController
- (instancetype)init {
  self = [super init];

  if (self) {
    HBAppearanceSettings *appearanceSettings =
        [[HBAppearanceSettings alloc] init];
    appearanceSettings.tintColor = [UIColor colorWithRed:238.0f / 255.0f
                                                   green:100.0f / 255.0f
                                                    blue:92.0f / 255.0f
                                                   alpha:1];
    appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0
                                                                       alpha:0];
    self.hb_appearanceSettings = appearanceSettings;
  }

  return self;
}

- (id)specifiers {
  if (_specifiers == nil) {
    _specifiers = [[self loadSpecifiersFromPlistName:@"AirPods"
                                              target:self] retain];
  }
  return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  CGRect frame = self.table.bounds;
  frame.origin.y = -frame.size.height;

  [self.navigationController.navigationController.navigationBar
      setShadowImage:[UIImage new]];
  self.navigationController.navigationController.navigationBar.translucent =
      YES;
}

- (bool)shouldReloadSpecifiersOnResume {
  return false;
}
@end