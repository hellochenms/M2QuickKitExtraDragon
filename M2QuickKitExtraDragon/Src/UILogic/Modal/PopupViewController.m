//
//  PopupViewController.m
//  MHelloPopup
//
//  Created by thatsoul on 15/9/21.
//  Copyright (c) 2015年 chenms.m2. All rights reserved.
//

#import "PopupViewController.h"
#import "UIViewController+M2Popup.h"
#import "PopupSubViewController.h"

@interface PopupViewController ()
@property (nonatomic) M2PopupViewController *popupViewController;
@end

@implementation PopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.popupViewController = [M2PopupViewController new];
    self.popupViewController.backgroundScale = 0.9;
}

#pragma mark - user event
- (IBAction)onTapDismiss:(id)sender {
    [self.m2p_popupViewController dismissPopupViewControllerAnimated:YES];
}
- (IBAction)onTapNext:(id)sender {
    PopupSubViewController *subViewController = [PopupSubViewController new];
    subViewController.m2p_popupViewController = self.popupViewController;
    [self.popupViewController popupViewController:subViewController size:CGSizeMake(200, 400) animated:YES];
}

@end
