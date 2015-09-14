//
//  StaticNotTouchLaunchADView.m
//  M2QuickKitExtraDragon
//
//  Created by thatsoul on 15/9/14.
//  Copyright (c) 2015年 chenms.m2. All rights reserved.
//

#import "StaticNotTouchLaunchADView.h"
#import <Masonry/Masonry.h>

#pragma mark - NSTimer Category
@interface NSTimer (StaticNotTouchLaunchADView)
+ (NSTimer *)snt_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats;

@end

#pragma mark - StaticNotTouchLaunchADView

static NSInteger const kTimerInterval = 2;
static NSInteger const kAnimationInterval = 1; // ? 低于一秒无动画效果，待研究

@interface StaticNotTouchLaunchADView ()
@property (nonatomic) NSTimer *timer;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) NSTimeInterval showingTimerInterval;
@end

@implementation StaticNotTouchLaunchADView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.showingTimerInterval = kTimerInterval;

        self.imageView = [UIImageView new];
        [self addSubview:self.imageView];

        __weak typeof(self) weakSelf = self;
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo([weakSelf.imageView superview]).insets(UIEdgeInsetsZero);
        }];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.imagePath) {
                UIImage *image = [UIImage imageWithContentsOfFile:weakSelf.imagePath];
                weakSelf.imageView.image = image;
            }
            [weakSelf startAutoRemoveTimer];
        });
    }

    return self;
}

#pragma mark - timer
- (void)startAutoRemoveTimer {
    [self.timer invalidate];
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer snt_scheduledTimerWithTimeInterval:self.showingTimerInterval block:^{
        [UIView animateWithDuration:kAnimationInterval
                         animations:^{
                             weakSelf.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             weakSelf.alpha = 1;
                             [weakSelf removeFromSuperview];
                         }];
    } repeats:NO];
}

#pragma mark - dealloc
- (void)dealloc {
    [self.timer invalidate];
}

@end

#pragma mark - NSTimer Category
@implementation NSTimer (StaticNotTouchLaunchADView)
+ (NSTimer *)snt_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(snt_invokeBlock:)
                                       userInfo:[block copy]
                                        repeats:repeats];

}

+ (void)snt_invokeBlock:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
