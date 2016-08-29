//
//  UIBarButtonItem+HRS.m
//  hymn
//
//  Created by glory on 14/12/29.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "UIBarButtonItem+HRS.h"

@implementation UIBarButtonItem (HRS)

- (id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action
{

    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置普通背景图片
    UIImage *image = [UIImage imageNamed:icon];
    
//    NSLog(@"width------ %f",image.size.width);
//    NSLog(@"height----- %f",image.size.height);

    
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    
    // 设置高亮图片
    [btn setBackgroundImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    
    
    
    
    // 设置尺寸
    btn.bounds = (CGRect){CGPointZero, CGSizeMake(image.size.width, image.size.height)};
    
    //NSLog(@"btn.frame %@",NSStringFromCGRect(btn.frame));

    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:btn];
}

+ (id)itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action
{
    return [[self alloc] initWithIcon:icon highlightedIcon:highlighted target:target action:action];
}


- (id)initWithTitle:(NSString *)title size:(CGSize)size target:(id)target action:(SEL)action
{
    
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置文字
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    // 设置尺寸
    btn.bounds = (CGRect){CGPointZero, size};
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:btn];
}

+ (id)itemWithTitle:(NSString *)title size:(CGSize)size target:(id)target action:(SEL)action
{
    return [[self alloc] initWithTitle:title size:(CGSize)size  target:target action:action];
}

/**
 *  返回一个文字图片都存在的导航按钮
 *
 *  @param icon        普通状态下的图片
 *  @param highlighted 高亮下的状态
 *  @param title       文字
 *  @param size        大小
 *  @param target
 *  @param action      绑定的方法
 *
 *  @return
 */
-(id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted title:(NSString *)title size:(CGSize)size target:(id)target action:(SEL)action{
    
    // 设置普通背景图片
    UIImage *image = [UIImage imageNamed:icon];
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    // 设置文字
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    // 设置尺寸
    btn.bounds = (CGRect){CGPointZero, size};
;
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [btn setAdjustsImageWhenHighlighted:NO];//取消按钮高亮变灰的效果

    return [self initWithCustomView:btn];

}

+(id)itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted title:(NSString *)title size:(CGSize)size target:(id)target action:(SEL)action{
    return [[self alloc] initWithIcon:icon highlightedIcon:highlighted title:title size:size target:target action:action];
}

@end
