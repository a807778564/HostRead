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
    }else{
        [[AppDelegate sharedDelegate] showTextOnly:@"文件夹已经存在"];
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

#pragma mark - 清除path文件夹
- (BOOL)clearAllWithFilePath:(NSString *)path{
    
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSString *filePath = nil;
    
    NSError *error = nil;
    
    for (NSString *subPath in subPathArr)
    {
        filePath = [path stringByAppendingPathComponent:subPath];
        NSArray *allFloder = [filePath componentsSeparatedByString:@"/"];
        NSString *floderName = allFloder[allFloder.count-1];
        if ([floderName hasSuffix:@".db"]) {
            
        }else{
            if ([floderName hasSuffix:@".txt"]) {
                
            }
//            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        }
        NSLog(@"delete patb = %@",filePath);
//        [self.helper deleteTxtWithName:self.fileList[indexPath.row-self.floderList.count]];
        //删除子文件夹
        
        if (error) {
            return NO;
        }
    }
    return YES;
}

//不论是创建还是写入只需调用此段代码即可 如果文件未创建 会进行创建操作
- (void)writeToFileWithTxt:(NSString *)string{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @synchronized (self) {
            //获取沙盒路径
            NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            //获取文件路径
            NSString *theFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"测试文本.txt"];
            //创建文件管理器
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //如果文件不存在 创建文件
            if(![fileManager fileExistsAtPath:theFilePath]){
                NSString *str = @"";
                [str writeToFile:theFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
            NSLog(@"所写内容=%@",string);
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:theFilePath];
            [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
            NSData* stringData  = [[NSString stringWithFormat:@"%@\n",string] dataUsingEncoding:NSUTF8StringEncoding];
            [fileHandle writeData:stringData]; //追加写入数据
            [fileHandle closeFile];
        }
    });
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
