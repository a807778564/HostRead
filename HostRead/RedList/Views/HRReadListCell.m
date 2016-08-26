//
//  HRReadListCell.m
//  HostRead
//
//  Created by huangrensheng on 16/8/22.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRReadListCell.h"

@implementation HRReadListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.cellIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:self.cellIcon];
        [self.cellIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.leading.equalTo(self.contentView.mas_leading).offset(16);
            make.width.offset(27);
        }];
        
        self.cellLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.cellLabel];
        [self.cellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.cellIcon.mas_trailing).offset(8);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.trailing.equalTo(self.contentView.mas_trailing).offset(-16);
        }];
        
        
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor grayColor];
//        [self addSubview:btn];
        [self insertSubview:btn atIndex:0];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self);
            make.trailing.equalTo(self.mas_trailing);
            make.width.offset(60);
        }];
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
