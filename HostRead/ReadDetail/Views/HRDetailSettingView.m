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
        
        UIButton *upChapter = [[UIButton alloc] initWithTitle:@"上一章" font:[UIFont systemFontOfSize:15] coclor:[UIColor grayColor]];
        upChapter.backgroundColor = RGBA(245, 245, 245, 1);
        upChapter.layer.cornerRadius = 4;
        upChapter.tag = SettingTypeUpChapter;
        [upChapter addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:upChapter];
        [upChapter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(15);
            make.top.equalTo(self.mas_top).offset(15);
            make.height.equalTo(@35);
            make.width.equalTo(@65);
        }];
        
        UIButton *nextChapter = [[UIButton alloc] initWithTitle:@"下一章" font:[UIFont systemFontOfSize:15] coclor:[UIColor grayColor]];
        nextChapter.backgroundColor = RGBA(245, 245, 245, 1);
        nextChapter.layer.cornerRadius = 4;
        nextChapter.tag = SettingTypeNextChapter;
        [nextChapter addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextChapter];
        [nextChapter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing).offset(-15);
            make.top.equalTo(self.mas_top).offset(15);
            make.height.equalTo(@35);
            make.width.equalTo(@65);
        }];
        
        UIButton *fontReduce = [[UIButton alloc] initWithTitle:@"A-" font:[UIFont systemFontOfSize:15] coclor:[UIColor grayColor]];
        fontReduce.backgroundColor = RGBA(245, 245, 245, 1);
        fontReduce.layer.cornerRadius = 17.5f;
        fontReduce.tag = SettingTypeFontReduce;
        [fontReduce addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fontReduce];
        [fontReduce mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(upChapter.mas_centerX);
            make.top.equalTo(upChapter.mas_bottom).offset(15);
            make.width.equalTo(@35);
            make.height.equalTo(@35);
        }];
        
        
        UIButton *fontAdd = [[UIButton alloc] initWithTitle:@"A+" font:[UIFont systemFontOfSize:15] coclor:[UIColor grayColor]];
        fontAdd.tag = SettingTypeFontAdd;
        fontAdd.backgroundColor = RGBA(245, 245, 245, 1);
        fontAdd.layer.cornerRadius = 17.5f;
        [fontAdd addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fontAdd];
        [fontAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(nextChapter.mas_centerX);
            make.top.equalTo(nextChapter.mas_bottom).offset(15);
            make.width.equalTo(@35);
            make.height.equalTo(@35);
        }];
        
        CGFloat styleMagrin = (ScreenWidth-(30*4))/5;//间距
        
        UIButton *lightStyle = [[UIButton alloc] initWithTitle:@"字" font:[UIFont systemFontOfSize:15] coclor:[UIColor blackColor]];
        lightStyle.tag = SettingTypeLightStyle;
        [lightStyle addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        lightStyle.backgroundColor = RGBA(239, 239, 239, 1);
        lightStyle.layer.cornerRadius = 15.0f;
        [self addSubview:lightStyle];
        [lightStyle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(fontReduce.mas_centerX);
            make.leading.equalTo(self.mas_leading).offset(styleMagrin);
            make.top.equalTo(fontReduce.mas_bottom).offset(15);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        UIButton *eyeStyle = [[UIButton alloc] initWithTitle:@"字" font:[UIFont systemFontOfSize:15] coclor:[UIColor blackColor]];
        eyeStyle.tag = SettingTypeEyeStyle;
        [eyeStyle addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        eyeStyle.backgroundColor = RGBA(159,223,176,1);
        eyeStyle.layer.cornerRadius = 15.0f;
        [self addSubview:eyeStyle];
        [eyeStyle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.mas_centerX);
            make.leading.equalTo(lightStyle.mas_trailing).offset(styleMagrin);
            make.top.equalTo(lightStyle.mas_top);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        UIButton *blackStyle = [[UIButton alloc] initWithTitle:@"字" font:[UIFont systemFontOfSize:15] coclor:[UIColor whiteColor]];
        blackStyle.tag = SettingTypeBlackStyle;
        [blackStyle addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        blackStyle.backgroundColor = [UIColor blackColor];
        blackStyle.layer.cornerRadius = 15.0f;
        [self addSubview:blackStyle];
        [blackStyle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(fontAdd.mas_centerX);
            make.leading.equalTo(eyeStyle.mas_trailing).offset(styleMagrin);
            make.top.equalTo(lightStyle.mas_top);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        UIButton *yellowStyle = [[UIButton alloc] initWithTitle:@"字" font:[UIFont systemFontOfSize:15] coclor:[UIColor blackColor]];
        yellowStyle.tag = SettingTypeYellowStyle;
        [yellowStyle addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        yellowStyle.backgroundColor = [UIColor colorWithHexa:@"#9e902a"];
        yellowStyle.layer.cornerRadius = 15.0f;
        [self addSubview:yellowStyle];
        [yellowStyle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(fontAdd.mas_centerX);
            make.leading.equalTo(blackStyle.mas_trailing).offset(styleMagrin);
            make.top.equalTo(lightStyle.mas_top);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        UIButton *graySetting = [[UIButton alloc] initWithTitle:@"高级\n设置" font:[UIFont systemFontOfSize:15] coclor:[UIColor grayColor]];
        graySetting.tag = SettingTypeGraSetting;
        [graySetting addTarget:self action:@selector(didSettingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        graySetting.titleLabel.numberOfLines = 2;
        graySetting.backgroundColor = RGBA(245, 245, 245, 1);
        graySetting.layer.cornerRadius = 25.0f;
        [self addSubview:graySetting];
        [graySetting mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
//            make.centerY.equalTo(self.mas_centerY);
            make.top.offset(32);
            make.width.offset(50);
            make.height.offset(50);
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
