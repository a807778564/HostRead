//
//  HRDecTxtTool.m
//  HostRead
//
//  Created by huangrensheng on 16/8/25.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRDecTxtTool.h"
#import "HRDBHelper.h"
#import "HRTxtModel.h"

@interface HRDecTxtTool()

@property (nonatomic, strong) HRDBHelper *helper;

@end

@implementation HRDecTxtTool

- (HRTxtModel *)decoWithUrl:(NSURL *)txtUrl{
    self.helper = [[HRDBHelper alloc] init];
    NSString *key = [txtUrl.path lastPathComponent];
    
    if (![self.helper haveThisTxt:key]) {
        if ([[key pathExtension] isEqualToString:@"txt"]) {
            NSMutableArray *chapterArray = [[NSMutableArray alloc] init];
            [self separateChapter:&chapterArray content:[self encodeWithURL:txtUrl] txtName:key];
            return [self.helper selectReadTxt:key];
        }else{
            @throw [NSException exceptionWithName:@"FileException" reason:@"文件格式错误" userInfo:nil];
        }
    }

    return [self.helper selectReadTxt:key];
}

-(NSString *)encodeWithURL:(NSURL *)url
{
    if (!url) {
        return @"";
    }
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (!content) {
        content = [NSString stringWithContentsOfURL:url encoding:0x80000632 error:nil];
    }
    if (!content) {
        content = [NSString stringWithContentsOfURL:url encoding:0x80000631 error:nil];
    }
    if (!content) {
        return @"";
    }
    return content;
    
}

-(void)separateChapter:(NSMutableArray **)chapters content:(NSString *)content txtName:(NSString *)txtName
{
    [*chapters removeAllObjects];
    NSString *parten = @"第[0-9一二三四五六七八九十百千]*[章回].*";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray* match = [reg matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, [content length])];
    NSInteger txtId = [self.helper instertTxtInfo:txtName allChapter:match.count];
    if (match.count != 0)
    {
        __block NSRange lastRange = NSMakeRange(0, 0);
        [match enumerateObjectsUsingBlock:^(NSTextCheckingResult *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [obj range];
            NSInteger local = range.location;
            if (idx == 0) {
                NSUInteger len = local;
                [self.helper insertChapters:@"开始" content:[content substringWithRange:NSMakeRange(0, len)] txtId:[NSString stringWithFormat:@"%ld",txtId]];
            }
            if (idx > 0 ) {
                NSUInteger len = local-lastRange.location;
                [self.helper insertChapters:[content substringWithRange:lastRange] content:[content substringWithRange:NSMakeRange(lastRange.location, len)] txtId:[NSString stringWithFormat:@"%ld",txtId]];
            }
            if (idx == match.count-1) {
                [self.helper insertChapters:[content substringWithRange:range] content:[content substringWithRange:NSMakeRange(local, content.length-local)] txtId:[NSString stringWithFormat:@"%ld",txtId]];
            }
            lastRange = range;
        }];
    }
    else{
        [self.helper insertChapters:@"" content:content txtId:[NSString stringWithFormat:@"%ld",txtId]];
    }
}

@end
