#import <Mitsuha/MSHView.h>
#import <Mitsuha/MSHJelloView.h>
#import <Mitsuha/MSHBarView.h>
#import <Mitsuha/MSHLineView.h>
#import <Mitsuha/MSHDotView.h>

@interface MSHConfig : NSObject

@property BOOL enabled;
@property (nonatomic, assign) NSString* application;

@property int style;
@property int colorMode;
@property BOOL enableDynamicGain;
@property BOOL enableAutoUIColor;
@property BOOL enableFFT;
@property BOOL enableCoverArtBugFix;
@property BOOL disableBatterySaver;
@property BOOL enableAutoHide;
@property double gain;
@property double limiter;

@property (nonatomic, strong) UIColor *waveColor;
@property (nonatomic, strong) UIColor *subwaveColor;
@property (nonatomic, strong) UIColor *calculatedColor;

@property NSUInteger numberOfPoints;
@property CGFloat fps;

@property CGFloat waveOffset;
@property CGFloat waveOffsetOffset;
@property CGFloat sensitivity;
@property CGFloat dynamicColorAlpha;

@property CGFloat barSpacing;
@property CGFloat barCornerRadius;
@property CGFloat lineThickness;

@property BOOL ignoreColorFlow;

@property BOOL enableCircleArtwork;

@property (nonatomic, retain) MSHView* view;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

+(MSHConfig *)loadConfigForApplication:(NSString *)name;
-(void)colorizeView:(UIImage *)image;
-(void)initializeViewWithFrame:(CGRect)frame;
+(NSDictionary *)parseConfigForApplication:(NSString *)name;
-(void)setDictionary:(NSDictionary *)dict;
-(void)configureView;
-(void)reloadConfig;

@end