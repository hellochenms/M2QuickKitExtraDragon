//
//  M2UserNoTouchMonitorViewController.m
//  M2QuickKitExtraDragon
//
//  Created by thatsoul on 15/9/14.
//  Copyright (c) 2015年 chenms.m2. All rights reserved.
//

#import "M2UserNoTouchMonitorViewController.h"
#import "M2UserNoTouchMonitor.h"

@interface M2UserNoTouchMonitorViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@end

@implementation M2UserNoTouchMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [M2UserNoTouchMonitor sharedInstance].debugMode = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveLongTimeNoTouchNotification) name:M2UserNoTouchMonitorLongTimeNoTouchNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - user event
- (IBAction)onTapLogin:(id)sender {
    __weak typeof(self) weakSelf = self;
    self.loginButton.enabled = NO;
    self.logoutButton.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.logoutButton.enabled = YES;
        DDLogInfo(@"登录成功");

        [[M2UserNoTouchMonitor sharedInstance] startMonitor];
    });
}

- (IBAction)onTapLogout:(id)sender {
    self.loginButton.enabled = YES;
    self.logoutButton.enabled = NO;
    DDLogInfo(@"登出成功");

    [[M2UserNoTouchMonitor sharedInstance] stopMonitor];
}

#pragma mark - notifications
- (void)onReceiveLongTimeNoTouchNotification {
    self.loginButton.enabled = YES;
    self.logoutButton.enabled = NO;
    DDLogInfo(@"强制登出成功");
}

@end