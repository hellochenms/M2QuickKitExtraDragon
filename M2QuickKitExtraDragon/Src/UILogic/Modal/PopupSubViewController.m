//
//  SubViewController.m
//  MHelloPopup
//
//  Created by thatsoul on 15/9/21.
//  Copyright (c) 2015年 chenms.m2. All rights reserved.
//

#import "PopupSubViewController.h"
#import "UIViewController+M2Popup.h"
#import "M2SimpleKeyboardOverlapHelper.h"

@interface PopupSubViewController ()
@property (nonatomic) M2PopupViewController *popupViewController;
@property (nonatomic) M2SimpleKeyboardOverlapHelper *keyboardOverlapHelper;

@property (weak, nonatomic) IBOutlet UITextField *bottonTextField;
@end

@implementation PopupSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.popupViewController = [M2PopupViewController new];
    self.popupViewController.backgroundScale = 0.9;

    __weak typeof(self) weakSelf = self;

    self.keyboardOverlapHelper = [M2SimpleKeyboardOverlapHelper new];
    self.keyboardOverlapHelper.cannotOverlapView = self.bottonTextField;
    self.keyboardOverlapHelper.onKeyboardOverlapHandler = ^(double needOffsetY, NSTimeInterval keyboardAnimationDuration){
        [weakSelf.m2p_popupViewController translateContentOffsetY:needOffsetY animationDuration:keyboardAnimationDuration];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.keyboardOverlapHelper addKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.keyboardOverlapHelper removeKeyboardNotifications];
}

#pragma mark - user event
- (IBAction)onTapNext:(id)sender {
    PopupSubViewController *subViewController = [PopupSubViewController new];
    subViewController.m2p_popupViewController = self.popupViewController;
    [self.popupViewController popupViewController:subViewController size:CGSizeMake(200, 400) animated:YES];
}

- (IBAction)onTapDismiss:(id)sender {
    [self.m2p_popupViewController dismissPopupViewControllerAnimated:YES];
}

@end
