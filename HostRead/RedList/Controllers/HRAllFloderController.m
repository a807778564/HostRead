//
//  HRAllFloderController.m
//  HostRead
//
//  Created by huangrensheng on 16/8/23.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRAllFloderController.h"
#import "HRReadListCell.h"

@interface HRAllFloderController ()

@property (nonatomic, strong) UITableView *allFloder;

@property (nonatomic, strong) NSMutableArray *floderList;

@end

@implementation HRAllFloderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.floderName) {
        self.title = self.floderName;
    }else{
        self.title = @"移动到文件夹";
    }

    [self setRightBtn];
    
    self.allFloder = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.allFloder.dataSource = self;
    self.allFloder.delegate = self;
    self.allFloder.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.allFloder];
    [self.allFloder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self setBackBtn];
    if (!self.floderPath) {
        self.floderPath = documentPath;
    }
  
    UIButton *sure = [[UIButton alloc] init];
    [sure addTarget:self action:@selector(sureBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setBackgroundColor:mainColor];
    sure.layer.borderWidth = 1.0f;
    sure.layer.cornerRadius = 22.0f;
    sure.layer.borderColor = mainColor.CGColor;
    [self.view addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(44);
        make.height.offset(44);
        make.bottom.equalTo(self.view.mas_bottom).offset(-16);
        make.trailing.equalTo(self.view.mas_trailing).offset(-16);
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadFileData];
}

- (void)sureBtnOnClick:(UIButton *)sure{
    [[HRReadTool shareInstance] moveFileName:self.oldFilePath newPath:[NSString stringWithFormat:@"%@/%@",self.floderPath,self.oldFileName]];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)loadFileData{
    [[HRReadTool shareInstance] getHostFileListWithPath:self.floderPath fileInfo:^(NSMutableArray *floderList, NSMutableArray *fileList) {
        self.floderList = floderList;
        [self.allFloder reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.floderList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identider = @"HRReadListCell";
    HRReadListCell *cell = [tableView dequeueReusableCellWithIdentifier:identider];
    if (!cell) {
        cell = [[HRReadListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identider];
    }
    [cell.cellIcon setImage:[UIImage imageNamed:@"redlist_floders"]];
    cell.cellLabel.text = self.floderList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HRAllFloderController *list = [[HRAllFloderController alloc] init];
    list.floderPath = [NSString stringWithFormat:@"%@/%@",self.floderPath,self.floderList[indexPath.row]];
    list.floderName = self.floderList[indexPath.row];
    list.oldFilePath = self.oldFilePath;
    list.oldFileName = self.oldFileName;
    list.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:list animated:YES];
}

- (void)doLeftAction:(id)sender{
    if (self.floderName) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)doRightAction:(id)sender{
    __block UITextField *text = nil;
    UIAlertController *addFloder = [UIAlertController alertControllerWithTitle:@"新建文件夹" message:@"输入你想要创建的文件夹名称" preferredStyle:UIAlertControllerStyleAlert];
    [addFloder addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [addFloder addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[HRReadTool shareInstance] creatFileFolder:[NSString stringWithFormat:@"%@/%@",self.floderPath,text.text]];
        [self loadFileData];
    }]];
    [addFloder addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        text = textField;
        // 可以在这里对textfield进行定制，例如改变背景色
    }];
    [self presentViewController:addFloder animated:YES completion:^{
        
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
