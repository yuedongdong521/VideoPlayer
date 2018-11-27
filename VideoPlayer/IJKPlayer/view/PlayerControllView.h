//
//  PlayerControllView.h
//  VideoPlayer
//
//  Created by ydd on 2018/11/23.
//  Copyright © 2018 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
  PlayerVideoBitRate_360p = 0,
  PlayerVideoBitRate_480p,
  PlayerVideoBitRate_640p,
  PlayerVideoBitRate_720p,
  PlayerVideoBitRate_960p,
  PlayerVideoBitRate_1080p
} PlayerVideoBitRate;

@protocol PlayerControllViewDelegate <NSObject>

- (void)backDelegate;

- (void)playerActionDeleagte;

- (void)changeScreenDircetion;

- (void)changePlayerVideoBitRate:(NSInteger)bitRateIndex;

@end

@interface PlayerControllView : UIView

@property(nonatomic, weak) id<PlayerControllViewDelegate> delegate;

- (void)setVideoTitle:(NSString *)title;

- (void)layoutFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
