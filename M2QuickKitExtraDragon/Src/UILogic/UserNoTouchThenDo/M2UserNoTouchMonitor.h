//
//  M2UserNoTouchMonitor.h
//  M2QuickKitExtraDragon
//
//  Created by thatsoul on 15/9/14.
//  Copyright (c) 2015年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const M2UserNoTouchMonitorLongTimeNoTouchNotification;

@interface M2UserNoTouchMonitor : NSObject
@property (nonatomic) BOOL debugMode;
+ (instancetype)sharedInstance;
- (void)startMonitor;
- (void)stopMonitor;
@end

@interface UIWindow (M2UserNoTouchMonitor)
- (void)m2ud_sendEvent:(UIEvent *)event;
@end