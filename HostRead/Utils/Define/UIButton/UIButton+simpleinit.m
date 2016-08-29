//
//  UIButton+simpleinit.m
//  ebook
//
//  Created by lj on 14-6-18.
//  Copyright (c) 2014年 cczone. All rights reserved.
//

#import "UIButton+simpleinit.h"
#import "UIColor+ColorWithHex.h"
#import "UIImage+Color.h"

@implementation UIButton (simpleinit)

+(UIButton *)buttonWithFrame:(CGRect)frame Font:(UIFont *)font TextColor:(UIColor *)textColor Text:(NSString *)text
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    button.titleLabel.font = font;
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    return button;
}

-(id)initWithFrame:(CGRect)frame Image:(NSString *)image SelectedImage:(NSString *)selectedImage
{
    if(self = [self initWithFrame:frame])
    {
        [self setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        if(selectedImage)
            [self setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame Image:(NSString *)image HighlightedImage:(NSString *)HighlightedImage
{
    if(self = [self initWithFrame:frame])
    {
        [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        if(HighlightedImage)
            [self setImage:[UIImage imageNamed:HighlightedImage] forState:UIControlStateHighlighted];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame Image:(NSString *)image SelectedImage:(NSString *)selectedImage Target:(id)target Action:(SEL)action
{
    if(self = [self initWithFrame:frame])
    {
        [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        if(selectedImage)
            [self setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title titleFont:(UIFont *)font backNormal:(UIColor *)normalColor backHighlig:(UIColor *)highColor{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:normalColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:highColor] forState:UIControlStateHighlighted];
    return button;
}

-(void)setImage:(NSString *)image selectedImage:(NSString *)selectedImage
{
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    if(selectedImage)
        [self setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
}

/**
 *  获取一个圆角按钮
 *
 *  @param text 按钮内容
 *
 *  @return 返回按钮
 */
+(UIButton *)getButtonWithText:(NSString *)text{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateSelected];
//    [btn setTitleColor:LINE_COLOR forState:UIControlStateNormal];
//    [btn setTitleColor:BAR_COLOR forState:UIControlStateSelected];
    [btn.layer setBorderWidth:1.0];//设置边框宽度
    [btn.layer setCornerRadius:4.0]; //设置矩圆角半径
    return btn;
}

- (UIButton *)initWithTitle:(NSString *)title font:(UIFont *)font coclor:(UIColor *)color{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn.titleLabel setFont:font];
    [btn setBackgroundImage:[UIImage imageNamed:@"reigster_btn"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"reigster_btn_select"] forState:UIControlStateHighlighted];
//    [btn.layer setBorderWidth:1.0];//设置边框宽度
//    [btn.layer setCornerRadius:5.0]; //设置矩圆角半径
//    [];
    return btn;
}

-(id)initWithIcon:(NSString *)icon title:(NSString *)title textClolor:(UIColor *)textColor textFont:(CGFloat)font{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:font]];
    return btn;
}


- (void)setLayerCornerRadius:(CGFloat)radius borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth{
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderColor:color.CGColor];
    [self.layer setBorderWidth:borderWidth];
    [self.layer setCornerRadius:radius];
}
@end
