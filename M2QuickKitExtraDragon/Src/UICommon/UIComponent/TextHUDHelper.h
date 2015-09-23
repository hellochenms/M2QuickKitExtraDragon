//
//  HUDHelper.h
//  CicaeroEntertainment
//
//  Created by thatsoul on 15/7/5.
//  Copyright (c) 2015年 cicaero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextHUDHelper : NSObject
+ (instancetype)sharedInstance;
- (instancetype)initWithView:(UIView *)view;
- (void)showText:(NSString *)text;
@end
