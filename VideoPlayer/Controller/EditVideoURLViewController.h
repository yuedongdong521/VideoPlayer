//
//  EditVideoURLViewController.h
//  VideoPlayer
//
//  Created by ispeak on 2017/12/6.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditVideoURLViewControllerDelegate

- (void)addPlayDelegateForName:(NSString *)name ForUrl:(NSString *)url;

@end

@interface EditVideoURLViewController : UIViewController

@property (nonatomic, weak) id<EditVideoURLViewControllerDelegate> delegate;

@end


