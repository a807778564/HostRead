//
//  UIImage+Color.h
//  ebook
//
//  Created by lj on 14-6-9.
//  Copyright (c) 2014年 cczone. All rights reserved.
//

#import <UIKit/UIImage.h>

@interface UIImage(Color)

+ (UIImage *)imageNamedWithoutNOSelectBlue:(NSString *)_name;

+(UIImage *)imageWithColor:(UIColor *)color Size:(CGSize)size Alpha:(CGFloat)alpha;

+(UIImage *)imageWithSize:(CGSize)size;

-(UIImage*)cutWithFrame:(CGRect)frame;

+(UIImage *)imageWithColor:(UIColor *)color;
@end
