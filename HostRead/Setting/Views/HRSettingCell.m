//
//  HRSettingCell.m
//  HostRead
//
//  Created by huangrensheng on 2017/5/16.
//  Copyright © 2017年 kawaii. All rights reserved.
//

#import "HRSettingCell.h"

@interface HRSettingCell()

@end

@implementation HRSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.settLabel = [[UILabel alloc] initWithFont:[UIFont systemFontOfSize:15] TextColor:RGBA(105, 105, 105, 1) Text:@""];
        [self.contentView addSubview:self.settLabel];
        [self.settLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView.mas_leading).offset(16);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBtn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.rightBtn];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.contentView.mas_trailing).offset(-16);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString{
    self.settLabel.text = titleString;
    if ([titleString isEqualToString:@"密码保护"]) {
        [self.rightBtn setTitleColor:RGBA(151, 151, 151, 1) forState:UIControlStateNormal];
        [self.rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"appPass"]) {
            [self.rightBtn setTitle:@"开启" forState:UIControlStateNormal];
        }else{
            [self.rightBtn setTitle:@"关闭" forState:UIControlStateNormal];
        }
    }else{
        [self.rightBtn setImage:[UIImage imageNamed:@"hr_right_arrow.png"] forState:UIControlStateNormal];
    }
}

- (void)touchBtn:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"开启"]) {
        [self.rightBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"appPass"];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
