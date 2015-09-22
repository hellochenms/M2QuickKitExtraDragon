//
//  M2PopupViewController.m
//  M2Common
//
//  Created by chenms.m2 on 15/9/21.
//  Copyright (c) 2015年 chenms.m2. All rights reserved.
//

#import "M2PopupViewController.h"

static NSTimeInterval kAnimationDuration = 0.25;

@interface M2PopupViewController ()
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic) UIViewController *backgroundViewController;
@property (nonatomic) CGRect backgroundViewControllerOriginFrame;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *frontView;
@property (nonatomic) UIViewController *frontViewController;
@property (nonatomic) CGRect frontViewControllerOriginFrame;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frontWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frontHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frontCenterXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frontCenterYConstraint;
@property (nonatomic) BOOL isIOS8OrAbove;
@end

@implementation M2PopupViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _backgroundScale = 1.0;
        _isIOS8OrAbove = ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0);
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)popupViewController:(UIViewController *)viewController size:(CGSize)size animated:(BOOL)animated {
    // force load view
    self.view = self.view;

    //
    self.frontViewController = viewController;
    [self addChildViewController:self.frontViewController];
    [self.frontView addSubview:self.frontViewController.view];
    self.frontWidthConstraint.constant = size.width;
    self.frontHeightConstraint.constant = size.height;
    [self.view layoutIfNeeded];
    self.frontViewControllerOriginFrame = self.frontViewController.view.frame;
    self.frontViewController.view.frame = self.frontView.bounds;
    [self.frontViewController didMoveToParentViewController:self];

    //
    self.backgroundViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [UIApplication sharedApplication].keyWindow.rootViewController = self;
    [self addChildViewController:self.backgroundViewController];
    [self.backgroundView addSubview:self.backgroundViewController.view];
    self.backgroundViewControllerOriginFrame = self.backgroundViewController.view.frame;
    self.backgroundViewController.view.frame = self.backgroundView.bounds;
    [self.backgroundViewController didMoveToParentViewController:self];

    self.frontView.alpha = 0;
    self.middleView.alpha = 0;
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [self showFront];
        }];
    } else {
        [self showFront];
    }
}
- (void)showFront {
    self.backgroundView.transform = CGAffineTransformMakeScale(self.backgroundScale, self.backgroundScale);
    self.frontView.alpha = 1;
    self.middleView.alpha = 1;
}

- (void)dismissPopupViewControllerAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [self hideFront];
        } completion:^(BOOL finished) {
            [self dismiss];
        }];
    } else {
        [self hideFront];
        [self dismiss];
    }
}

- (void)hideFront {
    self.backgroundView.transform = CGAffineTransformIdentity;
    self.frontView.alpha = 0;
    self.middleView.alpha = 0;
}

- (void)dismiss {
    [self.frontViewController willMoveToParentViewController:nil];
    self.frontViewController.view.frame = self.frontViewControllerOriginFrame;
    [self.frontViewController.view removeFromSuperview];
    [self.frontViewController removeFromParentViewController];

    [self.backgroundViewController willMoveToParentViewController:nil];
    self.backgroundViewController.view.frame = self.backgroundViewControllerOriginFrame;
    [self.backgroundViewController.view removeFromSuperview];
    [self.backgroundViewController removeFromParentViewController];

    [UIApplication sharedApplication].keyWindow.rootViewController = self.backgroundViewController;
}

#pragma mark -
- (void)translateContentOffsetY:(double)offsetY animationDuration:(NSTimeInterval)animationDuration {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (self.isIOS8OrAbove) {
        self.frontCenterYConstraint.constant = offsetY;
    } else {// 适配iOS7-
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            self.frontCenterXConstraint.constant = offsetY;
        } else if (orientation == UIInterfaceOrientationLandscapeRight){
            self.frontCenterXConstraint.constant = -offsetY;
        }
    }

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         [weakSelf.view layoutIfNeeded];
                     }];
}

#pragma mark - user event
- (IBAction)onTapMiddleView:(id)sender {
    [self.frontView endEditing:YES];
}


#pragma mark - setter/getter
- (void)setBackgroundScale:(CGFloat)backgroundScale {
    if (backgroundScale < 0) {
        _backgroundScale = 0;
    } else if (backgroundScale > 1) {
        _backgroundScale = 1;
    } else {
        _backgroundScale = backgroundScale;
    }
}

@end
