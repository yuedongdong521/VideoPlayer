//
//  VideoPlayerViewController.m
//  VideoPlayer
//
//  Created by ispeak on 2017/12/6.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "PlayerView.h"
@interface VideoPlayerViewController ()<PlayerVideoDelegate>


@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    PlayerView *playerView = [[PlayerView alloc] initWithFrame:self.view.bounds WithPath:_filePath];
    playerView.delegate = self;
    [self.view addSubview:playerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [AppMode shareAppMode].preformeLandscape = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [AppMode shareAppMode].preformeLandscape = NO;
    if (ScreenWidth > ScreenHeight) {
        [self changeScreenBtnAction:nil];
    }
}

- (void)closePlayer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playError
{
   
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"播放出错啦☹️，请检查视频地址" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self closePlayer];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
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

- (void)changeScreenBtnAction:(UIButton *)btn
{
    btn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.enabled = YES;
    });
    if ([AppMode shareAppMode].preformeLandscape) {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        } else {
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
