//
//  UIButton+simpleinit.h
//  ebook
//
//  Created by lj on 14-6-18.
//  Copyright (c) 2014年 cczone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (simpleinit)

+(UIButton *)buttonWithFrame:(CGRect)frame Font:(UIFont *)font TextColor:(UIColor *)textColor Text:(NSString *)text;
-(id)initWithFrame:(CGRect)frame Image:(NSString *)image SelectedImage:(NSString *)selectedImage Target:(id)target Action:(SEL)action;
-(id)initWithFrame:(CGRect)frame Image:(NSString *)image HighlightedImage:(NSString *)HighlightedImage;
-(id)initWithFrame:(CGRect)frame Image:(NSString *)image SelectedImage:(NSString *)selectedImage;
-(void)setImage:(NSString *)image selectedImage:(NSString *)selectedImage;
+(UIButton *)getButtonWithText:(NSString *)text;
- (id)initWithTitle:(NSString *)title titleFont:(UIFont *)font backNormal:(UIColor *)normalColor backHighlig:(UIColor *)highColor;
- (UIButton *)initWithTitle:(NSString *)title font:(UIFont *)font coclor:(UIColor *)color;
-(id)initWithIcon:(NSString *)icon title:(NSString *)title textClolor:(UIColor *)textColor textFont:(CGFloat)font;
- (void)setLayerCornerRadius:(CGFloat)radius borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;
@end
