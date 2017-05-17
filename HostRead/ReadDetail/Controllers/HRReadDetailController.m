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
#import "HRDetailSettingView.h"
#import "HRSsettingController.h"

typedef NS_ENUM(NSInteger){
    Direction_left = 101,//左滑
    Direction_right = 102,//右滑
    Direction_up = 103,//上滑
    Direction_down = 104,//下滑
    Direction_none = 105
}Direction;

@interface HRReadDetailController ()<HRDetailSettingViewDelegate>

@property (nonatomic, strong) HRTxtChapterModel *upChapter;//上一章节

@property (nonatomic, strong) HRTxtChapterModel *redChapter;//正在阅读的章节

@property (nonatomic, strong) HRTxtChapterModel *nextChapter;//下一章节

@property (nonatomic, assign) NSInteger redPage;//已读页数

@property (nonatomic, assign) NSInteger redChapterCount;//章数

@property (nonatomic, strong) HRDBHelper *helper;

@property (nonatomic, strong) HRReadDetailView *readDetailOne;

@property (nonatomic, strong) HRReadDetailView *readDetailTwo;

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) Direction direction;

@property (nonatomic, assign) BOOL isSetting;//开启设置

@property (nonatomic, strong) HRDetailSettingView *settingView;

@property (nonatomic, assign) CGFloat fontSize;

@property (nonatomic, assign) BOOL isGradSetting;//高级设置

@end

@implementation HRReadDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.tabBarController.view.backgroundColor = [dic valueForKey:@"readBack"];
    self.helper = [[HRDBHelper alloc] init];
    self.isSetting = YES;//默认隐藏navbar
    self.fontSize = [[NSUserDefaults standardUserDefaults] floatForKey:@"FontSize"];
    
    [self setBackBtn];
    [self setRightBtnWithTxt:@"目录"];
    self.readDetailOne = [[HRReadDetailView alloc] init];
    self.readDetailOne.tag = 1;
    [self.view addSubview:self.readDetailOne];
    [self.readDetailOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.top.equalTo(self.view.mas_top);
        make.width.offset(ScreenWidth);
        make.height.offset(ScreenHeight);
    }];
    
    self.readDetailTwo = [[HRReadDetailView alloc] init];
    self.readDetailTwo.tag = 2;
    [self.view addSubview:self.readDetailTwo];
    [self.readDetailTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.top.equalTo(self.view.mas_top);
        make.width.offset(ScreenWidth);
        make.height.offset(ScreenHeight);
    }];
    
    self.settingView = [[HRDetailSettingView alloc] init];
    self.settingView.delegate = self;
    [self.view addSubview:self.settingView];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(160);
        make.leading.and.trailing.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveReadSlider) name:@"saveReadSlider" object:nil];
}

