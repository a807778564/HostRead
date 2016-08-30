//
//  HRBatteryView.m
//  HostRead
//
//  Created by huangrensheng on 16/8/26.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRBatteryView.h"

@interface HRBatteryView()

@property (nonatomic, strong) UIView *batteryView;

@property (nonatomic, strong) UIView *borerView;

@property (nonatomic, strong) UIView *borderHead;

@end

@implementation HRBatteryView

- (instancetype)init{
    if ([super init]) {
        self.borerView = [[UIView alloc] init];
        self.borerView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.borerView.layer.borderWidth = 1.0f;
        [self addSubview:self.borerView];
        [self.borerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@18);
            make.height.equalTo(@8);
        }];
        
        self.borderHead = [[UIView alloc] init];
        self.borderHead.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:self.borderHead];
        [self.borderHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@2);
            make.height.equalTo(@3);
            make.leading.equalTo(self.borerView.mas_trailing);
        }];
        
        self.batteryView = [[UIView alloc] init];
        self.batteryView.backgroundColor = [UIColor darkGrayColor];
        [self.borerView addSubview:self.batteryView];
        [self.batteryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.borerView.mas_top).offset(1.5);
            make.bottom.equalTo(self.borerView.mas_bottom).offset(-1.5);
            make.leading.equalTo(self.borerView.mas_leading).offset(1.5);
//            make.trailing.equalTo(borerView.mas_trailing).offset(-1.5);
            make.width.equalTo(@15);
        }];
    }
    return self;
}

- (void)updateColor:(UIColor *)color{
    self.borerView.layer.borderColor = color.CGColor;
    self.borderHead.backgroundColor = color;
    self.batteryView.backgroundColor = color;
}

- (void)setBatteryLevel:(float)batteryLevel{
    [self.batteryView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(15*batteryLevel));
    }];
}

@end
