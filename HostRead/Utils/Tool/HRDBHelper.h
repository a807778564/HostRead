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

- (NSInteger)instertTxtInfo:(NSString *)txtName floderName:(NSString *)floderName allChapter:(NSInteger)allChapter;

- (void)updateTxtAllChapter:(NSInteger)allChapter txtId:(NSInteger)textId;

- (HRTxtModel *)selectReadTxt:(NSString *)txtName;

- (void)updateSliderWitnTxtId:(NSString *)txtId readPage:(NSInteger)page readChapter:(NSInteger)chapter;

- (NSMutableArray *)selectAllTxtFileWithFloder:(NSString *)floderName;

- (BOOL)deleteTxtWithName:(NSString *)txtName;

#pragma mark
- (BOOL)insertChaptersIdx:(NSInteger)idx title:(NSString *)title content:(NSString *)content txtId:(NSString *)txtId;

- (HRTxtChapterModel *)selectChapterModelWithChapterCount:(NSInteger)chapterCount txtId:(NSString *)txtId;

- (NSMutableDictionary *)chapterTitleWithTxtId:(NSString *)txtId chaperIdx:(NSInteger)idx;

- (NSMutableArray *)selectAllChapter:(NSString *)txtId page:(NSInteger)page;
@end
