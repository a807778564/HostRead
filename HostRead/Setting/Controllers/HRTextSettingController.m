//
//  HRTextSettingController.m
//  HostRead
//
//  Created by huangrensheng on 2017/5/23.
//  Copyright © 2017年 kawaii. All rights reserved.
//

#import "HRTextSettingController.h"

@interface HRTextSettingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *settTable;
@property (nonatomic, strong) NSArray *cellArray;
@end

@implementation HRTextSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self setBackBtn];
    
    self.settTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.settTable.dataSource = self;
    self.settTable.delegate = self;
    self.settTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.settTable];
    [self.settTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.cellArray = [NSArray arrayWithObjects:@"行高",@"字体大小",@"背景色",@"字体颜色",@"文字样式",@"密码保护",@"清理重置", nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifer = @"HRSettingCell";
//    HRSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
//    if (!cell) {
//        cell = [[HRSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
//    }
//    cell.titleString = self.cellArray[indexPath.row];
    return [[UITableViewCell alloc] init];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
