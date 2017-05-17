//
//  HRSettingColorCell.h
//  HostRead
//
//  Created by huangrensheng on 2017/5/17.
//  Copyright © 2017年 kawaii. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChangeColor)(UIColor *color);
@interface HRSettingColorCell : UITableViewCell
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSString *colorType;
@property (nonatomic, copy) ChangeColor chColor;
@end
