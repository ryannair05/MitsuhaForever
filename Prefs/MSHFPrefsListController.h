#import "MSHFAppPrefsListController.h"
#import <Preferences/PSHeaderFooterView.h>
#import <spawn.h>
#import <dlfcn.h>
#import <MitsuhaForever/MSHFUtils.h>

@interface MSHFPrefsListController : PSListController
- (void)resetPrefs:(id)sender;
- (void)respring:(id)sender;
- (void)restartmsd:(id)sender;
@end

@interface MSHFTintedTableCell : PSTableCell
@end

@interface MSHFLinkTableCell : MSHFTintedTableCell
@property (nonatomic, readonly) BOOL isBig;
@property (nonatomic, retain, readonly) UIView *avatarView;
@property (nonatomic, retain, readonly) UIImageView *avatarImageView;
@property (nonatomic, retain) UIImage *avatarImage;
@property (nonatomic, retain) NSURL *avatarURL;
@property (nonatomic, readonly) BOOL isAvatarCircular;
- (void)loadAvatarIfNeeded;
- (BOOL)shouldShowAvatar;
@end

@interface MSHFTwitterCell : MSHFLinkTableCell
@end

@interface MSHFTwitterCell ()  {
	NSString *_user;
}
@end

@interface MSHFPackageNameHeaderCell : PSTableCell <PSHeaderFooterView>
@end