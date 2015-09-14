//
//  M2UserNoTouchMonitor.m
//  M2QuickKitExtraDragon
//
//  Created by thatsoul on 15/9/14.
//  Copyright (c) 2015年 chenms.m2. All rights reserved.
//

#import "M2UserNoTouchMonitor.h"
#import <objc/runtime.h>

#pragma mark - NSTimer Category
@interface NSTimer (M2UserNoTouchMonitor)
+ (NSTimer *)m2un_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats;

@end

#pragma mark - M2UserNoTouchMonitor
NSString * const M2UserNoTouchMonitorLongTimeNoTouchNotification = @"M2UserNoTouchMonitorLongTimeNoTouchNotification";

static NSTimeInterval kNoTouchInterval = 10;// 60 * 20;
static NSTimeInterval kRepeatTimeInterval = 1;

@interface M2UserNoTouchMonitor ()
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimeInterval noTouchInterval;
@property (nonatomic) NSTimeInterval remainderInterval;
@property (nonatomic) BOOL monitorEnabled;
@end

@implementation M2UserNoTouchMonitor
static M2UserNoTouchMonitor *s_instance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [M2UserNoTouchMonitor new];
    });

    return s_instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.noTouchInterval = kNoTouchInterval;
    }

    return self;
}

#pragma mark - 
- (void)startMonitor {
    self.monitorEnabled = YES;
    [self reStartMonitor];
}

- (void)reStartMonitor {
    if (!self.monitorEnabled) {
        return;
    }
    [self.timer invalidate];
    self.remainderInterval = self.noTouchInterval;
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer m2un_scheduledTimerWithTimeInterval:kRepeatTimeInterval
                                                        block:^{
                                                            if (self.debugMode) {
                                                                NSLog(@"(%@)秒后倒计时结束", @((NSInteger)weakSelf.remainderInterval));
                                                            }

                                                            if (weakSelf.remainderInterval < 0) {
                                                                [weakSelf.timer invalidate];
                                                                self.monitorEnabled = NO;
                                                                [[NSNotificationCenter defaultCenter] postNotificationName:M2UserNoTouchMonitorLongTimeNoTouchNotification object:nil];
                                                            } else {
                                                                weakSelf.remainderInterval--;
                                                            }
                                                        }
                                                      repeats:YES];
}

- (void)stopMonitor {
    self.monitorEnabled = NO;
    [self.timer invalidate];
}

@end

#pragma mark - NSTimer Category
@implementation NSTimer (M2UserNoTouchMonitor)
+ (NSTimer *)m2un_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(m2un_invokeBlock:)
                                       userInfo:[block copy]
                                        repeats:repeats];

}

+ (void)m2un_invokeBlock:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}
@end

#pragma mark - UIWindow Category
@implementation UIWindow (M2UserNoTouchMonitor)
+ (void)load {
    SEL originalSelector = @selector(sendEvent:);
    SEL swizzledSelector  = @selector(m2ud_sendEvent:);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)m2ud_sendEvent:(UIEvent *)event {
    [self m2ud_sendEvent:event]; // Primary call
    [[M2UserNoTouchMonitor sharedInstance] reStartMonitor];
}

@end