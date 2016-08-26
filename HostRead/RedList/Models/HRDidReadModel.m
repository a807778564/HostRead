//
//  HRDidReadModel.m
//  HostRead
//
//  Created by huangrensheng on 16/8/24.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRDidReadModel.h"

@implementation HRDidReadModel

- (instancetype)init{
    if ([super init]) {
        self.redChapter = 0;
        self.redPage = 0;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:@(self.redChapter) forKey:@"redChapter"];
    [aCoder encodeObject:@(self.redPage) forKey:@"redPage"];
    //    [aCoder encodeObject:self.notes forKey:@"notes"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.redChapter = [[aDecoder decodeObjectForKey:@"redChapter"] integerValue];
        self.redPage = [[aDecoder decodeObjectForKey:@"redPage"] integerValue];
    }
    return self;
}

@end
