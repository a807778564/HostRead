//
//  HRBatteryView.h
//  HostRead
//
//  Created by huangrensheng on 16/8/26.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRBatteryView : UIView

@property (nonatomic, assign) float batteryLevel;

- (void)updateColor:(UIColor *)color;

@end
