//
//  HRDBHelper.m
//  HostRead
//
//  Created by huangrensheng on 16/8/25.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRDBHelper.h"
#import "HRTxtModel.h"
#import "HRTxtChapterModel.h"

@implementation HRDBHelper

//初始化数据库表
-(instancetype)init{
    
    if ([super init]) {
        FMDatabase *db = [self getBase];
        if ([db open]) {
            //如果数据库没有城市信息的表格  新建一个
            NSString *createSearchHistory = @"CREATE TABLE IF NOT EXISTS 'table_txt' ('txtId' INTEGER PRIMARY KEY AUTOINCREMENT, 'txtName' VARCHAR NOT NULL, 'floderName' VARCHAR NOT NULL, 'redPage' VARCHAR NOT NULL , 'readChapter' VARCHAR NOT NULL, 'allChapter' INTEGER )";
            [db executeUpdate:createSearchHistory];
            //新建本地兑换单数据表格
            NSString *createIntallMallList = @"CREATE TABLE IF NOT EXISTS 'table_chapters' ('chapterid' INTEGER PRIMARY KEY AUTOINCREMENT, idx INTEGER, 'title' VARCHAR NOT NULL, 'content' VARCHAR NOT NULL,'txtId' INTEGER,FOREIGN KEY(txtId) REFERENCES table_txt(txtId))";
            [db executeUpdate:createIntallMallList];
        }
    }
    return self;
}

/**
 *  获取数据库地址
 *
 *  @return 数据库地址
 */
-(NSString *)getDBPath
{
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSLog(@"dbPath : %@",dbPath);
    NSString *DBPath = [dbPath stringByAppendingPathComponent:@"HostRrad.db"];//成员列表数据库
    return DBPath;
}

/**
 *  获取数据库
 *
 *  @return 数据库
 */
