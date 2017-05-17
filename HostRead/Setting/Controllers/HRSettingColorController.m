//
//  HRSettingColorController.m
//  HostRead
//
//  Created by huangrensheng on 2017/5/17.
//  Copyright © 2017年 kawaii. All rights reserved.
//

#import "HRSettingColorController.h"
#import "HRSettingColorCell.h"
#import "HRColorRGBACell.h"

@interface HRSettingColorController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *colorTable;
@property (nonatomic, strong) UITextView *headerText;
@property (nonatomic, strong) UIView *header;
@end

@implementation HRSettingColorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackBtn];
    self.title = self.colorTitle;
    self.colorTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.colorTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.colorTable.delegate = self;
    self.colorTable.dataSource = self;
    self.colorTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.colorTable];
    [self.colorTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.colorTitle isEqualToString:@"主题色"]) {
        return 0.001;
    }
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.colorTitle isEqualToString:@"主题色"]) {
        return nil;
    }
    self.header = [[UIView alloc] init];
    self.headerText = [[UITextView alloc] initWithFrame:CGRectMake(kLeftMargin, 0, ScreenWidth-kLeftMargin*2, 150)];
    [self.header addSubview:self.headerText];
    [self setTextStyle:self.header];
    return self.header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        return 180;
    }
    return ((ScreenWidth-padding*6)/5)*2+padding*3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        static NSString *identifer = @"HRColorRGBACell";
        HRColorRGBACell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[HRColorRGBACell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        cell.colorType = self.colorTitle;
        cell.chColor = ^(UIColor *color){
            [self setTextStyle:self.header];
        };
        return cell;
    }else{
        static NSString *identifer = @"HRSettingColorCell";
        HRSettingColorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[HRSettingColorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        cell.colorType = self.colorTitle;
        cell.chColor = ^(UIColor *color){
            [self setTextStyle:self.header];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)setTextStyle:(UIView *)head{
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"ReadStyle"];
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSData *text = [[NSUserDefaults standardUserDefaults] dataForKey:@"textStyle"];
    NSMutableDictionary *textDic = [NSKeyedUnarchiver unarchiveObjectWithData:text];
    NSString *textString = @"寒蝉凄切，对长亭晚，骤雨初歇。都门帐饮无绪，留恋处舟催发。执手相看泪眼，竟无语凝噎。念去去千里烟波，暮霭沉沉楚天阔。";
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:textString attributes:textDic];
    self.headerText.attributedText = attributedString;
    self.headerText.userInteractionEnabled = NO;
    self.headerText.backgroundColor = [UIColor clearColor];
    head.backgroundColor = [dic valueForKey:@"readBack"];
    self.headerText.textColor = [dic valueForKey:@"contentColor"];
    self.headerText.font = [UIFont systemFontOfSize:[[NSUserDefaults standardUserDefaults] floatForKey:@"FontSize"]];
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
