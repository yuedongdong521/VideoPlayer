//
//  MyTools.h
//  VideoPlayer
//
//  Created by ispeak on 2017/12/14.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTools : NSObject

+ (void)addGradLayerForTargetView:(UIView *)targetView
                    ForStartPoint:(CGPoint)startPoint
                      ForEndPoint:(CGPoint)endPoint
                     ForLocations:(NSArray<NSNumber*> *)locations
                        ForColors:(NSArray *)colors;

+ (CAGradientLayer *)getGradLayerWidthFrame:(CGRect)frame fromeColor:(nonnull UIColor *)formeColor toColor:(nonnull UIColor *)toColor;

+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color image:(UIImage *)image target:(id)target action:(SEL)action;

@end
