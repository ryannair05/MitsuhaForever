//
//  Tweak.h
//  Mitsuha2
//
//  Created by c0ldra1n on 12/10/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <MitsuhaForever/MSHFConfig.h>
#import <MitsuhaForever/MSHFView.h>

@interface SBHomeScreenView : UIView
@property (nonatomic,retain) MSHFView * mshfView;     
@end

@interface SBIconController : UIViewController
@property (nonatomic,retain) MSHFView * mshfView;     
@end