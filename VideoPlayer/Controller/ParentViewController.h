//
//  ParentViewController.h
//  VideoPlayer
//
//  Created by ydd on 2018/11/22.
//  Copyright © 2018 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParentViewController : UIViewController
/** 是否切换屏幕 */
@property (nonatomic, assign) BOOL isRotatingScreen;

/** 切换屏幕方向调整 ui */
- (void)layoutUI;
/** 横竖屏切换 */
- (void)changeScreenBtnAction;
/** 切换指定方向 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation;
/** 设置系统透明导航栏 */
- (void)transparentNavigation:(BOOL)isTransparen;
/** 侧滑退出当前控制器 */
- (void)didPopTopParentViewController;

@end

NS_ASSUME_NONNULL_END
