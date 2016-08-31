//
//  HRReadDetailView.h
//  HostRead
//
//  Created by huangrensheng on 16/8/26.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRReadDetailView : UIView

- (void)updateContent:(NSString *)content title:(NSString *)title page:(NSString *)page;

- (void)changeReadModel:(UIColor *)backColor contentColor:(UIColor *)contentColor;

@property (nonatomic, strong) UITextView *contect;

@end
