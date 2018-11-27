//
//  PlayerControllView.m
//  VideoPlayer
//
//  Created by ydd on 2018/11/23.
//  Copyright © 2018 ydd. All rights reserved.
//

#import "PlayerControllView.h"
#import "Masonry.h"
#import "MyTools.h"
#import "ChoseVideoBitRateView.h"

#define ToolsHeight 50.0

@interface PlayerControllView ()

@property (nonatomic, strong) UIView *handerView;

@property(nonatomic, strong) UIView *footerView;

@property(nonatomic, strong) CAGradientLayer *handerLayer;
@property(nonatomic, strong) CAGradientLayer *footerLayer;

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) NSArray *bitRateArray;
@property(nonatomic, strong) ChoseVideoBitRateView *bitMenuView;
@property(nonatomic, strong) UIButton *changeRateBtn;

@end


@implementation PlayerControllView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    [self createHander];
    [self createFooter];
    [self addGesture];
  }
  return self;
}

- (void)addGesture
{
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
  [self addGestureRecognizer:tap];
}

- (void)setVideoTitle:(NSString *)title
{
  self.titleLabel.text = title;
}

- (void)layoutFrame:(CGRect)frame
{
  self.frame = frame;
  CGFloat width = frame.size.width;
  CGFloat height = frame.size.height;
  self.handerView.frame = CGRectMake(0, 0, width, ToolsHeight);
  self.footerView.frame = CGRectMake(0, height - ToolsHeight, width, ToolsHeight);
  self.handerLayer.frame = self.handerView.bounds;
  self.footerLayer.frame = self.handerView.bounds;
}

- (void)hiddenHanderAndFooterView:(BOOL)isHidden
{
  CGRect handerFrame = self.handerView.frame;
  CGRect footerFrame = self.footerView.frame;
  if (isHidden) {
    handerFrame.origin.y =  -handerFrame.size.height;
    footerFrame.origin.y = self.frame.size.height;
  } else {
    handerFrame.origin.y = 0;
    footerFrame.origin.y = self.frame.size.height - footerFrame.size.height;
  }
  [UIView animateWithDuration:0.3 animations:^{
    self.handerView.frame = handerFrame;
    self.footerView.frame = footerFrame;
  } completion:^(BOOL finished) {
    
  }];
}


- (void)createHander
{
  [self addSubview:self.handerView];
  
  UIButton *back = [MyTools createButtonWithFrame:CGRectZero title:@"<返回" color:[UIColor whiteColor] image:nil target:self action:@selector(backAction)];
  [self.handerView addSubview:back];
  
  [self.handerView addSubview:self.titleLabel];
  
  __weak typeof(self) weakself = self;
  [back mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(weakself.handerView.mas_height);
    make.left.mas_equalTo(weakself.handerView.mas_left).mas_offset(10);
    make.top.mas_equalTo(weakself.handerView.mas_top);
    make.width.mas_equalTo(ToolsHeight);
  }];
  
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(back.mas_right).mas_offset(10);
    make.top.mas_equalTo(10);
    make.bottom.mas_equalTo(-10);
    make.right.mas_equalTo(weakself.handerView.mas_right).mas_offset(-20);
  }];
}

