//
//  HRReadTool.h
//  HostRead
//
//  Created by huangrensheng on 16/8/22.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^labelSizeAndTextBlk)(CGSize size , NSAttributedString *text);
/**
 *  获取数据的block
 *
 *  @param floderList 文件夹列表
 *  @param fileList   文件列表
 */
typedef void(^HostFileList)(NSMutableArray *floderList, NSMutableArray *fileList);

@interface HRReadTool : NSObject

+ (instancetype)shareInstance;

- (void)creatFileFolder:(NSString *)floderPath;

- (void)removeItem:(NSString *)itemPath;

- (void)getHostFileListWithPath:(NSString *)floderPath fileInfo:(HostFileList)hostFileList;

- (void)moveFileName:(NSString *)oldPath newPath:(NSString *)newPath;

- (void)renameFileName:(NSString *)oldName newName:(NSString *)newName;

+(void)getSizeWithText:(NSString *)text labelInfo:(labelSizeAndTextBlk)labelInfo;
@end
