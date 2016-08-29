//
//  UIImage+Color.m
//  ebook
//
//  Created by lj on 14-6-9.
//  Copyright (c) 2014年 cczone. All rights reserved.
//

#import "UIImage+Color.h"
#import "UIColor+ColorWithHex.h"
#import <UIKit/UIKit.h>

@implementation UIImage(Color)

// 去掉默认的选中蓝光
+ (UIImage *)imageNamedWithoutNOSelectBlue:(NSString *)_name{
    UIImage *image = [UIImage imageNamed:_name];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

+(UIImage *)imageWithColor:(UIColor *)color Size:(CGSize)size Alpha:(CGFloat)alpha
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    img = [self imageByApplyingAlpha:alpha image:img];
    return img;
}

//设置图片透明度
+(UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)imageWithSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for(int i = 0;i < size.width;i++)
    {
        rect = CGRectMake(i, 0, 1, size.height);
        CGContextSetFillColorWithColor(context, [UIColor randomColor].CGColor);
        CGContextFillRect(context, rect);
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(UIImage*)cutWithFrame:(CGRect)frame
{
    CGImageRef image = CGImageCreateWithImageInRect(self.CGImage, frame);
    return [UIImage imageWithCGImage:image];

//    UIGraphicsBeginImageContext(frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    CGContextScaleCTM(context, 1.0, -1.0);
//
//    CGContextDrawImage(context, CGRectMake(-frame.origin.x, frame.origin.y-self.size.height, self.size.width, self.size.height), [self CGImage]);
//    CGContextRestoreGState(context);
//    
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
}

+(UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
