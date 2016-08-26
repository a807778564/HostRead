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

@interface HRReadDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) HRTxtChapterModel *redChapter;

@property (nonatomic, assign) NSInteger redPage;

@property (nonatomic, assign) NSInteger redChapterCount;

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, assign) NSInteger totalChapter;

@property (nonatomic, strong) HRDBHelper *helper;

@property (nonatomic, strong) HRReadDetailView *readDetail;

@end

@implementation HRReadDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    
    self.view.backgroundColor = RGBA(159,223,176,1);
    self.helper = [[HRDBHelper alloc] init];
    
    self.readDetail = [[HRReadDetailView alloc] init];
    [self.view addSubview:self.readDetail];
    [self.readDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.redPage = [self.txtModel.redPage integerValue];
    self.redChapterCount = [self.txtModel.readChapter integerValue];
    
    self.redChapter = [self.helper selectChapterModelWithChapterCount:self.redChapterCount txtId:self.txtModel.txtId];
    self.totalPage = self.redChapter.pageCount;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    [self.readDetail updateContent:[self.redChapter getTextWithPage:self.redPage] title:self.redChapter.title page:[NSString stringWithFormat:@"%ld/%ld",self.redPage+1,self.redChapter.pageCount]];
}

#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [[UICollectionViewCell alloc] init];
}

-(void) nextpage{
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:1];
    
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = currentIndexPathReset.item +1;
    NSInteger nextSection = currentIndexPathReset.section;
//    if (nextItem==self.newses.count) {
//        nextItem=0;
//        nextSection++;
//    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


- (void)addClick{
    self.redPage += 1;
    if (self.redPage >= self.redChapter.pageCount) {
        self.redPage = 0;
        self.redChapterCount += 1;
        self.redChapter =[self.helper selectChapterModelWithChapterCount:self.redChapterCount txtId:self.txtModel.txtId];
    }
    [self.readDetail updateContent:[self.redChapter getTextWithPage:self.redPage] title:self.redChapter.title page:[NSString stringWithFormat:@"%ld/%ld",self.redPage+1,self.redChapter.pageCount]];
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
