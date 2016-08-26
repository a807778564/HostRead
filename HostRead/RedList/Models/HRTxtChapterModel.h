//
//  HRTxtChapterModel.h
//  HostRead
//
//  Created by huangrensheng on 16/8/24.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRTxtChapterModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) NSInteger txtId;

@property (nonatomic, assign) NSInteger chapterId;

@property (nonatomic, assign) NSInteger pageCount;

- (NSString *)getTextWithPage:(NSInteger)page;

@end
