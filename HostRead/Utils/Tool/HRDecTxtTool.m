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
    NSArray *allFloder = [txtUrl.path componentsSeparatedByString:@"/"];
    NSString *floderName = allFloder[allFloder.count-2];
    if (![self.helper haveThisTxt:key]) {
        if ([[key pathExtension] isEqualToString:@"txt"]) {
            NSMutableArray *chapterArray = [[NSMutableArray alloc] init];
            [self separateChapter:&chapterArray content:[self encodeWithURL:txtUrl] txtName:key floderName:floderName];
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
//    content = [content stringByReplacingOccurrencesOfString:@"  " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"\n"];
    content = [content stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    return content;
    
}

-(void)separateChapter:(NSMutableArray **)chapters content:(NSString *)content txtName:(NSString *)txtName floderName:(NSString *)floderName
{
    [*chapters removeAllObjects];
    NSString *parten = @"第[0-9一二三四五六七八九十百千万]*[章回节卷].*";//@"[第]{0,1}[0-9一二三四五六七八九十百千万]+[章回节卷集幕计][ \t]*(\\S)*"
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray* match = [reg matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, [content length])];
    NSInteger txtId = [self.helper instertTxtInfo:txtName floderName:floderName allChapter:match.count];
    __block NSInteger allChapterCount = 0;//总的章节
    __block NSInteger txtIdx = 0;//当前章节索引
    if (match.count != 0)
    {
        __block NSRange lastRange = NSMakeRange(0, 0);
        [match enumerateObjectsUsingBlock:^(NSTextCheckingResult *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            NSRange range = [obj range];
            NSInteger local = range.location;
            if (idx == 0) {
                NSUInteger len = local;
                
                if ([self.helper insertChaptersIdx:txtIdx title:@"开始" content:[content substringWithRange:NSMakeRange(0, len)] txtId:[NSString stringWithFormat:@"%ld",txtId]]) {
                    txtIdx += 1;
                    allChapterCount += 1;
                }
            }
            if (idx > 0 ) {
                NSUInteger len = local-lastRange.location;
                if ([self.helper insertChaptersIdx:txtIdx title:[content substringWithRange:lastRange] content:[content substringWithRange:NSMakeRange(lastRange.location, len)] txtId:[NSString stringWithFormat:@"%ld",txtId]]){
                    txtIdx += 1;
                    allChapterCount += 1;
                }
                if (idx == 10) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HRDidLoadSome" object:[self.helper selectReadTxt:txtName] userInfo:nil];
                    NSLog(@"loading ten chapter success");
                }
            }
            if (idx == match.count-1) {
                if([self.helper insertChaptersIdx:txtIdx title:[content substringWithRange:range] content:[content substringWithRange:NSMakeRange(local, content.length-local)] txtId:[NSString stringWithFormat:@"%ld",txtId]]){
                    txtIdx += 1;
                    allChapterCount += 1;
                }
            }
            lastRange = range;
        }];
        [self.helper updateTxtAllChapter:allChapterCount txtId:txtId];
    }
    else{
        [self.helper insertChaptersIdx:txtIdx title:@"" content:content txtId:[NSString stringWithFormat:@"%ld",txtId]];
    }
}

@end
