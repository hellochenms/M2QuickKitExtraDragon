//
//  UIViewController+M2Popup.m
//  M2Common
//
//  Created by chenms.m2 on 15/9/21.
//  Copyright (c) 2015年 chenms.m2. All rights reserved.
//

#import "UIViewController+M2Popup.h"
#import <objc/runtime.h>


@implementation UIViewController (M2Popup)
- (void)setM2p_popupViewController:(M2PopupViewController *)m2p_popupViewController{
    objc_setAssociatedObject(self, @selector(m2p_popupViewController), m2p_popupViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (M2PopupViewController *)m2p_popupViewController {
    return objc_getAssociatedObject(self, @selector(m2p_popupViewController));
}
@end
