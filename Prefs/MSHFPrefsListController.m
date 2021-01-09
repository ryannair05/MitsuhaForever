#import "MSHFPrefsListController.h"

@implementation MSHFPrefsListController
- (instancetype)init {
    self = [super init];

    if (self) {
        UIBarButtonItem *respringItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(respring:)];
        self.navigationItem.rightBarButtonItem = respringItem;
    }

    return self;
}

- (NSArray *)specifiers {
    if(!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Prefs" target:self];
    }
    return _specifiers;
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {
    _specifiers = [self loadSpecifiersFromPlistName:@"Prefs" target:self];

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
}

- (void)setSpecifier:(PSSpecifier *)specifier {
	[self loadFromSpecifier:specifier];
	[super setSpecifier:specifier];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

    self.table.separatorColor = [UIColor colorWithWhite:0 alpha:0];

    if ([self.view respondsToSelector:@selector(setTintColor:)]) {

        UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] firstObject];
        
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

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];

    if ([self.view respondsToSelector:@selector(setTintColor:)]) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] firstObject];
        keyWindow.tintColor = nil;
	}
}

- (void)resetPrefs:(id)sender {	

	NSString *plistPath = @"/User/Library/Preferences/com.ryannair05.mitsuhaforever.plist";

    if([[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
		[prefs removeAllObjects];
		[prefs writeToFile:plistPath atomically:YES];
	}

    [self respring:sender];
}

- (bool)shouldReloadSpecifiersOnResume {
    return NO;
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
@end


@implementation MSHFTintedTableCell

- (void)tintColorDidChange {
	[super tintColorDidChange];

	self.textLabel.textColor = [UIColor colorWithRed:238.0f / 255.0f
                                                   green:100.0f / 255.0f
                                                    blue:92.0f / 255.0f
                                                   alpha:1];
	self.textLabel.highlightedTextColor = [UIColor colorWithRed:238.0f / 255.0f
                                                   green:100.0f / 255.0f
                                                    blue:92.0f / 255.0f
                                                   alpha:1];
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
	[super refreshCellContentsWithSpecifier:specifier];

	if ([self respondsToSelector:@selector(tintColor)]) {
		self.textLabel.textColor = [UIColor colorWithRed:238.0f / 255.0f
                                                   green:100.0f / 255.0f
                                                    blue:92.0f / 255.0f
                                                   alpha:1];
		self.textLabel.highlightedTextColor = [UIColor colorWithRed:238.0f / 255.0f
                                                   green:100.0f / 255.0f
                                                    blue:92.0f / 255.0f
                                                   alpha:1];
	}
}

@end

@implementation MSHFLinkTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		_isBig = specifier.properties[@"big"] && ((NSNumber *)specifier.properties[@"big"]).boolValue;
		_isAvatarCircular = specifier.properties[@"avatarCircular"] && ((NSNumber *)specifier.properties[@"avatarCircular"]).boolValue;
		_avatarURL = [NSURL URLWithString:specifier.properties[@"avatarURL"]];

		self.selectionStyle = UITableViewCellSelectionStyleBlue;

		//UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"safari" inBundle:globalBundle]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"/Library/PreferenceBundles/MitsuhaForeverPrefs.bundle/safari.png"]]];
		    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		if (@available(iOS 13.0, *)) {
			imageView.tintColor = [UIColor systemGray3Color];
		}
		self.accessoryView = imageView;

		self.detailTextLabel.numberOfLines = _isBig ? 0 : 1;
		self.detailTextLabel.text = specifier.properties[@"subtitle"] ?: @"";
		if (@available(iOS 13.0, *)) {
				self.detailTextLabel.textColor = [UIColor secondaryLabelColor];
		} else {
			self.detailTextLabel.textColor = [UIColor systemGrayColor];
		}

		self.specifier = specifier;
		if (self.shouldShowAvatar) {NSLog(@"avatar? %i %@", self.shouldShowAvatar, self.specifier.properties);
			CGFloat size = _isBig ? 38.f : 29.f;

			UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, [UIScreen mainScreen].scale);
			specifier.properties[@"iconImage"] = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();

			_avatarView = [[UIView alloc] initWithFrame:self.imageView.bounds];
			_avatarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			_avatarView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1];
			_avatarView.userInteractionEnabled = NO;
			_avatarView.clipsToBounds = YES;
			[self.imageView addSubview:_avatarView];

			if (specifier.properties[@"initials"]) {
				_avatarView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1];

				UILabel *label = [[UILabel alloc] initWithFrame:_avatarView.bounds];
				label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
				label.font = [UIFont systemFontOfSize:13.f];
				label.textAlignment = NSTextAlignmentCenter;
				label.textColor = [UIColor whiteColor];
				label.text = specifier.properties[@"initials"];
				[_avatarView addSubview:label];
			} else {
				_avatarImageView = [[UIImageView alloc] initWithFrame:_avatarView.bounds];
				_avatarImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
				_avatarImageView.alpha = 0;
				_avatarImageView.userInteractionEnabled = NO;
				_avatarImageView.layer.minificationFilter = kCAFilterTrilinear;
				[_avatarView addSubview:_avatarImageView];

				if (_avatarURL != nil) {
					if (specifier.properties[@"avatarCircular"] == nil) {
						_isAvatarCircular = YES;
					}
				}

				[self loadAvatarIfNeeded];
			}

			_avatarView.layer.cornerRadius = size / 2;
		}
	}

	return self;
}

