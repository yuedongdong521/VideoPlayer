//
//  MyTools.m
//  VideoPlayer
//
//  Created by ispeak on 2017/12/14.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "MyTools.h"

@implementation MyTools

+ (void)addGradLayerForTargetView:(UIView *)targetView
                    ForStartPoint:(CGPoint)startPoint
                      ForEndPoint:(CGPoint)endPoint
                     ForLocations:(NSArray<NSNumber *> *)locations
                        ForColors:(NSArray *)colors
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = targetView.bounds;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.locations = locations;
    gradientLayer.colors = colors;
    [targetView.layer addSublayer:gradientLayer];
}

+ (CAGradientLayer *)getGradLayerWidthFrame:(CGRect)frame fromeColor:(nonnull UIColor *)formeColor toColor:(nonnull UIColor *)toColor
{
  CAGradientLayer *gradientLayer = [CAGradientLayer layer];
  gradientLayer.frame = frame;
  gradientLayer.startPoint = CGPointMake(0, 0);
  gradientLayer.endPoint = CGPointMake(0, 1);
  gradientLayer.locations = @[@(0), @(1)];
  gradientLayer.colors = @[(__bridge id)formeColor.CGColor, (__bridge id)toColor.CGColor];
  return gradientLayer;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color image:(UIImage *)image target:(id)target action:(SEL)action
{
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  if (!CGRectEqualToRect(frame, CGRectZero)) {
    btn.frame = frame;
  }
  if (title) {
    [btn setTitle:title forState:UIControlStateNormal];
  }
  if (color) {
    [btn setTitleColor:color forState:UIControlStateNormal];
  }
  if (image) {
    [btn setImage:image forState:UIControlStateNormal];
  }
  [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  return btn;
}


@end
