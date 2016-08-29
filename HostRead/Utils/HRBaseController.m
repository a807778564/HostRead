//
//  HRBaseController.m
//  HostRead
//
//  Created by huangrensheng on 16/8/22.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRBaseController.h"

@interface HRBaseController ()

@end

@implementation HRBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexa:@"#00bb9c"]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)setBackBtn{
    UIImage *image = [UIImage imageNamedWithoutNOSelectBlue:@"nav_back"];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(doLeftAction:)];
    self.navigationItem.leftBarButtonItem = backBtn;
}

- (void)setRightBtn{
    UIImage *image = [UIImage imageNamedWithoutNOSelectBlue:@"nav_add"];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(doRightAction:)];
    self.navigationItem.rightBarButtonItem = backBtn;
}

- (void)setRightBtnWithTxt:(NSString *)text{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:text size:CGSizeMake(44, 44) target:self action:@selector(doRightAction:)];
    self.navigationItem.rightBarButtonItem = backBtn;
}

- (void)doLeftAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doRightAction:(id)sender{
    
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