-(FMDatabase *)getBase{
    
    NSString *dbPath = [self getDBPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    return db;
}

#pragma mark table_txt 文件操作
- (NSInteger)instertTxtInfo:(NSString *)txtName floderName:(NSString *)floderName allChapter:(NSInteger)allChapter{
    FMResultSet *result = [[FMResultSet alloc] init];
    FMDatabase *db = [self getBase];
    NSInteger insetId = 0;
    if ([db open]) {
        BOOL insert = [db executeUpdate:@"insert into table_txt(txtName,floderName,redPage,readChapter,allChapter)values(?,?,'0','0',?)",txtName,floderName,[NSNumber numberWithInteger:allChapter]];
        if (insert) {
            result = [db executeQuery:@"select last_insert_rowid() from table_txt"];
            if ([result next]) {
                insetId = [result intForColumnIndex:0];
            }
        }
    }
    [db close];
    return insetId;
}

- (BOOL)haveThisTxt:(NSString *)txtName{
    BOOL ishave = false;
    FMResultSet *result = [[FMResultSet alloc] init];
    FMDatabase *db = [self getBase];
    if ([db open]) {
        result = [db executeQuery:@"select * from table_txt where txtName=?",txtName];
        if ([result next]) {
            
            NSLog(@"txtName %@",[result stringForColumnIndex:0]);
            
            ishave = true;
        }
    }
    return ishave;
}

- (HRTxtModel *)selectReadTxt:(NSString *)txtName{
    HRTxtModel *txt = [[HRTxtModel alloc] init];
    FMResultSet *result = [[FMResultSet alloc] init];
    FMDatabase *db = [self getBase];
    if ([db open]) {
        result = [db executeQuery:@"select txtId,txtName,floderName,redPage,readChapter,allChapter from table_txt where txtName=?",txtName];
        if ([result next]) {
            txt.txtId = [result stringForColumn:@"txtId"];
            txt.txtName = [result stringForColumn:@"txtName"];
            txt.redPage = [result stringForColumn:@"redPage"];
            txt.readChapter = [result stringForColumn:@"readChapter"];
            txt.allChapter = [result stringForColumn:@"allChapter"];
            txt.floderName = [result stringForColumn:@"floderName"];
        }
    }
    [db close];
    return txt;
}

- (void)updateSliderWitnTxtId:(NSString *)txtId readPage:(NSInteger)page readChapter:(NSInteger)chapter{
    FMDatabase *db =[self getBase];
    if ([db open]) {
       [db executeUpdate:@"update table_txt set redPage=?, readChapter=? where txtId=?",[NSNumber numberWithInteger:page],[NSNumber numberWithInteger:chapter],txtId];
    }
    [db close];
}

- (NSMutableArray *)selectAllTxtFileWithFloder:(NSString *)floderName{
    NSMutableArray *txtArray = [[NSMutableArray alloc] init];
    FMResultSet *result = [[FMResultSet alloc] init];
    FMDatabase *db = [self getBase];
    if ([db open]) {
        result = [db executeQuery:@"select txtId,txtName,floderName,redPage,readChapter,allChapter from table_txt where floderName=?",floderName];
        if ([result next]) {
            HRTxtModel *txt = [[HRTxtModel alloc] init];
            txt.txtId = [result stringForColumn:@"txtId"];
            txt.txtName = [result stringForColumn:@"txtName"];
            txt.redPage = [result stringForColumn:@"redPage"];
            txt.readChapter = [result stringForColumn:@"readChapter"];
            txt.allChapter = [result stringForColumn:@"allChapter"];
            txt.floderName = [result stringForColumn:@"floderName"];
            [txtArray addObject:txt];
        }
    }
    [db close];
    return txtArray;
}

- (BOOL)deleteTxtWithName:(NSString *)txtName{
    BOOL delete = false;
    HRTxtModel *model = [self selectReadTxt:txtName];
    FMDatabase *db = [self getBase];
    if ([db open]) {
        BOOL isDeletx = [db executeUpdate:@"delete from table_chapters where txtId=?",model.txtId];
        if (isDeletx) {
            delete = [db executeUpdate:@"delete from table_txt where txtId=?",model.txtId];
        }
    }
    [db close];
    return delete;
}

#pragma mark table_chapters操作
- (void)insertChaptersIdx:(NSInteger)idx title:(NSString *)title content:(NSString *)content txtId:(NSString *)txtId{
    FMDatabase *db = [self getBase];
    if ([db open]) {
        BOOL insert = [db executeUpdate:@"insert into table_chapters(idx,title,content,txtId)values(?,?,?,?)",[NSNumber numberWithInteger:idx],title,content,[NSNumber numberWithInteger:[txtId integerValue]]];
        if (insert) {
            NSLog(@"success");
        }
    }
    [db close];
}

- (HRTxtChapterModel *)selectChapterModelWithChapterCount:(NSInteger)chapterCount txtId:(NSString *)txtId{
    HRTxtChapterModel *chapter = [[HRTxtChapterModel alloc] init];
    FMResultSet *result = [[FMResultSet alloc] init];
    FMDatabase *db = [self getBase];
    if ([db open]) {
        result = [db executeQuery:@"select title,content from table_chapters where idx=? and txtId=?",[NSNumber numberWithInteger:chapterCount],txtId];
        if ([result next]) {
            chapter.title = [result stringForColumn:@"title"];
            chapter.content = [result stringForColumn:@"content"];
        }
    }
    [db close];
    return chapter;
}

- (NSMutableDictionary *)chapterTitleWithTxtId:(NSString *)txtId chaperIdx:(NSInteger)idx{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    FMResultSet *result = [[FMResultSet alloc] init];
    FMDatabase *db = [self getBase];
    if ([db open]) {
        result = [db executeQuery:@"select chapterid,title from table_chapters where txtId=? and idx=?",txtId,[NSNumber numberWithInteger:idx]];
        if ([result next]) {
            [dic setValue:[result stringForColumn:@"chapterid"] forKey:@"chapterid"];
            [dic setValue:[result stringForColumn:@"title"] forKey:@"title"];
        }
    }
    [db close];
    return dic;
}

- (NSMutableArray *)selectAllChapter:(NSString *)txtId{
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    FMResultSet *result = [[FMResultSet alloc] init];
    FMDatabase *db = [self getBase];
    if ([db open]) {
        result = [db executeQuery:@"select chapterid,title from table_chapters where txtId=?",txtId];
        while ([result next]) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:[result stringForColumn:@"chapterid"] forKey:@"chapterid"];
            [dic setValue:[result stringForColumn:@"title"] forKey:@"title"];
            [titleArray addObject:dic];
        }
    }
    [db close];
    
    return titleArray;
}

@end
