//
//  HRReadDetailController.m
//  HostRead
//
//  Created by huangrensheng on 16/8/24.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRReadDetailController.h"
#import "HRTxtModel.h"
#import "HRTxtChapterModel.h"
#import "HRDidReadModel.h"
#import "HRDBHelper.h"
#import "HRReadDetailView.h"
#import "HRChapterListController.h"

typedef NS_ENUM(NSInteger){
    Direction_left = 101,//左滑
    Direction_right = 102,//右滑
    Direction_up = 103,//上滑
    Direction_down = 104,//下滑
    Direction_none = 105
}Direction;

@interface HRReadDetailController ()<HRReadDetailViewDelegate>

@property (nonatomic, strong) HRTxtChapterModel *redChapter;

@property (nonatomic, assign) NSInteger redPage;

@property (nonatomic, assign) NSInteger redChapterCount;

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, assign) NSInteger totalChapter;

@property (nonatomic, strong) HRDBHelper *helper;

@property (nonatomic, strong) HRReadDetailView *readDetailOne;

@property (nonatomic, strong) HRReadDetailView *readDetailTwo;

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) Direction direction;

@end

@implementation HRReadDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(159,223,176,1);
    self.helper = [[HRDBHelper alloc] init];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.readDetailOne = [[HRReadDetailView alloc] init];
    self.readDetailOne.tag = 1;
    self.readDetailOne.delegate = self;
    [self.view addSubview:self.readDetailOne];
    [self.readDetailOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.top.equalTo(self.view.mas_top);
        make.width.offset(ScreenWidth);
        make.height.offset(ScreenHeight);
    }];
    
    self.readDetailTwo = [[HRReadDetailView alloc] init];
    self.readDetailTwo.tag = 2;
    self.readDetailTwo.delegate = self;
    [self.view addSubview:self.readDetailTwo];
    [self.readDetailTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.top.equalTo(self.view.mas_top);
        make.width.offset(ScreenWidth);
        make.height.offset(ScreenHeight);
    }];
    
    self.redPage = [self.txtModel.redPage integerValue];
    self.redChapterCount = [self.txtModel.readChapter integerValue];
    self.redChapter = [self.helper selectChapterModelWithChapterCount:self.redChapterCount txtId:self.txtModel.txtId];
    self.totalPage = self.redChapter.pageCount;
    [self.readDetailOne updateContent:[self.redChapter getTextWithPage:self.redPage] title:self.redChapter.title page:[NSString stringWithFormat:@"%ld/%ld",self.redPage+1,self.redChapter.pageCount]];
    
    [self.view bringSubviewToFront:self.readDetailOne];// 第一页显示到最上层
}

