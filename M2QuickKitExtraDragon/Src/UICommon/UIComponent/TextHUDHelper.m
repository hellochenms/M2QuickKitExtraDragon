//
//  HUDHelper.m
//  CicaeroEntertainment
//
//  Created by thatsoul on 15/7/5.
//  Copyright (c) 2015年 cicaero. All rights reserved.
//

#import "TextHUDHelper.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSInteger const s_hideAfterDelay = 1.5;

@interface TextHUDHelper ()
@property (nonatomic) MBProgressHUD *textHUD;
@end

@implementation TextHUDHelper

+ (instancetype)sharedInstance {
    static TextHUDHelper *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [TextHUDHelper new];
    });
    
    return s_instance;
}

- (instancetype)init {
    return [self initWithView:nil];
}

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        UIWindow* keyWindow = [[UIApplication sharedApplication].windows firstObject];
        UIView *parentView = (view ? view : keyWindow);
        self.textHUD = [[MBProgressHUD alloc] initWithView:parentView];
        self.textHUD.mode = MBProgressHUDModeText;
        [parentView addSubview:self.textHUD];
    }
    
    return self;
}

- (void)showText:(NSString *)text {
    [[self.textHUD superview] bringSubviewToFront:self.textHUD];
    self.textHUD.labelText = text;
    [self.textHUD show:YES];
    [self.textHUD hide:YES afterDelay:s_hideAfterDelay];
}

#pragma mark - dealloc
- (void)dealloc {
    [self.textHUD removeFromSuperview];
}

@end
