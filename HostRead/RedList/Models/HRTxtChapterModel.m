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
    if (!content) {
        return;
    }
    _content = content;
    float fontSize = [[NSUserDefaults standardUserDefaults] floatForKey:@"FontSize"];
    NSMutableDictionary * attributes = [NSMutableDictionary dictionaryWithCapacity:fontSize];
    UIFont * font = [UIFont systemFontOfSize:fontSize];
    [attributes setValue:font forKey:NSFontAttributeName];
    [attributes setValue:@(6.0) forKey:NSKernAttributeName];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.paragraphSpacing = 10;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    self.attDic = attributes;
    NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.attDic];
    [[NSUserDefaults standardUserDefaults] setValue:personEncodedObject forKey:@"textStyle"];
//    [self paginationWithAttributes:attributes constrainedToSize:CGRectMake(0, 0, ScreenWidth-kLeftMargin-kRightMargin-10, ScreenHeight-58)];
    [self pagingwithContentString:_content contentSize:CGSizeMake(ScreenWidth-kLeftMargin-kRightMargin-10, ScreenHeight-58) textAttribute:attributes];
}

/**
 * @abstract 根据指定的大小,对字符串进行分页,计算出每页显示的字符串区间(NSRange)
 *
 * @param    attributes  分页所需的字符串样式,需要指定字体大小,行间距等。iOS6.0以上请参见UIKit中NSAttributedString的扩展,iOS6.0以下请参考CoreText中的CTStringAttributes.h
 * @param    size        需要参考的size。即在size区域内
 */
- (NSArray *) paginationWithAttributes:(NSMutableDictionary *) attributes constrainedToSize:(CGRect) rect  {
    NSMutableArray * resultRange = [NSMutableArray arrayWithCapacity:5];
//    CGRect rect = CGRectMake(kLeftMargin, kTopMargin, size.width, size.height);
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
        // NSLog(@"耗时 %lf", millionSecond);
    self.pageCount = resultRange.count;
    self.chapterRange = resultRange;
    return resultRange;
}

- (void)pagingwithContentString:(NSString *)contentString contentSize:(CGSize)contentSize textAttribute:(NSDictionary *)textAttribute{
    NSMutableArray *rangsArray = [[NSMutableArray alloc] init];
    NSRange *rangeOfPages;
    //按字体大小排版
    NSAttributedString *textString =  [[NSAttributedString alloc] initWithString:contentString attributes:textAttribute];
    int referTotalPages;
    int referCharatersPerPage;
    //计算出整个文本的尺寸
    CGRect totalTextSize = [textString boundingRectWithSize:CGSizeMake(contentSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    // 计算理想状态下的页面数量和每页所显示的字符数量，只是拿来作为参考值用而已！
    //总字符长度
    NSInteger textLength = contentString.length;
    //参考总页数
    referTotalPages = ((int)totalTextSize.size.height/(int)contentSize.height) + 1;
    //参考每页字符数
    referCharatersPerPage = (int)textLength/referTotalPages;
        
    // 申请最终保存页面NSRange信息的数组缓冲区
    int maxPages = referTotalPages;
    rangeOfPages = (NSRange *)malloc(referTotalPages*sizeof(NSRange));
    memset(rangeOfPages, 0x0, referTotalPages*sizeof(NSRange));
    // 页面索引
    int page = 0;
    NSRange range;
    range.length = referCharatersPerPage;
    for (NSUInteger location = 0; location < textLength; ){
        range.length = referCharatersPerPage+50;
        // 先计算临界点（尺寸刚刚超过UILabel尺寸时的文本串）
        range.location = location;
            
        // reach end of text ?
        NSString *pageText1;
            
        //最后一页设置
        if (range.location + range.length >= textLength){
            range.length = textLength - range.location;
        }

        int i = 0;
        // 然后一个个缩短字符串的长度，当缩短后的字符串尺寸小于textView的尺寸时即为满足
        while (range.length > 0 ){
            i++;
            pageText1 = [contentString substringWithRange:range];
            if ([[pageText1 substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"\n"] ||
                [[pageText1 substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"\r\n"]) {
                contentString = [contentString stringByReplacingCharactersInRange:NSMakeRange(range.location, 1) withString:@"."];
                _content = [_content stringByReplacingCharactersInRange:NSMakeRange(range.location, 1) withString:@"."];
                pageText1 = [contentString substringWithRange:range];
                range.location = range.location+1;
            }
            NSAttributedString *pageText =  [[NSAttributedString alloc] initWithString:pageText1 attributes:textAttribute];
            CGRect pageTextSize = [pageText boundingRectWithSize:CGSizeMake(contentSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                
            if (pageTextSize.size.height <= contentSize.height) {
                range.length = [pageText length];
                break;
            }else{
                range.length -= 1;
            }
        }
            // 得到一个页面的显示范围
        if (page >= maxPages){
            maxPages += 10;
            rangeOfPages = (NSRange *)realloc(rangeOfPages, maxPages*sizeof(NSRange));
        }
        rangeOfPages[page++] = range;
        NSLog(@"第%d页数 字符%ld", page,range.length);
        if (range.length > 0) {
            [rangsArray addObject:NSStringFromRange(range)];
        }
        // 更新游标
        location += range.length;
    }
    self.pageCount = rangsArray.count;
    self.chapterRange = rangsArray;
}


//TextKit 分页
//- (NSArray *)pagingwithContentString:(NSString *)contentString contentSize:(CGSize)contentSize textAttribute:(NSDictionary *)textAttribute {
//    NSMutableArray *pagingArray = [NSMutableArray array];
//    NSMutableAttributedString *orginAttString = [[NSMutableAttributedString alloc] initWithString:contentString attributes:textAttribute];
//    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:orginAttString];
//    NSLayoutManager* layoutManager = [[NSLayoutManager alloc] init];
//    [textStorage addLayoutManager:layoutManager];
//    while (YES) {
//        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:contentSize];
//        [layoutManager addTextContainer:textContainer];
//        NSRange rang = [layoutManager glyphRangeForTextContainer:textContainer];
//        if (rang.length <= 0) {
//            break;
//        }
//        NSString *str = [contentString substringWithRange:rang];
//        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:textAttribute];
//        [pagingArray addObject:attStr];
//    }
//    return pagingArray;
//}

- (NSString *)getTextWithPage:(NSInteger)page{
    NSRange range = NSRangeFromString(self.chapterRange[page]);
//    NSLog(@"[_chaContent substringWithRange:range] :%@",[_chaContent substringWithRange:range]);
    if (range.location+range.length>_content.length) {
        range = NSMakeRange(range.location, _content.length-range.location);
    }
    return [_content substringWithRange:range];
}

@end