- (void)updateContent:(Direction)direction showPage:(HRReadDetailView *)pageView{
    if (direction == Direction_left) {//下一页
        self.redPage += 1;
        if (self.redPage >= self.redChapter.pageCount && self.redChapterCount<= [self.txtModel.allChapter integerValue]) {
            self.redPage = 0;
            self.redChapterCount += 1;
            self.redChapter =[self.helper selectChapterModelWithChapterCount:self.redChapterCount txtId:self.txtModel.txtId];
        }
    }else if(direction == Direction_right){//上一页
        self.redPage -= 1;
        if (self.redPage < 0 && self.redChapterCount >= 1) {
            self.redChapterCount -= 1;
            self.redChapter =[self.helper selectChapterModelWithChapterCount:self.redChapterCount txtId:self.txtModel.txtId];
            self.redPage = self.redChapter.pageCount-1;
        }
    }
    [pageView updateContent:[self.redChapter getTextWithPage:self.redPage] title:self.redChapter.title page:[NSString stringWithFormat:@"%ld/%ld",self.redPage+1,self.redChapter.pageCount]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    //获取触摸开始的坐标
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self.view];
    self.startPoint = currentP;
    self.direction = Direction_none;
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint movePoint = [touch locationInView:self.view];

    //得出手指在view上移动的距离
    CGPoint panPoint = CGPointMake(movePoint.x - self.startPoint.x, movePoint.y - self.startPoint.y);
    //分析出用户滑动的方向
    if (panPoint.x >= 1 || panPoint.x <= -1) {//左右
        if (self.startPoint.x <= self.view.frame.size.width / 2.0) {
            if (self.redChapterCount<=1 && self.redPage<=0) {//第一页 不能前翻
                return;
            }
            self.direction = Direction_right;
        } else {
            self.direction = Direction_left;
            if (touch.view.tag == 1 ) {
                [self initPageTwoCon];
            }else{
                [self initPageOneCon];
            }
        }
        
    } else if (panPoint.y >= 30 || panPoint.y <= -30) {//上下
        if (self.startPoint.y <= self.view.frame.size.height / 2.0) {
            self.direction = Direction_down;
           
        } else {
            self.direction = Direction_up;
            
        }
    }
    
    HRReadDetailView *moveView = [self getMoveView:touch.view.tag direction:self.direction];
    if (self.direction == Direction_right) {
        [self.view bringSubviewToFront:moveView];
        [moveView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [moveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.view.mas_leading).offset(panPoint.x);
            make.top.equalTo(self.view.mas_top);
            make.width.offset(ScreenWidth);
            make.height.offset(ScreenHeight);
        }];
    }else if(self.direction == Direction_left){
        [moveView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.view bringSubviewToFront:moveView];
        [moveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view.mas_leading).offset(panPoint.x);
            make.top.equalTo(self.view.mas_top);
            make.width.offset(ScreenWidth);
            make.height.offset(ScreenHeight);
        }];
    }
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    HRReadDetailView *moveView = [self getMoveView:touch.view.tag direction:self.direction];
    CGPoint endPoint = [touch locationInView:self.view];
    
    switch (self.direction) {
        case Direction_none:
            
            break;
            
        case Direction_up:
            
            break;
            
        case Direction_down:
            
            break;
            
        case Direction_left:{
            [moveView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
            }];
            [UIView animateWithDuration:0.5f animations:^{
                [moveView mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (endPoint.x < ScreenWidth/2) {
                        make.trailing.equalTo(self.view.mas_leading);
                        if (moveView.tag == 1) {
                            [self updateContent:self.direction showPage:self.readDetailTwo];
                        }else{
                            [self updateContent:self.direction showPage:self.readDetailOne];
                        }
                    }else{
                        make.trailing.equalTo(self.view.mas_trailing);
                    }
                    make.top.equalTo(self.view.mas_top);
                    make.width.offset(ScreenWidth);
                    make.height.offset(ScreenHeight);
                }];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }break;
        case Direction_right:{
            if (self.redChapterCount<=1 && self.redPage<=0) {//第一页 不能前翻
                return;
            }
            [moveView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
            }];
            [UIView animateWithDuration:0.5f animations:^{
                [moveView mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (endPoint.x < ScreenWidth/2) {
                        make.trailing.equalTo(self.view.mas_leading);
                    }else{
                        make.trailing.equalTo(self.view.mas_trailing);
                        [self updateContent:self.direction showPage:moveView];
                    }
                    make.top.equalTo(self.view.mas_top);
                    make.width.offset(ScreenWidth);
                    make.height.offset(ScreenHeight);
                }];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }break;
    }
}


- (HRReadDetailView *)getMoveView:(NSInteger)tag direction:(Direction)direction{
    if (tag == 1) {
        if (direction == Direction_right) {//右滑返回另一个对象
            return self.readDetailTwo;
        }
        return self.readDetailOne;//左滑 返回本身
    }else{
        if (direction == Direction_right) {//右滑返回另一个对象
            return self.readDetailOne;
        }
        return self.readDetailTwo;
    }
    
}

- (void)initPageOneCon{
    [self.readDetailOne mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.readDetailOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.top.equalTo(self.view.mas_top);
        make.width.offset(ScreenWidth);
        make.height.offset(ScreenHeight);
    }];
}

- (void)initPageTwoCon{
    [self.readDetailTwo mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.readDetailTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.top.equalTo(self.view.mas_top);
        make.width.offset(ScreenWidth);
        make.height.offset(ScreenHeight);
    }];
}

#pragma HRReadDetailViewDelegate
- (void)HRReadDetailViewDidSetting:(HReeadSettingType)settingType{
    if (settingType == HReeadSettingBack) {
        [self.helper updateSliderWitnTxtId:self.txtModel.txtId readPage:self.redPage readChapter:self.redChapterCount];
        [self.navigationController popViewControllerAnimated:YES];
    }else if(settingType == HReeadSettingList){
        HRChapterListController *cha = [[HRChapterListController alloc] init];
        cha.allChapters = [self.helper selectAllChapter:self.txtModel.txtId];
        UINavigationController *ch = [[UINavigationController alloc] initWithRootViewController:cha];
        [self presentViewController:ch animated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
