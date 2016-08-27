//
//  HRChapterListController.m
//  HostRead
//
//  Created by huangrensheng on 16/8/27.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRChapterListController.h"

@interface HRChapterListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *chapterTable;

@end

@implementation HRChapterListController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allChapters.count;
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
    NSMutableDictionary *dic = self.allChapters[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}

- (void)doLeftAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
