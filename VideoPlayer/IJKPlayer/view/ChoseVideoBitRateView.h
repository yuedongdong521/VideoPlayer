//
//  ChoseVideoBitRateView.h
//  VideoPlayer
//
//  Created by ydd on 2018/11/24.
//  Copyright © 2018 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChoseBack)(NSInteger index);

#define ItemH 40
#define ItemW 60

@interface ChoseVideoBitRateView : UIView

- (instancetype)initWithMenuArr:(NSArray *)array choseBack:(ChoseBack)choseBack;

@end

NS_ASSUME_NONNULL_END
