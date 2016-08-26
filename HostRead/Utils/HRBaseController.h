//
//  HRBaseController.h
//  HostRead
//
//  Created by huangrensheng on 16/8/22.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRBaseController : UIViewController<UITableViewDelegate,UITableViewDataSource>

- (void)setBackBtn;
- (void)setRightBtn;
- (void)doLeftAction:(id)sender;
- (void)doRightAction:(id)sender;
@end
