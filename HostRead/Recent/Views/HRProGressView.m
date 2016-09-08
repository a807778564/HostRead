//
//  HRProGressView.m
//  HostRead
//
//  Created by huangrensheng on 16/9/8.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRProGressView.h"

@implementation HRProGressView

- (instancetype)init{
    if ([super init]) {
        self.backgroundColor = RGBA(111, 111, 111, 1);
    }
    return self;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();//获取一个画布,可以绘制任意图形
    /*已审核*/
    CGContextSetLineWidth(context, 5.0);//线的宽度
    CGContextSetRGBStrokeColor(context, 1/255.0f, 188/255.0f, 156/255.0f, 1);//改变画笔颜色
    double aa = _progress*360;
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, 30, (-90)*M_PI/180, (aa-90)*M_PI/180, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
}

@end