- (void)dealloc{
    NSLog(@"delloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"saveReadSlider" object:nil];
}

- (void)saveReadSlider{
    [self.helper updateSliderWitnTxtId:self.txtModel.txtId readPage:self.redPage readChapter:self.redChapterCount];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"ReadStyle"];
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.readDetailOne.backgroundColor = [dic valueForKey:@"readBack"];
    self.readDetailTwo.backgroundColor = [dic valueForKey:@"readBack"];
    self.readDetailTwo.dic = dic;
    self.readDetailOne.dic = dic;
    if (self.isGradSetting) {
        self.isGradSetting = false;
        return;
    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    [self.view bringSubviewToFront:self.readDetailOne];// 第一页显示到最上层
    [self initPageOneCon];
    self.redPage = [self.txtModel.redPage integerValue];
    if (self.redPage < 0) {
        self.redPage = 0;
    }
    self.redChapterCount = [self.txtModel.readChapter integerValue];
    self.redChapter = [self.helper selectChapterModelWithChapterCount:self.redChapterCount txtId:self.txtModel.txtId];
    [self.readDetailOne updateContent:[self.redChapter getTextWithPage:self.redPage] conAtt:self.redChapter.attDic title:self.redChapter.title page:[NSString stringWithFormat:@"%ld/%ld",self.redPage+1,self.redChapter.pageCount]];
    dispatch_async(dispatch_queue_create("LoadOtherChapter", NULL), ^{
        if (self.redChapterCount<= [self.txtModel.allChapter integerValue]) {
            self.nextChapter = [self.helper selectChapterModelWithChapterCount:self.redChapterCount+1 txtId:self.txtModel.txtId];
        }
        if (self.redChapterCount > 0) {
            self.upChapter = [self.helper selectChapterModelWithChapterCount:self.redChapterCount-1 txtId:self.txtModel.txtId];
        }
    });
}

- (void)updateContent:(Direction)direction showPage:(HRReadDetailView *)pageView{
    if (direction == Direction_left) {//下一页
        self.redPage += 1;
        if (self.redPage >= self.redChapter.pageCount && self.redChapterCount<= [self.txtModel.allChapter integerValue]) {
            self.redPage = 0;
            self.redChapterCount += 1;
            self.upChapter = self.redChapter;
            self.redChapter =self.nextChapter;
            dispatch_async(dispatch_queue_create("LoadOtherChapter", NULL), ^{self.nextChapter = [self.helper selectChapterModelWithChapterCount:self.redChapterCount+1 txtId:self.txtModel.txtId];});
        }
    }else if(direction == Direction_right){//上一页
        self.redPage -= 1;
        if (self.redPage < 0 && self.redChapterCount > 0) {
            self.nextChapter = self.redChapter;
            self.redChapter = self.upChapter;
            self.redChapterCount -= 1;
            dispatch_async(dispatch_queue_create("LoadOtherChapter", NULL), ^{self.upChapter = [self.helper selectChapterModelWithChapterCount:self.redChapterCount txtId:self.txtModel.txtId];});
            self.redPage = self.redChapter.pageCount-1;
        }
    }
    [pageView updateContent:[self.redChapter getTextWithPage:self.redPage] conAtt:self.redChapter.attDic title:self.redChapter.title page:[NSString stringWithFormat:@"%ld/%ld",self.redPage+1,self.redChapter.pageCount]];
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
        if (!self.isSetting) {
            return;
        }
        if (panPoint.x >= 1) {
            if (self.redChapterCount<=0 && self.redPage<=0) {//第一页 不能前翻
                return;
            }
            self.direction = Direction_right;
        } else {
            if (self.redChapterCount>=[self.txtModel.allChapter integerValue]-1 && self.redPage >= self.redChapter.pageCount-1) {//第一页 不能前翻
                return;
            }
            self.direction = Direction_left;
            if (touch.view.tag == 1 ) {
                [self initPageTwoCon];
            }else{
                [self initPageOneCon];
            }
        }
        
    } else if (panPoint.y >= 1 || panPoint.y <= -1) {//上下
        if (!self.isSetting) {
            return;
        }
        if (panPoint.x >= 1) {
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
    
    if (endPoint.x == self.startPoint.x && endPoint.y == self.startPoint.y) {//加载设置 
        [self loadSetting:touch.view.tag];
    }

    switch (self.direction) {
        case Direction_none:
            
            break;
            
        case Direction_up:
            
            break;
            
        case Direction_down:
            
            break;
            
        case Direction_left:{
            if (self.redChapterCount>=[self.txtModel.allChapter integerValue]-1 && self.redPage >= self.redChapter.pageCount-1) {//第一页 不能前翻
                return;
            }
            [moveView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
            }];
            [UIView animateWithDuration:0.5f animations:^{
                [moveView mas_makeConstraints:^(MASConstraintMaker *make) {
                    if ((self.startPoint.x-endPoint.x) > 50) {
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
            if (self.redChapterCount<=0 && self.redPage<=0) {//第一页 不能前翻
                return;
            }
            [moveView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
            }];
            [UIView animateWithDuration:0.5f animations:^{
                [moveView mas_makeConstraints:^(MASConstraintMaker *make) {
                    if ((self.startPoint.x-endPoint.x) > -50) {
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

- (void)loadSetting:(NSInteger)touchTag{
    if (self.startPoint.x > ScreenWidth/2 - 50 && self.startPoint.x < ScreenWidth/2 + 50) {//弹出设置
        if (!self.isSetting) {
            self.startPoint = CGPointMake(self.startPoint.x, self.startPoint.y+64);
        }
        if (self.startPoint.y < ScreenHeight/2+50 && self.startPoint.y > ScreenHeight/2-50) {
            self.isSetting = !self.isSetting;
            HRReadDetailView *moveView = [self getMoveView:touchTag direction:self.direction];
            if (self.isSetting) {
                [moveView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view.mas_top);
                }];
                
                [self.settingView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                }];

                [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(160);
                    make.leading.and.trailing.equalTo(self.view);
                    make.top.equalTo(self.view.mas_bottom);
                }];
                //更新
                [self updateShowTextContent:moveView];
            }else{
                [moveView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view.mas_top).offset(-64);
                }];
                
                [self.view bringSubviewToFront:self.settingView];
                [self.settingView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                }];
                [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(160);
                    make.leading.and.trailing.equalTo(self.view);
                    make.bottom.equalTo(self.view.mas_bottom);
                }];
            }
            [self.navigationController setNavigationBarHidden:self.isSetting animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:self.isSetting withAnimation:UIStatusBarAnimationSlide];
        }
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

- (void)doLeftAction:(id)sender{
    self.readDetailOne.hidden = YES;
    self.readDetailTwo.hidden = YES;
    [self.helper updateSliderWitnTxtId:self.txtModel.txtId readPage:self.redPage readChapter:self.redChapterCount];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doRightAction:(id)sender{
    //隐藏设置界面
    self.isSetting = !self.isSetting;
    [self.settingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(160);
        make.leading.and.trailing.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
    }];
    
    self.txtModel.readChapter = [NSString stringWithFormat:@"%ld",self.redChapterCount];
    HRChapterListController *cha = [[HRChapterListController alloc] init];
//    cha.allChapters = [self.helper selectAllChapter:self.txtModel.txtId page:1];
    cha.txtModel = self.txtModel;
    [self.navigationController pushViewController:cha animated:YES];
}

#pragma mark HRDetailSettingViewDelegate
- (void)hrDetailSettingWithSettingType:(SettingType)settingType{
    if (settingType == SettingTypeFontAdd) {
        self.fontSize += 2;
        [self changeContentFont:self.fontSize];
    }else if(settingType == SettingTypeFontReduce){
        self.fontSize -= 2;
        [self changeContentFont:self.fontSize];
    }else if(settingType == SettingTypeUpChapter){
        if (self.redChapterCount > 0) {
            self.redChapterCount -= 1;
        }
        [self upOrNextChapter:self.redChapterCount];
    }else if(settingType == SettingTypeNextChapter){
        if (self.redChapterCount < [self.txtModel.allChapter integerValue]) {
            self.redChapterCount += 1;
        }
        [self upOrNextChapter:self.redChapterCount];
    }else if(settingType == SettingTypeGraSetting){
        HRSsettingController *sett = [[HRSsettingController alloc] init];
        UINavigationController  *nav= [[UINavigationController alloc] initWithRootViewController:sett];
        [self presentViewController:nav animated:YES completion:^{
            self.isGradSetting = YES;
        }];
    }else if (settingType == SettingTypeLightStyle) {
        [self changeReadModel:RGBA(245, 245, 245, 1) contentColor:RGBA(34, 34, 34, 1)];
    }else if(settingType == SettingTypeBlackStyle){
        [self changeReadModel:RGBA(34, 34, 34, 1) contentColor:RGBA(245, 245, 245, 1)];
    }else if(settingType == SettingTypeEyeStyle){
        [self changeReadModel:RGBA(159,223,176,1) contentColor:RGBA(34, 34, 34, 1)];
    }else if(settingType == SettingTypeYellowStyle){
        [self changeReadModel:[UIColor colorWithHexa:@"#9e902a"] contentColor:RGBA(34, 34, 34, 1)];
    }
}

- (void)changeReadModel:(UIColor *)backColor contentColor:(UIColor *)contentColor{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:backColor forKey:@"readBack"];
    [dic setValue:contentColor forKey:@"contentColor"];
     NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dic];
    [[NSUserDefaults standardUserDefaults] setValue:personEncodedObject forKey:@"ReadStyle"];
    [self.readDetailOne changeReadModel:backColor contentColor:contentColor];
    [self.readDetailTwo changeReadModel:backColor contentColor:contentColor];
    self.view.backgroundColor = backColor;
    self.navigationController.tabBarController.view.backgroundColor = backColor;
}

- (void)changeContentFont:(CGFloat)fontSzie{
    [[NSUserDefaults standardUserDefaults] setFloat:fontSzie forKey:@"FontSize"];
    [self.readDetailOne.contect setFont:[UIFont systemFontOfSize:fontSzie]];
    [self.readDetailTwo.contect setFont:[UIFont systemFontOfSize:fontSzie]];
//    NSString *notReadContent = @"";
//    if (self.redPage != (self.redChapter.pageCount-1)) {
//        for (NSInteger i = self.redPage;i<self.redChapter.pageCount; i++) {
//            notReadContent = [NSString stringWithFormat:@"%@%@",notReadContent,[self.redChapter getTextWithPage:i]];
//        }
//    }
    self.redChapter.content = self.redChapter.content;
    self.nextChapter.content = self.nextChapter.content;
    self.upChapter.content = self.upChapter.content;
}

- (void)upOrNextChapter:(NSInteger)chapter{
    self.redPage = 0;
    self.upChapter = self.redChapter;
    self.redChapter =[self.helper selectChapterModelWithChapterCount:self.redChapterCount txtId:self.txtModel.txtId];
    [self.readDetailOne updateContent:[self.redChapter getTextWithPage:self.redPage] conAtt:self.redChapter.attDic title:self.redChapter.title page:[NSString stringWithFormat:@"%ld/%ld",self.redPage+1,self.redChapter.pageCount]];
    [self.readDetailTwo updateContent:[self.redChapter getTextWithPage:self.redPage] conAtt:self.redChapter.attDic title:self.redChapter.title page:[NSString stringWithFormat:@"%ld/%ld",self.redPage+1,self.redChapter.pageCount]];
}

- (void)updateShowTextContent:(HRReadDetailView *)showView{
//    self.redPage = 0;
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"ReadStyle"];
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.readDetailOne.backgroundColor = [dic valueForKey:@"readBack"];
    self.readDetailTwo.backgroundColor = [dic valueForKey:@"readBack"];
    self.readDetailTwo.dic = dic;
    self.readDetailOne.dic = dic;
    [showView updateContent:[self.redChapter getTextWithPage:self.redPage] conAtt:self.redChapter.attDic title:self.redChapter.title page:[NSString stringWithFormat:@"%ld/%ld",self.redPage+1,self.redChapter.pageCount]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
