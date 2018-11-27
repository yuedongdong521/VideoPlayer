//
//  ViewController.m
//  VideoPlayer
//
//  Created by ispeak on 2017/12/6.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "ViewController.h"
#import "VideoPlayerViewController.h"

#import "PlayListViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"我的播放器";
    self.view.backgroundColor = [UIColor colorWithRed:40 / 255.0 green:41 / 255.0 blue:51 / 255.0 alpha:1];
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    NSArray *arr = @[@"示例播放",@"本地播放", @"在线播放", @"IJKPlayer"];
    
    for (int i = 0; arr.count > i; i++) {
        UIButton *btn = [self creatButtonAction:@selector(buttonAction:) Titile:arr[i]];
        btn.frame = CGRectMake((screenW - 200) / 2.0, screenH / 3.0 + 80 * i, 200, 50);
        btn.tag = i;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.cornerRadius = 25;
        btn.layer.masksToBounds = YES;
        [self.view addSubview:btn];
    }
}

- (void)buttonAction:(UIButton *)btn
{
  switch (btn.tag) {
    case 0:{
      [self pushVideoPlayerControllerForPlayerPath:[[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mp4"] ForTitle:@"示例"];
    }
      break;
    case 1:{
      [self getUserVideo];
    }
      break;
    case 2:{
      PlayListViewController *listVC = [[PlayListViewController alloc] init];
      listVC.isIJKPlayer = NO;
      [self.navigationController pushViewController:listVC animated:YES];
    }
      break;
    case 3:{
      PlayListViewController *listVC = [[PlayListViewController alloc] init];
      listVC.isIJKPlayer = YES;
      [self.navigationController pushViewController:listVC animated:YES];
    }
      break;
    default:
      break;
  }
  
  
}



- (void)pushVideoPlayerControllerForPlayerPath:(NSString *)path ForTitle:(NSString *)title
{
    if (path && path.length > 0) {
        VideoPlayerViewController *VC = [[VideoPlayerViewController alloc]init];
        VC.filePath = path;
        VC.titleStr = title;
        [self presentViewController:VC animated:YES completion:nil];
    } else {
        NSLog(@"地址为空");
    }
}

- (void)getUserVideo
{
    UIImagePickerController *imgPickerCtrl = [[UIImagePickerController alloc] init];
    
    imgPickerCtrl.delegate = self;
    
    imgPickerCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //自定媒体类型
    imgPickerCtrl.mediaTypes = @[@"public.movie"];
    imgPickerCtrl.videoQuality = 3;//获取本地视频的质量
    [self presentViewController:imgPickerCtrl animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSURL* videoUrl = nil;
    NSString *videoStr= @"";
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.movie"]) {
        
        //获取视图的url
        videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData *webData = [NSData dataWithContentsOfURL:videoUrl];
        videoStr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/a.mp4"];
        [webData writeToFile:videoStr atomically:YES];
        
        //播放器播放
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self pushVideoPlayerControllerForPlayerPath:videoStr ForTitle:@"本地视频"];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)creatButtonAction:(SEL)action Titile:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:50 / 255.0 blue:100 / 255.0 alpha:1.0];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
