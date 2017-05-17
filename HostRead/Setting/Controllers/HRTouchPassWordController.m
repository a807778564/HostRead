//
//  HRTouchPassWordController.m
//  HostRead
//
//  Created by huangrensheng on 2017/5/16.
//  Copyright © 2017年 kawaii. All rights reserved.
//

#import "HRTouchPassWordController.h"
#define touchWidth (ScreenWidth/6*5)
@interface HRTouchPassWordController ()
@property (nonatomic,strong) NSMutableArray *buttonArr;//全部手势按键的数组
@property (nonatomic,strong) NSMutableArray *selectorArr;//选中手势按键的数组
@property (nonatomic,assign) CGPoint startPoint;//记录开始选中的按键坐标
@property (nonatomic,assign) CGPoint endPoint;//记录结束时的手势坐标
@property (nonatomic,strong) UIImageView *imageView;//画图所需
@property (nonatomic, strong) UILabel *showInfo;//显示密码验证信息
@property (nonatomic, strong) NSString *savePass;//保存的密码
@end

@implementation HRTouchPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = !self.showHeader;
    if (self.showHeader) {
        self.title = @"手势密码";
        [self setBackBtn];
    }
    if (!self.buttonArr) {
        self.buttonArr = [[NSMutableArray alloc] initWithCapacity:9];
    }
    if (!self.selectorArr) {
        self.selectorArr = [[NSMutableArray alloc] initWithCapacity:9];
    }
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"appPass"];
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.offset(touchWidth);
        make.height.offset(touchWidth);
    }];
    
    self.showInfo = [[UILabel alloc] initWithFont:[UIFont systemFontOfSize:14] TextColor:RGBA(249, 112, 99, 1) Text:@""];
    self.showInfo.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.showInfo];
    [self.showInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(34);
        make.leading.and.trailing.equalTo(self.imageView);
        make.bottom.equalTo(self.imageView.mas_top);
    }];
    
    for (int i=0; i<9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i+1;
        [btn setImage:[UIImage imageNamed:@"HR_normal_Pass"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"HR_selected_Pass"] forState:UIControlStateHighlighted];
        btn.userInteractionEnabled = NO;
        [self.buttonArr addObject:btn];
        [self.imageView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            UIButton *upBtn = nil;
            if (i>0) {
                upBtn = self.imageView.subviews[i-1];
                if (i%3==0) {
                    make.top.equalTo(upBtn.mas_bottom).offset(touchWidth/5);
                    make.leading.equalTo(self.imageView.mas_leading);
                }else{
                    make.top.equalTo(upBtn.mas_top);
                    make.leading.equalTo(upBtn.mas_trailing).offset(touchWidth/5);
                }
            }else{
                make.top.equalTo(self.imageView.mas_top);
                make.leading.equalTo(self.imageView.mas_leading);
            }
            make.width.offset(touchWidth/5);
            make.height.offset(touchWidth/5);
        }];
    }
    
}

-(UIImage *)drawLine{
    UIImage *image = nil;
    if (self.selectorArr.count<=0) {
        return image;
    }
    if (self.selectorArr.count==1) {
        UIButton *btn = self.selectorArr[0];
        self.startPoint = btn.center;
    }
    UIColor *col =RGBA(249, 112, 99, 1);
    UIGraphicsBeginImageContext(self.imageView.frame.size);//设置画图的大小为imageview的大小
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5);
    CGContextSetStrokeColorWithColor(context, col.CGColor);
    
    CGContextMoveToPoint(context, self.startPoint.x, self.startPoint.y);//设置画线起点
    
    //从起点画线到选中的按键中心，并切换画线的起点
    for (UIButton *btn in self.selectorArr) {
        CGPoint btnPo = btn.center;
        CGContextAddLineToPoint(context, btnPo.x, btnPo.y);
        CGContextMoveToPoint(context, btnPo.x, btnPo.y);
    }
    //画移动中的最后一条线
    CGContextAddLineToPoint(context, self.endPoint.x, self.endPoint.y);
    
    CGContextStrokePath(context);
    
    image = UIGraphicsGetImageFromCurrentImageContext();//画图输出
    UIGraphicsEndImageContext();//结束画线
    return image;
}

//开始手势
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];//保存所有触摸事件
    if (touch) {
        for (UIButton *btn in self.buttonArr) {
            CGPoint po = [touch locationInView:btn];//记录按键坐标
            if ([btn pointInside:po withEvent:nil]) {//判断按键坐标是否在手势开始范围内,是则为选中的开始按键
                self.savePass = [NSString stringWithFormat:@"%ld",btn.tag];
                [self.selectorArr addObject:btn];
                btn.highlighted = YES;
                self.startPoint = btn.center;//保存起始坐标
            }
        }
    }
}

//移动中触发，画线过程中会一直调用画线方法
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        
        self.endPoint = [touch locationInView:self.imageView];
        for (UIButton *btn in self.buttonArr) {
            CGPoint po = [touch locationInView:btn];
            if ([btn pointInside:po withEvent:nil]) {
                
                BOOL isAdd = YES;//记录是否为重复按键
                for (UIButton *seBtn in self.selectorArr) {
                    if (seBtn == btn) {
                        isAdd = NO;//已经是选中过的按键，不再重复添加
                        break;
                    }
                }
                if (isAdd) {//未添加的选中按键，添加并修改状态
                    if (self.savePass) {
                        self.savePass = [NSString stringWithFormat:@"%@,%ld",self.savePass,btn.tag];
                    }else{
                        self.savePass = [NSString stringWithFormat:@"%ld",btn.tag];
                    }
                    [self.selectorArr addObject:btn];
                    btn.highlighted = YES;
                }
                
            }
        }
    }
    self.imageView.image = [self drawLine];//每次移动过程中都要调用这个方法，把画出的图输出显示
    
}
//手势结束触发
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.imageView.image = nil;
    [self.selectorArr removeAllObjects];
    [self saveDrawPassWord];
    self.savePass = nil;
    for (UIButton *btn in self.buttonArr) {
        btn.highlighted = NO;
    }
}


- (void)saveDrawPassWord{
    NSString *hosPass = [[NSUserDefaults standardUserDefaults] stringForKey:@"appPass"];
    if (hosPass) {
        if (![hosPass isEqualToString:self.savePass]){
            self.showInfo.text = @"密码输入错误";
            return;
        }
        self.showInfo.text = @"确认成功";
        if (self.showHeader) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        if (self.savePass.length<6) {
           self.showInfo.text = @"请链接最少四位密码";
            return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:self.savePass forKey:@"appPass"];
        self.showInfo.text = @"请确认密码";
    }
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
