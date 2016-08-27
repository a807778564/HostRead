//
//  HRReadDetailView.h
//  HostRead
//
//  Created by huangrensheng on 16/8/26.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger){
    HReeadSettingBack = 1001,//返回
    HReeadSettingFontAdd = 1002,//字体加
    HReeadSettingFontJun = 1003,//字体减
    HReeadSettingList = 1004//返回
}HReeadSettingType;

@protocol HRReadDetailViewDelegate <NSObject>

- (void)HRReadDetailViewDidSetting:(HReeadSettingType)settingType;

@end

@interface HRReadDetailView : UIView

@property (nonatomic, assign) id<HRReadDetailViewDelegate> delegate;

- (void)updateContent:(NSString *)content title:(NSString *)title page:(NSString *)page;

@end
