//
//  HRTextCollectionCell.m
//  HostRead
//
//  Created by huangrensheng on 17/3/14.
//  Copyright © 2017年 kawaii. All rights reserved.
//

#import "HRTextCollectionCell.h"

@implementation HRTextCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"ReadStyle"];
        NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.showText = [[UITextView alloc] init];
        self.showText.userInteractionEnabled = NO;
        self.showText.backgroundColor = [UIColor clearColor];
        self.showText.textColor = [dic valueForKey:@"contentColor"];
        self.showText.textAlignment = NSTextAlignmentLeft;
        self.showText.font = [UIFont systemFontOfSize:[[NSUserDefaults standardUserDefaults] floatForKey:@"FontSize"]];
        [self.contentView addSubview:self.showText];
        [self.showText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
@end