- (void)createFooter
{
  [self addSubview:self.footerView];
  
  UIButton *playBtn = [MyTools createButtonWithFrame:CGRectZero title:@"播放" color:[UIColor whiteColor] image:nil target:self action:@selector(playBtnAction:)];
  [playBtn setTitle:@"暂停" forState:UIControlStateSelected];
  [playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
  [self.footerView addSubview:playBtn];
  
  UIButton *screenBtn = [MyTools createButtonWithFrame:CGRectZero title:@"竖屏" color:[UIColor whiteColor] image:nil target:self action:@selector(changeScreenDirection:)];
  [screenBtn setTitle:@"横屏" forState:UIControlStateSelected];
  [screenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
  [self.footerView addSubview:screenBtn];
  
  UIButton *changeRate = [MyTools createButtonWithFrame:CGRectZero title:self.bitRateArray[0] color:[UIColor whiteColor] image:nil target:self action:@selector(changeRateAction:)];
  _changeRateBtn = changeRate;
  [self.footerView addSubview:_changeRateBtn];
//  _changeRateBtn.hidden = YES;
  [self addSubview:self.bitMenuView];
  
  __weak typeof(self) weakself = self;
  [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(weakself.footerView.mas_left).mas_offset(10);
    make.top.mas_equalTo(weakself.footerView.mas_top);
    make.height.mas_equalTo(weakself.footerView.mas_height);
    make.width.mas_equalTo(ToolsHeight);
  }];
  
  [screenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(weakself.footerView.mas_right).mas_offset(-10);
    make.top.mas_equalTo(weakself.footerView.mas_top);
    make.height.mas_equalTo(weakself.footerView.mas_height);
    make.width.mas_equalTo(ToolsHeight);
  }];
  
  [changeRate mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(screenBtn.mas_left).mas_offset(-10);
    make.top.mas_equalTo(weakself.footerView.mas_top);
    make.height.mas_equalTo(weakself.footerView.mas_height);
    make.width.mas_equalTo(ItemH);
  }];
  CGFloat menuHeight = self.bitRateArray.count * ItemH;
  [self.bitMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(changeRate.mas_right);
    make.bottom.mas_equalTo(changeRate.mas_top).mas_offset(5);
    make.height.mas_equalTo(menuHeight);
    make.width.mas_equalTo(ItemW);
  }];
}

- (void)changeRateAction:(UIButton *)btn
{
  self.bitMenuView.hidden = !self.bitMenuView.hidden;
}

- (void)tapGestureAction:(UIGestureRecognizer *)tap
{
  [self hiddenHanderAndFooterView:self.handerView.frame.origin.y == 0];
}

- (void)backAction
{
  if (_delegate && [_delegate respondsToSelector:@selector(backDelegate)]) {
    [_delegate backDelegate];
  }
}

- (void)playBtnAction:(UIButton *)btn
{
  btn.selected = !btn.selected;
  if (_delegate && [_delegate respondsToSelector:@selector(playerActionDeleagte)]) {
    [_delegate playerActionDeleagte];
  }
}

- (void)changeScreenDirection:(UIButton *)btn
{
  btn.selected = !btn.selected;
  if (_delegate && [_delegate respondsToSelector:@selector(changeScreenDircetion)]) {
    [_delegate changeScreenDircetion];
  }
}

- (UIView *)handerView
{
  if (!_handerView) {
    _handerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ToolsHeight)];
    _handerLayer = [MyTools getGradLayerWidthFrame:self.handerView.bounds fromeColor:[UIColor blackColor] toColor:[UIColor clearColor]];
    [_handerView.layer addSublayer:self.handerLayer];
  }
  return _handerView;
}

- (UIView *)footerView
{
  if (!_footerView) {
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - ToolsHeight, ScreenWidth, ToolsHeight)];
    _footerLayer = [MyTools getGradLayerWidthFrame:self.footerView.bounds fromeColor:[UIColor clearColor] toColor:[UIColor blackColor]];
    [_footerView.layer addSublayer:_footerLayer];

  }
  return _footerView;
}

- (UILabel *)titleLabel
{
  if (!_titleLabel) {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  }
  return _titleLabel;
}

- (ChoseVideoBitRateView *)bitMenuView
{
  if (!_bitMenuView) {
    __weak typeof(self) weakself = self;
    _bitMenuView = [[ChoseVideoBitRateView alloc] initWithMenuArr:self.bitRateArray choseBack:^(NSInteger index) {
      [weakself changeVideoBitRate:index];
    }];
    _bitMenuView.hidden = YES;
    _bitMenuView.backgroundColor = [UIColor redColor];
  }
  return _bitMenuView;
}

- (void)changeVideoBitRate:(NSInteger)rateIndex
{
  [_changeRateBtn setTitle:_bitRateArray[rateIndex] forState:UIControlStateNormal];
  if (_delegate && [_delegate respondsToSelector:@selector(changePlayerVideoBitRate:)]) {
    [_delegate changePlayerVideoBitRate:rateIndex];
  }
}

- (NSArray *)bitRateArray
{
  if (!_bitRateArray) {
    _bitRateArray = @[@"流畅", @"标清", @"高清", @"超清", @"960p"];
  }
  return _bitRateArray;
}

@end
