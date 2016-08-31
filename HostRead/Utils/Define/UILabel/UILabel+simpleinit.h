//
//  UILabel+simpleinit.h
//  ebook
//
//  Created by lj on 14-6-12.
//  Copyright (c) 2014年 cczone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (simpleinit)

-(id)initWithFrame:(CGRect)frame Font:(UIFont *)font TextColor:(UIColor *)textColor Text:(NSString *)text;

-(id)initAttributeWithFrame:(CGRect)frame Font:(UIFont *)font TextColor:(UIColor *)textColor Text:(NSString *)text;
-(id)initWithFont:(UIFont *)font TextColor:(UIColor *)textColor Text:(NSString *)text;
+ (void) alignLabelWithTop:(UILabel *)label;
@end
