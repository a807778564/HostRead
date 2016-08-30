//
//  HRDetailSettingView.h
//  HostRead
//
//  Created by huangrensheng on 16/8/29.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger){
    SettingTypeFontAdd = 10001,//字体加
    SettingTypeFontReduce = 10002,//字体减
    SettingTypeUpChapter = 10003,//上一章
    SettingTypeNextChapter = 10004,//下一章
    SettingTypeLightStyle = 10005,//白天模式
    SettingTypeBlackStyle = 10006,//夜晚模式
    SettingTypeYellowStyle = 10009,//淡黄色模式
    SettingTypeEyeStyle = 10007,//护眼模式
    SettingTypeGraSetting = 10008//高级设置
}SettingType;

@protocol HRDetailSettingViewDelegate <NSObject>

- (void)hrDetailSettingWithSettingType:(SettingType)settingType;

@end

@interface HRDetailSettingView : UIView

@property (nonatomic, assign) id<HRDetailSettingViewDelegate> delegate;

@end
