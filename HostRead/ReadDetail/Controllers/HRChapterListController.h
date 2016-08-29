//
//  HRChapterListController.h
//  HostRead
//
//  Created by huangrensheng on 16/8/27.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRBaseController.h"
@class HRTxtModel;

@interface HRChapterListController : HRBaseController

@property (nonatomic, strong) NSMutableArray *allChapters;

@property (nonatomic, strong) HRTxtModel *txtModel;

@end
