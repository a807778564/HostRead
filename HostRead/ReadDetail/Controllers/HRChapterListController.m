//
//  HRChapterListController.m
//  HostRead
//
//  Created by huangrensheng on 16/8/27.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRChapterListController.h"
#import "HRReadDetailController.h"
#import "HRTxtModel.h"

@interface HRChapterListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *chapterTable;

@property (nonatomic, strong) HRDBHelper *helper;

@end

@implementation HRChapterListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.helper = [[HRDBHelper alloc] init];
    
    self.title = @"目录";
    [self setBackBtn];
    // Do any additional setup after loading the view.
    self.chapterTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.chapterTable.delegate = self;
    self.chapterTable.dataSource = self;
    [self.view addSubview:self.chapterTable];
    [self.chapterTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSUInteger ii[2] = {0, [self.txtModel.readChapter integerValue]};
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
    [self.chapterTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.txtModel.allChapter integerValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"normalTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    }
    if (indexPath.row == [self.txtModel.readChapter integerValue]) {
        cell.backgroundColor = RGBA(0, 0, 0, 0.1);
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    NSMutableDictionary *dic = [self.helper chapterTitleWithTxtId:self.txtModel.txtId chaperIdx:indexPath.row];
    cell.textLabel.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSMutableDictionary *dic = [self.helper chapterTitleWithTxtId:self.txtModel.txtId chaperIdx:indexPath.row];
    self.txtModel.readChapter = [NSString stringWithFormat:@"%ld",indexPath.row];
    self.txtModel.redPage = @"0";
    
    for (UIViewController *con in self.navigationController.childViewControllers) {
        if ([con isKindOfClass:[HRReadDetailController class]]) {
            HRReadDetailController *read = (HRReadDetailController *)con;
            read.txtModel = self.txtModel;
            [self.navigationController popToViewController:read animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doLeftAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
