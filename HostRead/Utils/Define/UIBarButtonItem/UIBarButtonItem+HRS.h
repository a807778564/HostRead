//
//  UIBarButtonItem+HRS.h
//  hymn
//
//  Created by glory on 14/12/29.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HRS)

- (id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action;
+ (id)itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action;

- (id)initWithTitle:(NSString *)title size:(CGSize)size target:(id)target action:(SEL)action;
+ (id)itemWithTitle:(NSString *)title size:(CGSize)size target:(id)target action:(SEL)action;

- (id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted title:(NSString *)title size:(CGSize)size target:(id)target action:(SEL)action;
+ (id)itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted title:(NSString *)title size:(CGSize)size target:(id)target action:(SEL)action;
@end
