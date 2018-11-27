//
//  PlayListViewController.m
//  VideoPlayer
//
//  Created by ispeak on 2017/12/7.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "PlayListViewController.h"
#import "EditVideoURLViewController.h"
#import "VideoPlayerViewController.h"
#import "VideoListMode.h"
#import "ListTableViewCell.h"
#import "PlayerViewController.h"

#define VideoURLArr  @"VideoURLArr"

@interface PlayListViewController ()<UITableViewDelegate, UITableViewDataSource, EditVideoURLViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *mtbArray;
@property (nonatomic, strong) UITableView *listTableView;

@end

@implementation PlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.title = @"播放列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction)];
    
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, YViewH(self.navigationController.navigationBar) + YViewY(self.navigationController.navigationBar), ScreenWidth, ScreenHeight - YViewH(self.navigationController.navigationBar) - YViewY(self.navigationController.navigationBar)) style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.separatorColor = [UIColor grayColor];
    [_listTableView registerClass:[ListTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_listTableView];
    _listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
//        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    [self getPlayerDate];
    [self.listTableView reloadData];
}

- (void)deletePlayerDateForIndex:(NSInteger)index
{
    if (_mtbArray.count > index) {
        [_mtbArray removeObjectAtIndex:index];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[defaults objectForKey:VideoURLArr]];
        [arr removeObjectAtIndex:index];
        if (arr && arr.count > 0) {
            [defaults setObject:arr forKey:VideoURLArr];
        } else {
            [defaults removeObjectForKey:VideoURLArr];
        }
        
    }
}

- (void)addPlayerDateForURL:(NSString *)url ForName:(NSString *)name
{
    if (url.length > 0 && name.length > 0) {
        NSDictionary *dic = @{@"name":name,@"playerURL":url};
        VideoListMode *mode = [[VideoListMode alloc] initWihtDic:dic];
        [_mtbArray addObject:mode];
        [_listTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_mtbArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[defaults objectForKey:VideoURLArr]];
        [arr addObject:dic];
        [defaults setObject:arr forKey:VideoURLArr];
    }
}

- (void)getPlayerDate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mutableArry = [NSMutableArray arrayWithArray:(NSArray *)[defaults objectForKey:VideoURLArr]];
    if (mutableArry && mutableArry.count > 0) {
       
    } else {
        /*
         3，HTTP协议直播源
         香港卫视：http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8
         CCTV1高清：http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8
         CCTV3高清：http://ivi.bupt.edu.cn/hls/cctv3hd.m3u8
         CCTV5高清：http://ivi.bupt.edu.cn/hls/cctv5hd.m3u8
         CCTV5+高清：http://ivi.bupt.edu.cn/hls/cctv5phd.m3u8
         CCTV6高清：http://ivi.bupt.edu.cn/hls/cctv6hd.m3u8
         苹果提供的测试源（点播）：http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear2/prog_index.m3u8
         http://7xo69d.com1.z0.glb.clouddn.com/ishowapp/2017/0926/1506391606-100001407-FsH1BE6rJUeamdODejYOSOgbgZxm-0647
         */
        mutableArry = [NSMutableArray arrayWithArray:
  @[@{@"name":@"香港卫视",@"playerURL":@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"},
  @{@"name":@"CCTV1高清",@"playerURL":@"http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8"},
  @{@"name":@"CCTV3高清",@"playerURL":@"http://ivi.bupt.edu.cn/hls/cctv3hd.m3u8"},
  @{@"name":@"CCTV5高清",@"playerURL":@"http://ivi.bupt.edu.cn/hls/cctv5hd.m3u8"},
  @{@"name":@"CCTV5+高清",@"playerURL":@"http://ivi.bupt.edu.cn/hls/cctv5phd.m3u8"},
  @{@"name":@"CCTV6高清",@"playerURL":@"http://ivi.bupt.edu.cn/hls/cctv6hd.m3u8"},
  @{@"name":@"苹果提供的测试源(点播)",@"playerURL":@"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear2/prog_index.m3u8"}]];
        [defaults setValue:mutableArry forKey:VideoURLArr];
    }
    _mtbArray = [NSMutableArray array];
    for (NSDictionary *dic in mutableArry) {
        VideoListMode *mode = [[VideoListMode alloc] initWihtDic:dic];
        [_mtbArray addObject:mode];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mtbArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mode = [_mtbArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    VideoListMode *mode = _mtbArray[indexPath.row];
  if (_isIJKPlayer) {
    PlayerViewController *playerVC = [[PlayerViewController alloc] initWithVideoUrl:[NSURL URLWithString:mode.playerURL]];
    [self.navigationController pushViewController:playerVC animated:YES];
  } else {
    [self pushVideoPlayerControllerForPlayerPath:mode.playerURL ForTitle:mode.name];
  }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deletePlayerDateForIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    
    footer.contentView.backgroundColor = [UIColor clearColor];
}

- (void)rightAction
{
    EditVideoURLViewController *editVC = [[EditVideoURLViewController alloc] init];
    editVC.delegate = self;
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)addPlayDelegateForName:(NSString *)name ForUrl:(NSString *)url
{
    [self addPlayerDateForURL:url ForName:name];
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
