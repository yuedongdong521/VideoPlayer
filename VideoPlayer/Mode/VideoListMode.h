//
//  VideoListMode.h
//  VideoPlayer
//
//  Created by ispeak on 2017/12/8.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoListMode : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *playerURL;
- (instancetype)initWihtDic:(NSDictionary *)dic;
@end
