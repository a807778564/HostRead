//
//  HRDetailSettingView.h
//  HostRead
//
//  Created by huangrensheng on 16/8/29.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger){
    SettingTypeFontAdd = 10001,
    SettingTypeFontReduce = 10002,
    SettingTypeUpChapter = 10003,
    SettingTypeNextChapter = 10004,
    SettingTypeLightStyle = 10005,
    SettingTypeBlackStyle = 10006,
    SettingTypeEyeStyle = 10007
}SettingType;

@protocol HRDetailSettingViewDelegate <NSObject>

- (void)hrDetailSettingWithSettingType:(SettingType)settingType;

@end

@interface HRDetailSettingView : UIView

@property (nonatomic, assign) id<HRDetailSettingViewDelegate> delegate;

@end