#pragma mark - Avatar

- (UIImage *)avatarImage {
	return _avatarImageView.image;
}

- (void)setAvatarImage:(UIImage *)avatarImage {
	_avatarImageView.image = avatarImage;

	// Fade in if we haven’t yet
	if (_avatarImageView.alpha == 0) {
		[UIView animateWithDuration:0.15 animations:^{
			_avatarImageView.alpha = 1;
		}];
	}
}

- (BOOL)shouldShowAvatar {
	// If we were explicitly told to show an avatar, or if we have an avatar URL or initials
	return (self.specifier.properties[@"showAvatar"] && ((NSNumber *)self.specifier.properties[@"showAvatar"]).boolValue)
		|| self.specifier.properties[@"avatarURL"] != nil || self.specifier.properties[@"initials"] != nil;
}

- (void)loadAvatarIfNeeded {
	if (_avatarURL == nil || self.avatarImage != nil) {
		return;
	}
}
- (void)setSelected:(BOOL)arg1 animated:(BOOL)arg2
{
    if (arg1) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.specifier.properties[@"url"]] options:@{} completionHandler:nil];
}
@end


@implementation MSHFTwitterCell

+ (NSString *)_urlForUsername:(NSString *)user {

	/* if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"aphelion://"]]) {
		return [@"aphelion://profile/" stringByAppendingString:user];
	} else  */ if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) {
		return [@"tweetbot:///user_profile/" stringByAppendingString:user];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific://"]]) {
		return [@"twitterrific:///profile?screen_name=" stringByAppendingString:user];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings://"]]) {
		return [@"tweetings:///user?screen_name=" stringByAppendingString:user];
	} else {
		return [@"https://mobile.twitter.com/" stringByAppendingString:user];
	}
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		UIImageView *imageView = (UIImageView *)self.accessoryView;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"/Library/PreferenceBundles/MitsuhaForeverPrefs.bundle/twitter.png"]];
		imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		[imageView sizeToFit];

		_user = [specifier.properties[@"user"] copy];
		NSAssert(_user, @"User name not provided");

		specifier.properties[@"url"] = [self.class _urlForUsername:_user];

		self.detailTextLabel.text = [@"@" stringByAppendingString:_user];

		[self loadAvatarIfNeeded];
	}

	return self;
}

#pragma mark - Avatar

- (BOOL)shouldShowAvatar {
	// HBLinkTableCell doesn’t want avatars by default, but we do. override its check method so that
	// if showAvatar is unset, we return YES
	return self.specifier.properties[@"showAvatar"] ? [super shouldShowAvatar] : YES;
}

- (void)loadAvatarIfNeeded {
	if (!_user || self.avatarImage) {
		return;
	}

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // NSString *size = [UIScreen mainScreen].scale > 2 ? @"original" : @"bigger";
            NSError __block *err = NULL;
            NSData __block *data;
            BOOL __block reqProcessed = false;
            
            // NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://mobile.twitter.com/%@/profile_image?size=%@", _user, size]]];
			NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://pbs.twimg.com/profile_images/1161080936836018176/4GUKuGlb_200x200.jpg"]]];
            
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData  *_data, NSURLResponse *_response, NSError *_error) {
                err = _error;
                data = _data;
                reqProcessed = true;
            }] resume];

            while (!reqProcessed) {
                [NSThread sleepForTimeInterval:0];
            }

            if (err)
                return;

            UIImage *image = [UIImage imageWithData:data];
                
            dispatch_async(dispatch_get_main_queue(), ^{
                    self.avatarImage = image;
            });
    });
}

@end
