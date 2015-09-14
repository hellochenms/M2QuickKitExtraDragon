//
//  StaticNotTouchLaunchADView.h
//  M2QuickKitExtraDragon
//
//  Created by thatsoul on 15/9/14.
//  Copyright (c) 2015年 chenms.m2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaticNotTouchLaunchADView : UIView
@property (nonatomic, copy) NSString * (^imagePathProvider)();
@property (nonatomic, copy) NSTimeInterval (^showingTimerIntervalProvider)();
@end
