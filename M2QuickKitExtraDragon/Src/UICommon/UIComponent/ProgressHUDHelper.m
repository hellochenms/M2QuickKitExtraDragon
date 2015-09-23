//
//  ProgressHUDHelper.m
//  CicaeroEntertainment
//
//  Created by thatsoul on 15/7/6.
//  Copyright (c) 2015年 cicaero. All rights reserved.
//

#import "ProgressHUDHelper.h"

@interface ProgressHUDHelper ()
@property (nonatomic) MBProgressHUD *progressHUD;
@end

@implementation ProgressHUDHelper
- (instancetype)init {
    return [self initWithView:nil];
}

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        // view
        UIWindow* keyWindow = [[UIApplication sharedApplication].windows firstObject];
        UIView *parentView = (view ? view : keyWindow);
        self.progressHUD = [[MBProgressHUD alloc] initWithView:parentView];
        [parentView addSubview:self.progressHUD];
        
        // flag
        _isHUDUserInteractionEnabled = YES;
    }
    
    return self;
}

- (void)bringHUDToFront {
   [[self.progressHUD superview] bringSubviewToFront:self.progressHUD];
}

- (void)show {
    [self show:YES];
}

- (void)hide {
    [self hide:YES];
}

- (void)show:(BOOL)animated {
    [self.progressHUD show:animated];
}

- (void)hide:(BOOL)animated {
    [self.progressHUD hide:animated];
}

#pragma mark - setter/getter
- (void)setIsHUDUserInteractionEnabled:(BOOL)isHUDUserInteractionEnabled {
    _isHUDUserInteractionEnabled = isHUDUserInteractionEnabled;
    self.progressHUD.userInteractionEnabled = _isHUDUserInteractionEnabled;
}

#pragma mark - dealloc
- (void)dealloc {
    [self.progressHUD removeFromSuperview];
}

@end
