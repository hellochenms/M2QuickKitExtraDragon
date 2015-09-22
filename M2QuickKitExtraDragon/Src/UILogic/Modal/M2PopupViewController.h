//
//  M2PopupViewController.h
//  M2Common
//
//  Created by chenms.m2 on 15/9/21.
//  Copyright (c) 2015年 chenms.m2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M2PopupViewController : UIViewController
@property (nonatomic) CGFloat backgroundScale;
- (void)popupViewController:(UIViewController *)viewController size:(CGSize)size animated:(BOOL)animated;
- (void)dismissPopupViewControllerAnimated:(BOOL)animated;
- (void)translateContentOffsetY:(double)offsetY animationDuration:(NSTimeInterval)animationDuration;
@end
