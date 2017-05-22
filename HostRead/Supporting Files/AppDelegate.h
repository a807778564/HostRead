//
//  AppDelegate.h
//  HostRead
//
//  Created by huangrensheng on 16/8/22.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedDelegate;

- (void)showLoadingHUD:(NSString *)msg;

- (void)showTextOnly:(NSString *)msg;

- (NSMutableDictionary *)colorDic;

- (UIViewController *)getPresentedViewController;

- (void)hidHUD;
@end

