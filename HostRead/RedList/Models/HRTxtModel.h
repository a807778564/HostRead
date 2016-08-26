//
//  HRTxtModel.h
//  HostRead
//
//  Created by huangrensheng on 16/8/24.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HRTxtChapterModel,HRDidReadModel;

@interface HRTxtModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *txtId;

@property (nonatomic, strong) NSString *txtName;

@property (nonatomic, strong) NSString *redPage;

@property (nonatomic, strong) NSString *readChapter;

@property (nonatomic, strong) NSString *allChapter;

@end
