//
//  PlayerView.m
//  VideoPlayer
//
//  Created by ispeak on 2017/12/6.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "PlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"

@interface PlayerView()
{
    id _timeObser;
}

@property (nonatomic, strong) NSURL *pathURL;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) CAGradientLayer *titleLayer;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) CAGradientLayer *bottomLayer;

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIButton *playerBtn;
@property (nonatomic, strong) UIButton *landscapeBtn;

@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, assign) BOOL hiddenView;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, assign) CGFloat lastTime;




@end

@implementation PlayerView

- (instancetype)initWithFrame:(CGRect)frame WithPath:(NSString *)path
{
    self = [super initWithFrame:frame];
    if (self) {
        _lastTime = 0.0;
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgView.contentMode = UIViewContentModeScaleAspectFit;
        if ([path hasPrefix:@"http"]) {
            _pathURL = [NSURL URLWithString:path];
        } else {
            _pathURL = [NSURL fileURLWithPath:path];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [self thumbnailImageForVideo:_pathURL atTime:1];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    bgView.image = image;
                });
            }
        });

        [self addSubview:bgView];
        _bgImageView = bgView;
        
        [self initPlayer];
        
        [self addObserver];
        
        [self initControllerView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)viewTapAction
{
    _hiddenView = !_hiddenView;
    [self hiddenControllerView:_hiddenView];
}

- (void)initPlayer
{
    AVAsset *asset = [AVURLAsset URLAssetWithURL:_pathURL options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = _bgImageView.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    playerLayer.contentsScale = [UIScreen mainScreen].scale;
    playerLayer.backgroundColor = [UIColor clearColor].CGColor;
    [_bgImageView.layer addSublayer:playerLayer];
    player.volume = 1.0;
    
    _player = player;
    _playerLayer = playerLayer;
    
    [self showHUD];
}

- (void)showHUD
{
    if (_hud) {
        [_hud hideAnimated:NO];
        [_hud removeFromSuperview];
        _hud = nil;
    }
    _hud = [MBProgressHUD showHUDAddedTo:_bgImageView animated:YES];
    _hud.label.text = @"努力加载中...";
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.animationType = MBProgressHUDAnimationZoom;
}


- (void)resetFrame
{
    _bgImageView.frame = self.bounds;
    _playerLayer.frame = _bgImageView.bounds;
    _titleView.frame = CGRectMake(0, 0, self.bounds.size.width, 64);
    _titleLayer.frame = _titleView.bounds;
    _bottomView.frame = CGRectMake(0, self.bounds.size.height - 50, self.bounds.size.width, 50);
    _bottomLayer.frame = _bottomView.bounds;
    _finishBtn.center = self.center;
    
    if (ScreenWidth > ScreenHeight) {
        [_landscapeBtn setTitle:@"竖屏" forState:UIControlStateNormal];
    } else {
        [_landscapeBtn setTitle:@"横屏" forState:UIControlStateNormal];
    }
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
//    _playerLayer.frame = self.bounds;
//    _playerLayer.player
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [_player.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    
    //监控缓冲加载情况属性
    [_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    //监控播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //监控时间进度
    __weak typeof(self) weakself = self;
    _timeObser = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {

        //当前播放的时间
        NSTimeInterval current = CMTimeGetSeconds(time);
        //视频的总时间
        NSTimeInterval total = CMTimeGetSeconds(weakself.player.currentItem.duration);
        //设置滑块的当前进度
        weakself.progressView.progress = current/total;
        NSLog(@"%f", weakself.progressView.progress);
        //设置时间p
        weakself.timeLabel.text = [NSString stringWithFormat:@"%@/%@", [weakself formatPlayTime:current], [weakself formatPlayTime:total]];
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSTimeInterval loadedTime = [self availableDurationWithplayerItem:playerItem];
        NSLog(@"缓冲进度 %f", loadedTime);
        NSTimeInterval playTime = CMTimeGetSeconds(_player.currentTime);//_player.currentTime
        if (playTime == _lastTime) {
            if (_hud.alpha == 0) {
                [self showHUD];
            }
        } else {
            [_hud hideAnimated:YES];
        }
        _lastTime = playTime;
        
    }else if ([keyPath isEqualToString:@"status"]){
        [_hud hideAnimated:YES];
        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
            NSLog(@"playerItem is ready");
            [self playBtnAction];
        } else {
            [self removeObserver];
            [_delegate playError];
        }
        NSLog(@"播放状态：%ld",(long)playerItem.status);
    }
}



- (void)appWillEnterBackground
{
    [_player pause];
}

- (void)appDidBecomeActive
{
    [_player play];
}

- (void)playbackFinished
{
    _finishBtn.alpha = 1.0;
    [self hiddenControllerView:NO];
}

- (void)initControllerView
{
    __weak typeof(self) weakself = self;
    
    _titleView = [[UIView alloc] init];
    _titleView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    _titleView.frame = CGRectMake(0, 0, self.bounds.size.width, 64);
    
    CAGradientLayer *titleLayer = [CAGradientLayer layer];
    titleLayer.frame = _titleView.bounds;
    titleLayer.startPoint = CGPointMake(0, 1);
    titleLayer.endPoint = CGPointMake(0, 0);
    titleLayer.locations = @[@(0), @(1)];
    titleLayer.colors = @[(id)YColor(0, 0).CGColor, (id)[UIColor colorWithWhite:0.5 alpha:0.5].CGColor];
     _titleLayer = titleLayer;
    [_titleView.layer addSublayer:_titleLayer];
    
    [self addSubview:_titleView];
    
    UIButton *backBtn = [self creatButtonAction:@selector(backAction) Titile:@"返回"];
    [_titleView addSubview:backBtn];
    backBtn.frame = CGRectMake(10, 20, 60, 40);
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.shadowColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [_titleView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backBtn);
        make.left.equalTo(backBtn.mas_right).offset(10);
        make.right.equalTo(weakself.titleView).offset(-80);
        make.height.mas_equalTo(40);
    }];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    _bottomView.frame = CGRectMake(0, self.bounds.size.height - 50, self.bounds.size.width, 50);
    
    CAGradientLayer *bottomLayer = [CAGradientLayer layer];
    bottomLayer.startPoint = CGPointMake(0, 0);
    bottomLayer.endPoint = CGPointMake(0, 1);
    bottomLayer.locations = @[@(0), @(1)];
    bottomLayer.colors = @[(id)YColor(0, 0).CGColor, (id)[UIColor colorWithWhite:0.5 alpha:0.5].CGColor];
    bottomLayer.frame = _bottomView.bounds;
    _bottomLayer = bottomLayer;
    [_bottomView.layer addSublayer:_bottomLayer];
    
    [self addSubview:_bottomView];

    
    _playerBtn = [self creatButtonAction:@selector(playBtnAction) Titile:@"播放"];
    _playerBtn.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:_playerBtn];
    [_playerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.bottomView.mas_left).offset(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *landscapeBtn = [self creatButtonAction:@selector(landscapeAction) Titile:@"横屏"];
    [_bottomView addSubview:landscapeBtn];
    _landscapeBtn = landscapeBtn;
    [_landscapeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.bottomView.mas_right).offset(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.shadowColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.text = @"00:00:00/00:00:00";
    [_bottomView addSubview:_timeLabel];
    
    CGSize size = [self getContentStr:_timeLabel.text widthSize:1000 heightSize:30 FontOfSize:_timeLabel.font];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.landscapeBtn.mas_left);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(10 + size.width);
    }];
    
    _progressView = [[UIProgressView alloc] init];
    _progressView.backgroundColor = [UIColor clearColor];
    _progressView.progressTintColor = [UIColor redColor];
    _progressView.trackTintColor = [UIColor grayColor];
    [_bottomView addSubview:_progressView];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.playerBtn.mas_right);
        make.right.equalTo(weakself.timeLabel.mas_left);
        make.top.mas_equalTo(23.5);
        make.height.mas_equalTo(3);
    }];

    _finishBtn = [self creatButtonAction:@selector(replayTapAction) Titile:@"点击重新播放"];
    _finishBtn.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    _finishBtn.frame = CGRectMake(0, 0, 200, 50);
    _finishBtn.layer.cornerRadius = 5;
    _finishBtn.layer.masksToBounds = YES;
    _finishBtn.center = self.center;
    [self addSubview:_finishBtn];
    _finishBtn.alpha = 0.0;


}

