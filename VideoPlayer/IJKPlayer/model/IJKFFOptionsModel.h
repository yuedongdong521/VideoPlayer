//
//  IJKFFOptionsModel.h
//  ijkplayerTest
//
//  Created by ydd on 2018/11/22.
//  Copyright © 2018 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKFFOptions.h>
NS_ASSUME_NONNULL_BEGIN

@interface IJKFFOptionsModel : IJKFFOptions
/** 获取 ijk 默认设置 */
+ (IJKFFOptions *)getDefaultIJKFFOptions;

/** ijk 设置示例 */
+ (IJKFFOptions *)getIJKOptions;
@end

NS_ASSUME_NONNULL_END
