//
//  ChoseVideoBitRateView.m
//  VideoPlayer
//
//  Created by ydd on 2018/11/24.
//  Copyright © 2018 ydd. All rights reserved.
//

#import "ChoseVideoBitRateView.h"
#import "MyTools.h"
#import "Masonry.h"



@interface ChoseVideoBitRateView ()

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, copy) ChoseBack choseBack;

@end

@implementation ChoseVideoBitRateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithMenuArr:(NSArray *)array choseBack:(ChoseBack)choseBack
{
  self = [super init];
  if (self) {
    self.array = array;
    _choseBack = choseBack;
    [self addMenuItem];
  }
  return self;
}

- (void)addMenuItem
{
  for (int i = 0; i < _array.count; i++) {
    UIButton *btn = [MyTools createButtonWithFrame:CGRectZero title:_array[i] color:[UIColor whiteColor] image:nil target:self action:@selector(menuAction:)];
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.tag = i;
    [self addSubview:btn];
    __weak typeof(self) weakself = self;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(weakself.mas_left);
      make.right.mas_equalTo(weakself.mas_right);
      make.top.mas_equalTo(ItemH * i);
      make.height.mas_equalTo(ItemH);
    }];
  }
}

- (void)menuAction:(UIButton *)btn
{
  if (_choseBack) {
    _choseBack(btn.tag);
  }
}

@end
