//
//  HRDetailSettingView.m
//  HostRead
//
//  Created by huangrensheng on 16/8/29.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRDetailSettingView.h"

@implementation HRDetailSettingView

- (instancetype)init{
    if ([super init]) {
        
        self.backgroundColor = mainColor;
        
        UIButton *upChapter = [[UIButton alloc] initWithTitle:@"上一章" font:[UIFont systemFontOfSize:15] coclor:[UIColor whiteColor]];
        upChapter.tag = SettingTypeUpChapter;
        [upChapter addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:upChapter];
        [upChapter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(@44);
            make.width.equalTo(@65);
        }];
        
        UIButton *nextChapter = [[UIButton alloc] initWithTitle:@"下一章" font:[UIFont systemFontOfSize:15] coclor:[UIColor whiteColor]];
        nextChapter.tag = SettingTypeNextChapter;
        [nextChapter addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextChapter];
        [nextChapter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(@44);
            make.width.equalTo(@65);
        }];
        
        UIButton *fontReduce = [[UIButton alloc] initWithTitle:@"A-" font:[UIFont systemFontOfSize:15] coclor:[UIColor whiteColor]];
        fontReduce.tag = SettingTypeFontReduce;
        [fontReduce addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fontReduce];
        [fontReduce mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(upChapter.mas_centerX);
            make.top.equalTo(upChapter.mas_bottom);
            make.width.equalTo(@44);
            make.height.equalTo(@44);
        }];
        
        
        UIButton *fontAdd = [[UIButton alloc] initWithTitle:@"A+" font:[UIFont systemFontOfSize:15] coclor:[UIColor whiteColor]];
        fontAdd.tag = SettingTypeFontAdd;
        [fontAdd addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fontAdd];
        [fontAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(nextChapter.mas_centerX);
            make.top.equalTo(nextChapter.mas_bottom);
            make.width.equalTo(@44);
            make.height.equalTo(@44);
        }];
        
        UIButton *lightStyle = [[UIButton alloc] init];
        lightStyle.tag = SettingTypeLightStyle;
        [lightStyle addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        lightStyle.backgroundColor = [UIColor whiteColor];
        lightStyle.layer.cornerRadius = 15.0f;
        [self addSubview:lightStyle];
        [lightStyle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(fontReduce.mas_centerX);
            make.top.equalTo(fontReduce.mas_bottom);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        UIButton *eyeStyle = [[UIButton alloc] init];
        eyeStyle.tag = SettingTypeEyeStyle;
        [eyeStyle addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        eyeStyle.backgroundColor = RGBA(159,223,176,1);
        eyeStyle.layer.cornerRadius = 15.0f;
        [self addSubview:eyeStyle];
        [eyeStyle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(fontReduce.mas_bottom);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        UIButton *blackStyle = [[UIButton alloc] init];
        blackStyle.tag = SettingTypeBlackStyle;
        [blackStyle addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        blackStyle.backgroundColor = [UIColor blackColor];
        blackStyle.layer.cornerRadius = 15.0f;
        [self addSubview:blackStyle];
        [blackStyle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(fontAdd.mas_centerX);
            make.top.equalTo(fontAdd.mas_bottom);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
    }
    return self;
}

- (void)didSettingOnClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hrDetailSettingWithSettingType:)]) {
        [self.delegate hrDetailSettingWithSettingType:btn.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
