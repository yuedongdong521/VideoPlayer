//
//  EditVideoURLViewController.m
//  VideoPlayer
//
//  Created by ispeak on 2017/12/6.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "EditVideoURLViewController.h"
#import "VideoPlayerViewController.h"

@interface EditVideoURLViewController ()

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *urlField;

@end

@implementation EditVideoURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:40 / 255.0 green:41 / 255.0 blue:51 / 255.0 alpha:1];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(addFinish)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 95 + 80 * i, 40, 50)];
        label.text = i == 0 ? @"标题" : @"地址:";
        label.textColor = [UIColor lightTextColor];
        label.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:label];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(70, 100 + 80 * i, self.view.bounds.size.width - 85 - 50, 40)];
        textField.layer.cornerRadius = 5.0;
        textField.layer.masksToBounds = YES;
        textField.textColor = [UIColor blackColor];
        textField.backgroundColor = [UIColor whiteColor];
        textField.layer.borderColor = [UIColor grayColor].CGColor;
        textField.placeholder = i == 0 ? @"请输入播放标题" : @"请输入播放地址";
        [self.view addSubview:textField];
        if (i == 0) {
            _nameField = textField;
        } else {
            _urlField = textField;
        }
        UIButton *clear = [self creatButtonAction:@selector(clearAction:) Titile:@"清除"];
        clear.backgroundColor = [UIColor clearColor];
        clear.frame = CGRectMake(ScreenWidth - 50, 100 + 80 * i, 40, 40);
        clear.tag = i;
        [self.view addSubview:clear];
    }
}

- (void)clearAction:(UIButton *)btn
{
    if (btn.tag == 0) {
        _nameField.text = @"";
    } else {
        _urlField.text = @"";
    }
}

- (void)addFinish
{
    if (_nameField.text.length > 0 && _urlField.text.length > 0) {
        [_delegate addPlayDelegateForName:_nameField.text ForUrl:_urlField.text];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSString *str = @"";
        if (_nameField.text.length < 1) {
            str = @"请输入标题";
        } else {
            str = @"请输入地址";
        }
        [[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil] show];
    }
}

- (UIButton *)creatButtonAction:(SEL)action Titile:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:50 / 255.0 blue:100 / 255.0 alpha:1.0];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
