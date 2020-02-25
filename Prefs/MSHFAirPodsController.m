#import "MSHFAirPodsController.h"
#import "MSHFPrefsListController.h"

NSUserDefaults *userDefaults;

@implementation MSHFAirPodsController

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