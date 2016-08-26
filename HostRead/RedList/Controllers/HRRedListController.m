//
//  HRRedListController.m
//  HostRead
//
//  Created by huangrensheng on 16/8/22.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRRedListController.h"
#import "HRReadListCell.h"
#import "HRAllFloderController.h"
#import "HRTxtModel.h"
#import "HRReadDetailController.h"
#import "HRDecTxtTool.h"

@interface HRRedListController ()

@property (nonatomic, strong) UITableView *fileTable;

@property (nonatomic, strong) NSMutableArray *fileList;

@property (nonatomic, strong) NSMutableArray *floderList;

@end

@implementation HRRedListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setRightBtn];
    if (self.floderName) {
        self.title = self.floderName;
    }else{
        self.title = @"全部文件";
    }
    self.fileTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.fileTable.dataSource = self;
    self.fileTable.delegate = self;
    self.fileTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.fileTable];
    [self.fileTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (!self.floderPath) {
        self.floderPath = documentPath;
    }else{
        [self setBackBtn];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadFileData];
}

- (void)loadFileData{
    [[HRReadTool shareInstance] getHostFileListWithPath:self.floderPath fileInfo:^(NSMutableArray *floderList, NSMutableArray *fileList) {
        self.floderList = floderList;
        self.fileList = fileList;
        [self.fileTable reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.floderList.count+self.fileList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *path = @"";
    NSString *fileName = @"";
    if (indexPath.row < self.floderList.count) {
        path = [NSString stringWithFormat:@"%@/%@",self.floderPath,self.floderList[indexPath.row]];
        fileName = self.floderList[indexPath.row];
    }else{
        path = [NSString stringWithFormat:@"%@/%@",self.floderPath,self.fileList[indexPath.row-self.floderList.count]];
        fileName = self.fileList[indexPath.row-self.floderList.count];
    }
    //添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [[HRReadTool shareInstance] removeItem:path];
        [self loadFileData];
    }];
    
    //添加一个移动
    UITableViewRowAction *setDefaultRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"移动" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        HRAllFloderController *all = [[HRAllFloderController alloc] init];
        all.oldFilePath = path;
        all.oldFileName = fileName;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:all];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
        NSLog(@"回调方法");
    }];
    
    return @[deleteRowAction,setDefaultRowAction];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identider = @"HRReadListCell";
    
    HRReadListCell *cell = [tableView dequeueReusableCellWithIdentifier:identider];
    
    if (!cell) {
        cell = [[HRReadListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identider];
    }
    if (self.floderList.count > 0 && indexPath.row < self.floderList.count) {
        [cell.cellIcon setImage:[UIImage imageNamed:@"redlist_floders"]];
        cell.cellLabel.text = self.floderList[indexPath.row];
    }else{
        [cell.cellIcon setImage:[UIImage imageNamed:@"filelist_files"]];
        cell.cellLabel.text = self.fileList[indexPath.row-self.floderList.count];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.floderList.count) {
        HRRedListController *list = [[HRRedListController alloc] init];
        list.floderPath = [NSString stringWithFormat:@"%@/%@",self.floderPath,self.floderList[indexPath.row]];
        list.floderName = self.floderList[indexPath.row];
        list.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:list animated:YES];
    }else{
        NSString *plistPath = [NSString stringWithFormat:@"%@/%@",self.floderPath,self.fileList[indexPath.row-self.floderList.count]];
        NSURL *url = [NSURL fileURLWithPath:plistPath];
        HRTxtModel *model = [[[HRDecTxtTool alloc] init] decoWithUrl:url];
        
//        HRTxtModel *model =  [[HRTxtModel alloc] getTxtModelWith:url];
        HRReadDetailController *detail = [[HRReadDetailController alloc] init];
        detail.txtModel  = model;
        [self presentViewController:detail animated:YES completion:^{
            
        }];
//        NSLog(@"aaaaaaa");
        
//        NSString *plistPath = [NSString stringWithFormat:@"%@/%@",self.floderPath,self.fileList[indexPath.row-self.floderList.count]];
//        //gbk编码 如果txt文件为utf-8的则使用NSUTF8StringEncoding
//        NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//        //定义字符串接收从txt文件读取的内容
//        NSString *str = [[NSString alloc] initWithContentsOfFile:plistPath encoding:gbk error:nil];
//        //将字符串转为nsdata类型
//        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];

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
