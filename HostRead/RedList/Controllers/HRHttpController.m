//
//  HRHttpController.m
//  HostRead
//
//  Created by huangrensheng on 16/9/8.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRHttpController.h"
#import "HTTPServer.h"
#import "HRHTTPConnection.h"
#import "HRProGressView.h"

@interface HRHttpController ()

@property (nonatomic, strong) HTTPServer *httpserver;

@property (nonatomic, strong) UILabel *lbHTTPServer;

@property (nonatomic, strong) UIProgressView *progress;

@property (nonatomic, assign) float pro;

@end

@implementation HRHttpController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文件传输";
    [self setBackBtn];
    
    UIImageView *wifiImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upLoad_wifi"]];
    wifiImage.alpha = 0.8;
    [self.view addSubview:wifiImage];
    [wifiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_centerY).offset(-20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.offset(150);
        make.height.offset(150);
    }];
    
    UILabel *aleMes = [[UILabel alloc] initWithFont:[UIFont systemFontOfSize:13.0f] TextColor:mainColor Text:@"请在电脑浏览器输入下面地址:"];
    aleMes.alpha = 0.8;
    [self.view addSubview:aleMes];
    [aleMes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    self.lbHTTPServer = [[UILabel alloc] initWithFont:[UIFont boldSystemFontOfSize:15.0f] TextColor:mainColor Text:@""];
    self.lbHTTPServer.alpha = 0.8;
    [self.view addSubview:self.lbHTTPServer];
    [self.lbHTTPServer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(aleMes.mas_bottom).offset(8);
    }];
    
    UILabel *dontMes = [[UILabel alloc] initWithFont:[UIFont systemFontOfSize:13.0f] TextColor:mainColor Text:@"传输中请勿关闭此页"];
    dontMes.alpha = 0.8;
    [self.view addSubview:dontMes];
    [dontMes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.lbHTTPServer.mas_bottom).offset(8);
    }];
    
    UILabel *same = [[UILabel alloc] initWithFont:[UIFont systemFontOfSize:13.0f] TextColor:mainColor Text:@"确保您的iPhone和电脑在同一个WiFi网络下"];
    same.alpha = 0.8;
    [self.view addSubview:same];
    [same mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(dontMes.mas_bottom).offset(8);
    }];

    self.httpserver = [[HTTPServer alloc] init];
    [self.httpserver setType:@"_http._tcp."];
//    [self.httpserver setPort:16918];
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"WebSite"];
    [self.httpserver setDocumentRoot:webPath];
    [_httpserver setConnectionClass:[HRHTTPConnection class]];
    [self startServer];
    
    self.progress = [[UIProgressView alloc] init];
    self.progress.trackTintColor = [UIColor whiteColor];
    self.progress.tintColor = RGBA(245, 142, 45, 1);
    self.progress.progress = 0.0;
    [self.view addSubview:self.progress];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0.5);
        make.leading.and.trailing.equalTo(self.view);
        make.height.offset(2);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProGress:) name:@"UpLoadingPro" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEnd:) name:@"UpLoadingProEnd" object:nil];
}


- (void)updateProGress:(NSNotification *)center{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pro += [center.userInfo[@"progressvalue"] floatValue];
        self.progress.progress = self.pro;
        NSLog(@" 进度 = %.2f",self.pro);
        if (self.pro >= 0.99) {
            self.pro = 0;
            self.progress.progress = 0;
        }
    });
}


- (void)updateEnd:(NSNotification *)center{
    dispatch_async(dispatch_get_main_queue(), ^{
        do {
            self.pro += 0.02;
            self.progress.progress = self.pro;
        } while (self.pro <= 0.99);
        
        NSLog(@" 进度 = %.2f",self.pro);
        
        if (self.pro >= 0.99) {
            self.pro = 0;
            self.progress.progress = 0;
        }
    });
}


- (void)startServer
{
    NSError *error;
    if ([_httpserver start:&error])
        [self.lbHTTPServer setText:[NSString stringWithFormat:@"http://%@:%hu", [_httpserver hostName], [_httpserver listeningPort]]];
    else
        NSLog(@"Error Started HTTP Server:%@", error);
}


- (void)doLeftAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
