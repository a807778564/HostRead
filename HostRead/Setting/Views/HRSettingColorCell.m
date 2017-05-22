//
//  HRSettingColorCell.m
//  HostRead
//
//  Created by huangrensheng on 2017/5/17.
//  Copyright © 2017年 kawaii. All rights reserved.
//

#import "HRSettingColorCell.h"


@implementation HRSettingColorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *btnView = [[UIView alloc ] init];
        [self.contentView addSubview:btnView];
        [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        self.colorArray = [NSArray arrayWithObjects:RGBA(1, 187, 156, 1),RGBA(237, 247, 182, 1),RGBA(247, 242, 182, 1),RGBA(193, 236, 168, 1),RGBA(177, 249, 250, 1),RGBA(164, 205, 242, 1),RGBA(161, 170, 250, 1),RGBA(222, 184, 248, 1),RGBA(34, 34, 34, 1),RGBA(255, 255, 255, 1), nil];
        
        for (int i = 0; i<10; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            [btn addTarget:self action:@selector(clickColor:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = self.colorArray[i];
            [btn setLayerCornerRadius:4 borderColor:RGBA(245, 245, 245, 1) borderWidth:1];
            [btnView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i>0) {
                    UIButton *last = btnView.subviews[i-1];
                    if (i%5==0) {
                        make.leading.equalTo(btnView.mas_leading).offset(padding);
                        make.top.equalTo(last.mas_bottom).offset(padding);
                    }else{
                        make.leading.equalTo(last.mas_trailing).offset(padding);
                        make.top.equalTo(last.mas_top);
                    }
                }else{
                    make.top.equalTo(btnView.mas_top).offset(padding);
                    make.leading.equalTo(btnView.mas_leading).offset(padding);
                }
                make.width.offset((ScreenWidth-padding*6)/5);
                make.height.equalTo(btn.mas_width);
            }];
        }
    }
    return self;
}

- (void)clickColor:(UIButton *)btn{
    [self saveChangeColor:self.colorArray[btn.tag]];
    self.chColor(self.colorArray[btn.tag]);
}

- (void)saveChangeColor:(UIColor *)color{
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"ReadStyle"];
    NSMutableDictionary *aadic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([_colorType isEqualToString:@"主题色"]||[_colorType isEqualToString:@"主题文字"]) {
        UINavigationController *na = (UINavigationController *)[[AppDelegate sharedDelegate] getPresentedViewController];
        if ([_colorType isEqualToString:@"主题色"]) {
            [na.navigationBar setBackgroundImage:[UIImage imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
            [aadic setValue:color forKey:@"nav_back_color"];//背景
        }else{
            [na.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, nil]];
            [aadic setValue:color forKey:@"nav_title_color"];//背景
        }
    }else if ([_colorType isEqualToString:@"背景色"]) {
        [aadic setValue:color forKey:@"readBack"];//背景
    }else{
        [aadic setValue:color forKey:@"contentColor"];//字体
    }
    NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:aadic];
    [[NSUserDefaults standardUserDefaults] setValue:personEncodedObject forKey:@"ReadStyle"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