- (void)replayTapAction
{
    _finishBtn.alpha = 0.0;
    [_player.currentItem seekToTime:kCMTimeZero];
    [_player play];
}

- (void)hiddenControllerView:(BOOL)isHidden
{
    [UIView animateWithDuration:0.3 animations:^{
    
        _titleView.frame = CGRectMake(0, isHidden ? -64:0, _titleView.frame.size.width, _titleView.frame.size.height);
        
        _bottomView.frame = CGRectMake(_bottomView.frame.origin.x, isHidden ? self.bounds.size.height:self.bounds.size.height - 50, _bottomView.frame.size.width, _bottomView.frame.size.height);
    }];
}

- (void)backAction
{
    [self removeObserver];
    [_delegate closePlayer];
}

- (void)landscapeAction
{
    [_delegate landscapeDelegate];
}

- (void)removeObserver
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_player.currentItem removeObserver:self forKeyPath:@"status"];
    [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_player removeTimeObserver:_timeObser];
}

- (void)playBtnAction
{
    if ([_playerBtn.currentTitle isEqualToString:@"播放"]) {
        [_playerBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [_player play];
    } else {
        [_playerBtn setTitle:@"播放" forState:UIControlStateNormal];
        [_player pause];
    }
}

- (UIButton *)creatButtonAction:(SEL)action Titile:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

- (NSTimeInterval)availableDurationWithplayerItem:(AVPlayerItem *)playerItem
{
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

//将时间转换成00:00:00格式
- (NSString *)formatPlayTime:(NSTimeInterval)duration
{
    int minute = 0, hour = 0, secend = duration;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, secend];
}

#pragma mark - 计算文本宽高 -
- (CGSize)getContentStr:(NSString *)text widthSize:(CGFloat)width heightSize:(CGFloat)height FontOfSize:(UIFont *)fontSize

{
    CGSize requiredSize;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:fontSize}
                                     context:nil];
    requiredSize = rect.size;
    return requiredSize;
    
}

- (void)dealloc
{
    
    NSLog(@"VideoPlayer dealloc");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
