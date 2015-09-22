//
//  M2KeyboardOverlapHelper.h
//  M2Common
//
//  Created by chenms.m2 on 15/5/7.
//  Copyright (c) 2015年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface M2SimpleKeyboardOverlapHelper : NSObject
@property (nonatomic) UIView *cannotOverlapView;
@property (nonatomic, copy) void (^onKeyboardOverlapHandler)(double needOffsetY, NSTimeInterval keyboardAnimationDuration);
- (void)addKeyboardNotifications;
- (void)removeKeyboardNotifications;
@end
