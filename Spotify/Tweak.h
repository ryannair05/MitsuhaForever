//
//  Tweak.h
//  Mitsuha
//
//  Created by c0ldra1n on 2/17/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <MitsuhaForever/MSHFConfig.h>
#import <MitsuhaForever/MSHFView.h>

@interface SPTImageBlurView : UIView

@property(retain, nonatomic) UIView *tintView; // @synthesize tintView=_tintView;

- (void)updateBlurredImageIfNeeded;
- (void)updateBlurIntensity;

-(void)applyCustomLayout;
-(void)updateGradientDark:(BOOL)darkbackground;

@end

@interface SPTNowPlayingCoverArtImageView : UIImageView
-(void)setImage:(UIImage *)image;
-(void)readjustWaveColor;

@end

@interface SPTUniversalController : UIViewController
@property (retain,nonatomic) MSHFView *mshfview;
-(void)applyCustomLayout;
@end

@interface SPTNowPlayingShowsFormatBackgroundViewController : SPTUniversalController

@end

@interface SPTNowPlayingBackgroundMusicViewController : SPTUniversalController

@end

@interface SPTNowPlayingContentCell : UIView

@property(retain, nonatomic) UIImage *cellContentRepresentation;

@end

@interface SPTNowPlayingCoverArtCell : UIView

@property(nonatomic) CGSize cellSize; // @synthesize cellSize=_cellSize;
@property(retain, nonatomic) UIView *contentView; // @synthesize contentView=_contentView;
@property(nonatomic) BOOL selected;
@property(nonatomic) BOOL shouldShowCoverArtView;
@property(retain, nonatomic) UIImage *cellContentRepresentation;

-(void)setSelected:(BOOL)selected;
-(void)readjustWaveColor;

@end


@interface SPTNowPlayingCoverArtView : UIView

@end

@interface SPTNowPlayingCarouselContentUnitView : UIView

@property(retain, nonatomic) SPTNowPlayingCoverArtView *coverArtView; // @synthesize coverArtView=_coverArtView;

@end

@interface SPTNowPlayingCarouselAreaViewController : UIViewController

@property(retain, nonatomic) SPTNowPlayingCarouselContentUnitView *view; // @dynamic view;

@end

@interface SpotifyAppDelegate : NSObject <UIApplicationDelegate>

@end

@interface SPTNowPlayingModel : NSObject
- (void)player:(id)arg1 stateDidChange:(id)arg2 fromState:(id)arg3;
- (void)updateWithPlayerState:(id)arg1;

-(void)applyColorChange;

@end

@interface CFWColorInfo : NSObject

+ (id)colorInfoWithAnalyzedInfo:(struct AnalyzedInfo)arg1;
@property(nonatomic, getter=isBackgroundDark) _Bool backgroundDark; // @synthesize backgroundDark=_backgroundDark;
@property(retain, nonatomic) UIColor *secondaryColor; // @synthesize secondaryColor=_secondaryColor;
@property(retain, nonatomic) UIColor *primaryColor; // @synthesize primaryColor=_primaryColor;
@property(retain, nonatomic) UIColor *backgroundColor; // @synthesize backgroundColor=_backgroundColor;
- (void)dealloc;
- (id)description;
- (_Bool)isEqual:(id)arg1;
- (id)initWithAnalyzedInfo:(struct AnalyzedInfo)arg1;

@end

@interface CFWSpotifyStateManager : NSObject

+ (id)sharedManager;

@property(readonly, retain, nonatomic) CFWColorInfo *mainColorInfo; // @synthesize mainColorInfo=_mainColorInfo;

@end

@interface CFWPrefsManager : NSObject

+(id)sharedInstance;

@end

@interface SPTNowPlayingBackgroundViewController : SPTUniversalController

@end