//
//  ParentViewController.m
//  VideoPlayer
//
//  Created by ydd on 2018/11/22.
//  Copyright © 2018 ydd. All rights reserved.
//

#import "ParentViewController.h"

@interface ParentViewController ()

@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
  if (!_isRotatingScreen) {
    return;
  }
  [AppMode shareAppMode].preformeLandscape = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
  if (!_isRotatingScreen) {
    return;
  }
  if (ScreenWidth > ScreenHeight) {
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
  }
  [AppMode shareAppMode].preformeLandscape = NO;
}

- (void)transparentNavigation:(BOOL)isTransparen
{
  UIImage *image = isTransparen ? [[UIImage alloc] init] : nil;
  [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
  [self.navigationController.navigationBar setShadowImage:image];
  
}

- (BOOL)shouldAutorotate
{
  return [AppMode shareAppMode].preformeLandscape;
}

// 这里返回需要支持旋转的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
  //你跳转（present）到这个新控制器时，按照什么方向初始化控制器
  return UIInterfaceOrientationPortrait;
}
// 优先显示的方向

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  //返回你的屏幕支持的方向
  if ([AppMode shareAppMode].preformeLandscape) {
    return UIInterfaceOrientationMaskAllButUpsideDown;
  }
  return UIInterfaceOrientationMaskPortrait;
}

/*iOS8以上，旋转控制器后会调用*/
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  
  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    [self layoutUI];
  } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    
  }];
  
}

- (void)layoutUI
{
  
}

//手动切换
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
  if (!_isRotatingScreen) {
    return;
  }
  if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
    SEL selector             = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val                  = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
  }
}

- (void)changeScreenBtnAction
{
  if (!_isRotatingScreen) {
    return;
  }
  if ([AppMode shareAppMode].preformeLandscape) {
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
      [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    } else {
      [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
  }
}
/**
 1.第一次push进来的时候两个方法都会调用，parent的值不为空。
 2.当开始使用系统侧滑的时候，会先调用willMove，而parent的值为空；
 3.当滑动结束后返回了上个页面，则会调用didMove，parent的值也为空，如果滑动结束没有返回上个页面，也就是轻轻划了一下还在当前页面，那么则不会调用didMove方法。
 */
- (void)willMoveToParentViewController:(UIViewController *)parent
{
  [super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
  [super didMoveToParentViewController:parent];
  if (!parent) {
    [self didPopTopParentViewController];
  }
}
/** 侧滑退出当前控制器 */
- (void)didPopTopParentViewController
{
  
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
