//
//  HRReadDetailView.m
//  HostRead
//
//  Created by huangrensheng on 16/8/26.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRReadDetailView.h"
#import "HRBatteryView.h"

@interface HRReadDetailView()

@property (nonatomic, strong) UILabel *titleTxt;

@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, strong) UILabel *contect;

@property (nonatomic, strong) HRBatteryView *batter;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation HRReadDetailView

- (instancetype)init{
    if ([super init]) {
        
        self.titleTxt = [[UILabel alloc] init];
        self.titleTxt.text = @"aaaaad大家三大叔";
        self.titleTxt.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.titleTxt];
        [self.titleTxt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(8);
            make.leading.equalTo(self.mas_leading).offset(kLeftMargin);
            make.height.offset(16);
        }];
        
        self.contect = [[UILabel alloc] init];
        self.contect.numberOfLines = 0;
        self.contect.textAlignment = NSTextAlignmentLeft;
        self.contect.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.contect];
        [self.contect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleTxt.mas_bottom).offset(10);
            make.leading.equalTo(self.mas_leading).offset(kLeftMargin);
            make.trailing.equalTo(self.mas_trailing).offset(-kRightMargin);
        }];
        
        self.batter = [[HRBatteryView alloc] init];
        [self addSubview:self.batter];
        [self.batter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contect.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
            make.leading.equalTo(self.contect.mas_leading);
            make.height.equalTo(@24);
            make.width.equalTo(@23);
        }];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [UIColor darkGrayColor];
        self.timeLabel.font = [UIFont systemFontOfSize:9];
        self.timeLabel.text = [self currentTimeString];
        [self addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.batter.mas_centerY);
            make.leading.equalTo(self.batter.mas_trailing);
        }];
        
        self.pageLabel = [[UILabel alloc] init];
        self.pageLabel.textColor = [UIColor darkGrayColor];
        self.pageLabel.font = [UIFont systemFontOfSize:9];
        self.pageLabel.text = @"0/0";
        [self addSubview:self.pageLabel];
        [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.contect.mas_trailing);
            make.centerY.equalTo(self.batter.mas_centerY);
        }];
    }
    return self;
}

- (void)updateContent:(NSString *)content title:(NSString *)title page:(NSString *)page{
    self.contect.text = content;
    self.titleTxt.text = title;
    self.pageLabel.text = page;
    self.timeLabel.text = [self currentTimeString];
//    self.batter
}

-(NSString *)currentTimeString{
    NSArray *infoArray = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    for (id info in infoArray)
    {
        if ([info isKindOfClass:NSClassFromString(@"UIStatusBarTimeItemView")])
            
        {
            NSString *timeString = [info valueForKeyPath:@"timeString"];
            if ([timeString hasSuffix:@"PM"]) {
                NSArray *timeArray = [timeString componentsSeparatedByString:@":"];
                NSString *hour = timeArray[0];
                NSString *mintue = [timeArray[1] componentsSeparatedByString:@" "][0];
                timeString = [NSString stringWithFormat:@"%ld:%@",[hour integerValue]+12,mintue];
            }else{
                timeString = [timeString componentsSeparatedByString:@" "][0];
            }
            NSLog(@"当前显示时间为：%@",timeString);
            return timeString;
        }
    }
    return @"";
}

//获取电量的等级，0.00~1.00
-(float) getBatteryLevel{
    return [UIDevice currentDevice].batteryLevel;
}

@end
