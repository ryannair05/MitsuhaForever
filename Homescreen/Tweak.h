//
//  Tweak.h
//  Mitsuha2
//
//  Created by c0ldra1n on 12/10/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MitsuhaForever/MSHFConfig.h>
#import <MitsuhaForever/MSHFView.h>

@interface SBDockView : UIView

@property(retain, nonatomic) MSHFView *mshView;
@property(retain, nonatomic) UIView *backgroundView;

@end