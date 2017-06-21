//
//  HRSsettingController.m
//  HostRead
//
//  Created by huangrensheng on 16/8/22.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HRSsettingController.h"
#import "HRLoginController.h"
#import "HRTouchPassWordController.h"
#import <SocketRocket/SRWebSocket.h>
#import "HRSettingCell.h"
#import "HRSettingColorController.h"

@interface HRSsettingController ()<UITableViewDelegate,UITableViewDataSource>//<SRWebSocketDelegate>
@property (nonatomic, strong) UITableView *settTable;
@property (nonatomic, strong) NSArray *cellArray;
@end

@implementation HRSsettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self setBackBtn];
    
    self.settTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.settTable.dataSource = self;
    self.settTable.delegate = self;
    self.settTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.settTable];
    [self.settTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.cellArray = [NSArray arrayWithObjects:@"主题色",@"主题文字",@"背景色",@"字体颜色",@"密码保护", nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"HRSettingCell";
    HRSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[HRSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.titleString = self.cellArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HRSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.settLabel.text isEqualToString:@"密码保护"]) {
        if ([cell.rightBtn.titleLabel.text isEqualToString:@"关闭"]) {
            HRTouchPassWordController *pass = [[HRTouchPassWordController alloc] init];
            pass.showHeader = YES;
            [self.navigationController pushViewController:pass animated:YES];
        }
    }else if([cell.settLabel.text isEqualToString:@"文字样式"]){
        
    }else if([cell.settLabel.text isEqualToString:@"清理重置"]){
        
    }else{
        HRSettingColorController *color = [[HRSettingColorController alloc] init];
        color.colorTitle = cell.settLabel.text;
        [self.navigationController pushViewController:color animated:YES];
    }
}

- (void)doRightAction:(id)sender{
//    HRLoginController *login = [[HRLoginController alloc] init];
//    login.hidesBottomBarWhenPushed = YES;s
//      [self.navigationController pushViewController:login animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.settTable reloadData];
//    SRWebSocket *soc = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http:www.baidu.com"]]];
//    soc.delegate = self;
//    [soc open];
}

//- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
//    NSLog(@"连接成功，可以立刻登录你公司后台的服务器了，还有开启心跳");
//}
//
//- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
//    NSLog(@"连接失败，这里可以实现掉线自动重连，要注意以下几点");
//    NSLog(@"1.判断当前网络环境，如果断网了就不要连了，等待网络到来，在发起重连");
//    NSLog(@"2.判断调用层是否需要连接，例如用户都没在聊天界面，连接上去浪费流量");
//    NSLog(@"3.连接次数限制，如果连接失败了，重试10次左右就可以了，不然就死循环了。或者每隔1，2，4，8，10，10秒重连...f(x) = f(x-1) * 2, (x=5)");
//}
//
//- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
//    NSLog(@"连接断开，清空socket对象，清空该清空的东西，还有关闭心跳！");
//}
//
//- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
//    NSLog(@"收到数据了，注意 message 是 id 类型的，学过C语言的都知道，id 是 (void *)void* 就厉害了，二进制数据都可以指着，不详细解释 void* 了");
//    NSLog(@"我这后台约定的 message 是 json 格式数据收到数据，就按格式解析吧，然后把数据发给调用层");
//}

//- (void)sendData:(id)data {
//    WEAKSELF(ws);
//    dispatch_async(self.socketQueue, ^{
//        if (ws.socket != nil) {
            // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
//            if (ws.socket.readyState == SR_OPEN) {
//                [ws.socket send:data];    // 发送数据
                
//            } else if (ws.socket.readyState == SR_CONNECTING) {
//                NSLog(@"正在连接中，重连后其他方法会去自动同步数据");
                // 每隔2秒检测一次 socket.readyState 状态，检测 10 次左右
                // 只要有一次状态是 SR_OPEN 的就调用 [ws.socket send:data] 发送数据
                // 如果 10 次都还是没连上的，那这个发送请求就丢失了，这种情况是服务器的问题了，小概率的
                // 代码有点长，我就写个逻辑在这里好了
                
//            } else if (ws.socket.readyState == SR_CLOSING || ws.socket.readyState == SR_CLOSED) {
//                // websocket 断开了，调用 reConnect 方法重连
//                [ws reConnect:^{
//                    NSLog(@"重连成功，继续发送刚刚的数据");
//                   [ws.socket send:data];
//                }];
//            }
//        } else {
//            NSLog(@"没网络，发送失败，一旦断网 socket 会被我设置 nil 的");
//            NSLog(@"其实最好是发送前判断一下网络状态比较好，我写的有点晦涩，socket==nil来表示断网");
//        }
//    });
//}

- (void)doLeftAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
