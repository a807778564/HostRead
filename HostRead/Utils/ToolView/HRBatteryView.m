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

@end

@implementation HRBatteryView

- (instancetype)init{
    if ([super init]) {
        UIView *borerView = [[UIView alloc] init];
        borerView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        borerView.layer.borderWidth = 1.0f;
        [self addSubview:borerView];
        [borerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@18);
            make.height.equalTo(@8);
        }];
        
        UIView *borderHead = [[UIView alloc] init];
        borderHead.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:borderHead];
        [borderHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@2);
            make.height.equalTo(@3);
            make.leading.equalTo(borerView.mas_trailing);
        }];
        
        self.batteryView = [[UIView alloc] init];
        self.batteryView.backgroundColor = [UIColor darkGrayColor];
        [borerView addSubview:self.batteryView];
        [self.batteryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(borerView.mas_top).offset(1.5);
            make.bottom.equalTo(borerView.mas_bottom).offset(-1.5);
            make.leading.equalTo(borerView.mas_leading).offset(1.5);
            make.trailing.equalTo(borerView.mas_trailing).offset(-1.5);
        }];
    }
    return self;
}

- (void)setBatteryLevel:(float)batteryLevel{
    
}

@end
