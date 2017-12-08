//
//  VideoListMode.m
//  VideoPlayer
//
//  Created by ispeak on 2017/12/8.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "VideoListMode.h"

@implementation VideoListMode

- (instancetype)initWihtDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"videolistMode undefinedkey :%@", key);
}

@end
