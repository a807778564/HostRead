//
//  HRDBHelper.h
//  HostRead
//
//  Created by huangrensheng on 16/8/25.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HRTxtModel,HRTxtChapterModel;

@interface HRDBHelper : NSObject

- (BOOL)haveThisTxt:(NSString *)txtName;

- (NSInteger)instertTxtInfo:(NSString *)txtName allChapter:(NSInteger)allChapter;

- (HRTxtModel *)selectReadTxt:(NSString *)txtName;

- (void)updateSliderWitnTxtId:(NSString *)txtId readPage:(NSInteger)page readChapter:(NSInteger)chapter;

#pragma mark
- (void)insertChapters:(NSString *)title content:(NSString *)content txtId:(NSString *)txtId;

- (HRTxtChapterModel *)selectChapterModelWithChapterCount:(NSInteger)chapterCount txtId:(NSString *)txtId;

- (NSMutableArray *)selectAllChapter:(NSString *)txtId;
@end
