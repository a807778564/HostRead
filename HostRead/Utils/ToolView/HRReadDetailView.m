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

@property (nonatomic, strong) HRBatteryView *batter;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *headerView;

@end

@implementation HRReadDetailView

- (instancetype)init{
    if ([super init]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"ReadStyle"];
        NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        self.backgroundColor = [dic valueForKey:@"readBack"];
        
        self.titleTxt = [[UILabel alloc] init];
        self.titleTxt.textColor = [dic valueForKey:@"contentColor"];
        self.titleTxt.text = @"";
        self.titleTxt.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.titleTxt];
        [self.titleTxt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(8);
            make.leading.equalTo(self.mas_leading).offset(kLeftMargin);
            make.trailing.equalTo(self.mas_trailing).offset(-kLeftMargin);
            make.height.offset(16);
        }];
        
        self.contect = [[UITextView alloc] init];
        self.contect.userInteractionEnabled = NO;
        self.contect.backgroundColor = [UIColor clearColor];
        self.contect.textColor = [dic valueForKey:@"contentColor"];
        NSLog(@"padding %.2f",self.contect.textContainer.lineFragmentPadding);
//        self.contect.textAlignment = NSTextAlignmentCenter;
        self.contect.font = [UIFont systemFontOfSize:[[NSUserDefaults standardUserDefaults] floatForKey:@"FontSize"]];
        [self addSubview:self.contect];
        [self.contect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleTxt.mas_bottom).offset(10);
            make.leading.equalTo(self.mas_leading).offset(kLeftMargin);
            make.trailing.equalTo(self.mas_trailing).offset(-kLeftMargin);
        }];

        self.batter = [[HRBatteryView alloc] init];
        [self addSubview:self.batter];
        [self.batter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contect.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
            make.leading.equalTo(self.contect.mas_leading).offset(kLeftMargin);
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
            make.trailing.equalTo(self.contect.mas_trailing).offset(-kRightMargin);
            make.centerY.equalTo(self.batter.mas_centerY);
        }];
    }
    return self;
}

- (void)updateContent:(NSString *)content conAtt:(NSMutableDictionary *)conAtt title:(NSString *)title page:(NSString *)page{
    self.contect.text = @"";
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:content attributes:conAtt];
//    [self.contect.textStorage appendAttributedString:attributedString];
    self.contect.attributedText = attributedString;
    self.titleTxt.text = title;
    self.pageLabel.text = page;
    self.timeLabel.text = [self currentTimeString];
    self.batter.batteryLevel = [self getBatteryLevel];
}

- (void)changeReadModel:(UIColor *)backColor contentColor:(UIColor *)contentColor{
    self.contect.textColor = contentColor;
    self.titleTxt.textColor = contentColor;
    self.timeLabel.textColor = contentColor;
    self.pageLabel.textColor = contentColor;
    self.backgroundColor = backColor;
    [self.batter updateColor:contentColor];
}

//当前系统时间
-(NSString *)currentTimeString{
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

//获取电量的等级，0.00~1.00
-(float)getBatteryLevel{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    return [UIDevice currentDevice].batteryLevel;
}

@end
