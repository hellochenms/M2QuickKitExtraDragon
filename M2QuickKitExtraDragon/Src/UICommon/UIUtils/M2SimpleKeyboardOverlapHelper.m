//
//  M2KeyboardOverlapHelper.m
//  M2Common
//
//  Created by chenms.m2 on 15/5/7.
//  Copyright (c) 2015年 chenms.m2. All rights reserved.
//

#import "M2SimpleKeyboardOverlapHelper.h"

@interface M2SimpleKeyboardOverlapHelper ()
@property (nonatomic) double curOffsetY;
@end

@implementation M2SimpleKeyboardOverlapHelper

#pragma mark - public
- (void)addKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - keyboard notifications
- (void)onKeyboardWillChangeFrame:(NSNotification *)notification {
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval keyboardAnimationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self adjustTextFieldLayoutWithIsShowingKeyboard:YES
                                       keyboardFrame:keyboardFrame
                           keyboardAnimationDuration:keyboardAnimationDuration];
}
- (void)onKeyboardWillHide:(NSNotification *)notification {
    NSTimeInterval keyboardAnimationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self adjustTextFieldLayoutWithIsShowingKeyboard:NO
                                       keyboardFrame:CGRectZero
                           keyboardAnimationDuration:keyboardAnimationDuration];
}

- (void)adjustTextFieldLayoutWithIsShowingKeyboard:(BOOL)isShowingKeyboard
                                     keyboardFrame:(CGRect)keyboardFrame
                         keyboardAnimationDuration:(NSTimeInterval)keyboardAnimationDuration {
    double needOffsetY = 0;
    if (isShowingKeyboard) {
        double inputViewBottomY = CGRectGetMaxY(self.cannotOverlapView.frame) + 10;
        double keyboardTopY = [self keyBoardLeftUpPointYWithKeyboardFrame: keyboardFrame toView:[self.cannotOverlapView superview]];
        needOffsetY = (keyboardTopY - inputViewBottomY) * -1;
        needOffsetY += self.curOffsetY;
        if (needOffsetY < 0) {
            needOffsetY = 0;
        };
    } else {
        needOffsetY = 0;
    }
    
//    NSLog(@"needOffsetY(%f)  %s", needOffsetY, __func__);
    
    if (self.onKeyboardOverlapHandler) {
        self.onKeyboardOverlapHandler(needOffsetY, keyboardAnimationDuration);
    }
    
    self.curOffsetY = needOffsetY;
}

#pragma mark - tools
// 键盘显示时，其左上角的Y坐标（适配iOS7、iOS8下的横竖屏）
- (double)keyBoardLeftUpPointYWithKeyboardFrame:(CGRect)keyboardFrame toView:(UIView *)view {
    CGPoint keyboardLeftTopPoint = CGPointZero;
    if ([self isForIOS8]) {
        UIWindow* keyWindow = [[UIApplication sharedApplication].windows firstObject];
        keyboardLeftTopPoint = [keyWindow convertPoint:CGPointMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(keyboardFrame)) toView:view];
    } else {
        CGPoint srcPoint = CGPointZero;
        // 注意：使用[UIDevice currentDevice].orientation不靠谱，使用[UIApplication sharedApplication].statusBarOrientation；
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:
                srcPoint = CGPointMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(keyboardFrame));
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                srcPoint = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(keyboardFrame));
                break;
                // 注意：UIInterfaceOrientationLandscapeRight与UIDeviceOrientationLandscapeLeft对应，虽然有道理，但真是坑；
            case UIInterfaceOrientationLandscapeRight:
                // 注意：iOS7及以前，横屏时，键盘的height取到的是宽，width取到的是高；
                srcPoint = CGPointMake(CGRectGetWidth(keyboardFrame), 0);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                srcPoint = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(keyboardFrame), CGRectGetHeight([UIScreen mainScreen].bounds));
                break;
            default:
                break;
        }
        UIWindow* keyWindow = [[UIApplication sharedApplication].windows firstObject];
        keyboardLeftTopPoint = [keyWindow convertPoint:srcPoint toView:view];
    }
    
    return keyboardLeftTopPoint.y;
}
- (BOOL)isForIOS8{
    return ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0);
}

#pragma mark -
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
