//
//  PlayerView.h
//  VideoPlayer
//
//  Created by ispeak on 2017/12/6.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerVideoDelegate

- (void)closePlayer;

- (void)playError;

- (void)landscapeDelegate;



@end

@interface PlayerView : UIView

@property (nonatomic, weak) id<PlayerVideoDelegate>delegate;

@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithFrame:(CGRect)frame WithPath:(NSString *)path;
- (void)resetFrame;
@end
