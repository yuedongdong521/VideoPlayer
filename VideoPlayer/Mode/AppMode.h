//
//  AppMode.h
//  VideoPlayer
//
//  Created by ispeak on 2017/12/7.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppMode : NSObject

@property (nonatomic, assign) BOOL preformeLandscape;

+ (instancetype)shareAppMode;

@end
