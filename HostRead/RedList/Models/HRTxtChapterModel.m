//
//  HRTxtChapterModel.m
//  HostRead
//
//  Created by huangrensheng on 16/8/24.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRTxtChapterModel.h"
#import <CoreText/CoreText.h>

@interface HRTxtChapterModel()

@property (nonatomic, strong) NSMutableArray *chapterRange;

@end

@implementation HRTxtChapterModel

- (void)setContent:(NSString *)content{
    _content = content;
    NSMutableDictionary * attributes = [NSMutableDictionary dictionaryWithCapacity:5];
    UIFont * font = [UIFont fontWithName:@"Arial" size:14];
    [attributes setValue:font forKey:NSFontAttributeName];
    [attributes setValue:@(2.0) forKey:NSKernAttributeName];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 1.0;
    [attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self paginationWithAttributes:attributes constrainedToSize:CGSizeMake(ScreenWidth-kLeftMargin-kRightMargin, ScreenHeight-kTopMargin-kBottonMargin)];
}

/**
 * @abstract 根据指定的大小,对字符串进行分页,计算出每页显示的字符串区间(NSRange)
 *
 * @param    attributes  分页所需的字符串样式,需要指定字体大小,行间距等。iOS6.0以上请参见UIKit中NSAttributedString的扩展,iOS6.0以下请参考CoreText中的CTStringAttributes.h
 * @param    size        需要参考的size。即在size区域内
 */
- (NSArray *) paginationWithAttributes:(NSDictionary *) attributes constrainedToSize:(CGSize) size  {
    NSMutableArray * resultRange = [NSMutableArray arrayWithCapacity:5];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // 构造NSAttributedString
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:_content attributes:attributes];
    //    以下方法耗时 基本再 0.5s 以内
    //    NSDate * date = [NSDate date];
    NSInteger rangeIndex = 0;
    do {
        NSInteger length = MIN(500, attributedString.length - rangeIndex);
        NSAttributedString * childString = [attributedString attributedSubstringFromRange:NSMakeRange(rangeIndex, length)];
        CTFramesetterRef childFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) childString);
        UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:rect];
        CTFrameRef frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, 0), bezierPath.CGPath, NULL);
        
        CFRange range = CTFrameGetVisibleStringRange(frame);
        NSRange r = {rangeIndex, range.length};
        if (r.length > 0) {
            [resultRange addObject:NSStringFromRange(r)];
        }
        rangeIndex += r.length;
        CFRelease(frame);
        CFRelease(childFramesetter);
    } while (rangeIndex < attributedString.length && attributedString.length > 0);
    //    NSTimeInterval millionSecond = [[NSDate date] timeIntervalSinceDate:date];
    //    // NSLog(@"耗时 %lf", millionSecond);
    self.pageCount = resultRange.count;
    self.chapterRange = resultRange;
    return resultRange;
}

- (NSString *)getTextWithPage:(NSInteger)page{
    NSRange range = NSRangeFromString(self.chapterRange[page]);
//    NSLog(@"[_chaContent substringWithRange:range] :%@",[_chaContent substringWithRange:range]);
    return [_content substringWithRange:range];
}

@end
