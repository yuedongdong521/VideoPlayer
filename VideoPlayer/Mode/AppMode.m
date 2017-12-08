//
//  AppMode.m
//  VideoPlayer
//
//  Created by ispeak on 2017/12/7.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "AppMode.h"

@implementation AppMode

+ (instancetype)shareAppMode
{
    static dispatch_once_t onceToken;
    static AppMode *appMode;
    dispatch_once(&onceToken, ^{
        appMode = [[AppMode alloc]init];
    });
    return appMode;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _preformeLandscape = NO;
    }
    return self;
}

@end
