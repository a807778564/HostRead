//
//  HRReadTool.m
//  HostRead
//
//  Created by huangrensheng on 16/8/22.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRReadTool.h"

@implementation HRReadTool

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static HRReadTool *instance;
    dispatch_once(&onceToken, ^{
        instance = [[HRReadTool alloc] init];
    });
    return instance;
}

- (void)creatFileFolder:(NSString *)floderPath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:floderPath isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:floderPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        if(!bCreateDir){
            NSLog(@"创建文件夹失败！");
        }
        
        NSLog(@"创建文件夹成功，文件路径%@",floderPath);
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:floderPath]];
    }
}

- (void)removeItem:(NSString *)itemPath{
    NSFileManager* fileManager=[NSFileManager defaultManager];

    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:itemPath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:itemPath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}

- (void)getHostFileListWithPath:(NSString *)floderPath fileInfo:(HostFileList)hostFileList{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:floderPath error:&error];
    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
    for (NSString *fileName in fileList) {
        if ([[fileName pathExtension] isEqualToString:@"txt"]) {
            [fileArray addObject:fileName];
            [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",floderPath,fileName]]];
        }
        
    }
    //以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        NSString *path = [floderPath stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            [dirArray addObject:file];
            [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",floderPath,file]]];
        }
        isDir = NO;
    }
    hostFileList(dirArray,fileArray);
    
}

//移动文件位置
- (void)moveFileName:(NSString *)oldPath newPath:(NSString *)newPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = [fileManager moveItemAtPath:oldPath toPath:newPath error:nil];
    if (isSuccess) {
        NSLog(@"rename success");
    }else{
        NSLog(@"rename fail");
    }
}

//重命名
- (void)renameFileName:(NSString *)oldName newName:(NSString *)newName
{
    //通过移动该文件对文件重命名
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = [fileManager moveItemAtPath:oldName toPath:newName error:nil];
    if (isSuccess) {
        NSLog(@"rename success");
    }else{
        NSLog(@"rename fail");
    }
}


#pragma mark --增加忽略备份的文件的地址【解决iCloud同步问题】
-(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL*)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    NSError* error = nil;
    BOOL success= [URL setResourceValue:[NSNumber numberWithBool:YES]forKey:NSURLIsExcludedFromBackupKey error:&error];
    if(success)
    {
        NSLog(@"ERRorexcluding %@ from back %@",[URL lastPathComponent],error);
    }
    return success;
}


+(void)kwSaveImagePath:(NSString *)imageName image:(UIImage *)saveImage{
    
    NSString *path_sandox = NSHomeDirectory();//获取沙盒路径
    
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",imageName]];
    
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(saveImage) writeToFile:imagePath atomically:YES];
    
}


+ (UIImage *)kwGetImageWith:(NSString *)imageName{
    
    UIImage *getImage = nil;
    
    NSString *path_sandox = NSHomeDirectory();//获取沙盒路径
    //获取图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",imageName]];
    
    getImage = [[UIImage alloc] initWithContentsOfFile:imagePath];//得到图片对象
    
    if (getImage == nil) {
        NSLog(@"获取图片失败");
    }
    return getImage;
}

/**
 *  计算文本高度
 *
 *  @param text       文本内容
 *  @param number     行数
 *  @param width      文本宽度
 *  @param heightLine 行间距
 *  @param headerLine 首行缩进多少
 *  @param labelInfo  返回处理好的信息
 */
+(void)getSizeWithText:(NSString *)text labelInfo:(labelSizeAndTextBlk)labelInfo{
    
    if (text == nil) {
        text = @"暂无简介";
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:[[NSUserDefaults standardUserDefaults] floatForKey:@"FontSize"]];
    
    //UILabel设置行间距等属性：
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:label.text];;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setLineSpacing:5];//行间距
    [paragraphStyle setFirstLineHeadIndent:0];//首行缩进
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
    
    label.attributedText = attributedString;
    
    //宽度不变，根据字的多少计算label的高度
    labelInfo([label sizeThatFits:CGSizeMake(ScreenWidth-kLeftMargin-kRightMargin, MAXFLOAT)],attributedString);
}

@end
