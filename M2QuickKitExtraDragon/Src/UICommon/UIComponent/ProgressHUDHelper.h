//
//  ProgressHUDHelper.h
//  CicaeroEntertainment
//
//  Created by thatsoul on 15/7/6.
//  Copyright (c) 2015年 cicaero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ProgressHUDHelper : NSObject
@property (nonatomic, readonly) MBProgressHUD *progressHUD;
@property (nonatomic) BOOL isHUDUserInteractionEnabled;
- (instancetype)initWithView:(UIView *)view;
- (void)bringHUDToFront;
- (void)show;
- (void)hide;
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
@end
