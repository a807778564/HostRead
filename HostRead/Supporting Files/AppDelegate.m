//
//  AppDelegate.m
//  HostRead
//
//  Created by huangrensheng on 16/8/22.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "AppDelegate.h"
#import "HRRedListController.h"
#import "HRSsettingController.h"
#import "HRRecentController.h"
#import "HRTouchPassWordController.h"

#define tabCount 3

@interface AppDelegate ()<MBProgressHUDDelegate>
@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation AppDelegate

+ (AppDelegate *)sharedDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [[NSUserDefaults standardUserDefaults] setFloat:16.0 forKey:@"FontSize"];//默认字体

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];//默认阅读模式
        [dic setValue:RGBA(159,223,176,1) forKey:@"readBack"];//黑色字体
        [dic setValue:RGBA(34, 34, 34, 1) forKey:@"contentColor"];//背景
        [dic setValue:[UIColor whiteColor] forKey:@"nav_title_color"];//导航栏字体颜色
        [dic setValue:mainColor forKey:@"nav_back_color"];//导航栏背景
        NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [[NSUserDefaults standardUserDefaults] setValue:personEncodedObject forKey:@"ReadStyle"];
        [[HRReadTool shareInstance] writeToFileWithTxt:@"在这个世界上的每一个人，无论男女，无论年龄都渴望的成功，都对未来有一定的期许和梦想。但是经常会在学习的困难中迷茫，遇到一些什么挫折就完全不知道该怎么做，也不知道未来该如何走，所以经常找不到突破这种困惑的方法。其实在我看来，这完全是因为很多人都没有认真的思考都没有用智慧来学习。\n其实学习本身就是件苦燥的事情，所以我们并不能墨守成规，而是应该去不断创造，不断的思考，不断的去领悟，从学习中找到兴趣，从学习中找到技巧。从古至今，很多能够成就大事业的人都往往能够在某一件事情或者学习方法中留意到特别的东西，用自己独特的见解，思维模式去理解，去消化，最后去运用。即便是吃饭，你也得一口一口嚼，不是直接吞下去，所以好的学习方法才能够让事情变得更加简单。曾经有一个化学家，在面对分子结构这一件事情的时候，以当时的知识理论完全不能够解释，但是本着对这项工作的态度以及自己的独特见解，提出了杂化轨道理论，从不同的角度分析研究了电子运动并且解释了这个事情，从而推动了化学事业的进步，为此做出卓越的贡献，获得诺贝尔奖。\n所以，无论是在什么时候，生活中也好，工作中也好，我们都要拥有自己思维方式。对待问题的态度和学习的时候，要真正剖析真正的去理解。我记得以前在上课的时候，很多人对于政治这门课，往往觉得内容枯燥乏味，很多的知识点也非常难记，更别说理解，所以导致记不住，考试的时候成绩低。而我在当时，学习政治的时候，我是非常喜欢的，因为我将它和其它的知识点结合来记，里面涉及到了很多的人物，更是涉及到了很多的历史，这些都是我喜欢的知识结构，所以我经常把它们结合在一起来理解，所以我对于政治也是非常热爱的，考试的时候分数也比较高。在这里我想说的是，学习的时候千万不要死记硬背，千万不要把每一个知识点，每一个字强行的往脑袋里面塞，因为这样的方法是错误的，我们要真正的去理解它，因为每一个成功都不是偶然的。\n所以在很多的时候，你如果拥有了独特的思维方式，独特见解。并且苦心钻研，去把它消化，变成自己实用的东西，你就会把自己的短板变成长板，劣势变成优势。在我们的生活中，经常会看到这样一种人，他们总是会游刃有余的处理好自己的任何事情，而在某些方面也有所成就，无时无刻都非常淡定，这个时候我们就会非常羡慕这个人的为人处事方法以及他的冷静。但是我们要知道，这种人并不是天生就如此，他们只是懂得用智慧的方式去处理自己的每一件事情。那我们要做的是首先要认识自己，包括自己的习惯，能力，理解以及记忆方式，对自己有了一个足够的了解之后你才能去更加的规划和给自己定位，更加的制定高效的学习计划。\n在我看来，在上学的时候，那些学习成绩比较好的同学其实也不一定就全部都是聪明人，只不过他们在学习的道路上比我们更走的更加的远，因为他们知道如何利用自己的智慧来学习，但是这并不等同于聪明，智慧其实是让自己处理事情更加的圆润，更加的快速，更加的合理，把这一切能够运用东西为自己所用，成为自己的一个技能。所以无论是你生活也好，工作也好，工作也好，让我们用智慧创造人生，创造成功吧。"];
    }else{
        
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    UITabBarController *rootController = [self createViewControllers];
    HRRedListController *list = [[HRRedListController alloc] init];
    UINavigationController *navgation = [[UINavigationController alloc] initWithRootViewController:list];
    self.window.rootViewController = navgation;
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [[self colorDic] valueForKey:@"nav_back_color"];

    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageWithColor:[UIColor whiteColor] Size:CGSizeMake([[UIScreen mainScreen] bounds].size.width/tabCount, 49) Alpha:0.2]];
    //tab 字体颜色 00bb9c
    return YES;
}

- (NSMutableDictionary *)colorDic{
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"ReadStyle"];
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dic;
}

- (void)showPassView{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"appPass"]) {
//        NSLog(@"------------------------%@",[self getPresentedViewController]);
        if (![[self getPresentedViewController] isKindOfClass:[HRTouchPassWordController class]]) {
            HRTouchPassWordController *list = [[HRTouchPassWordController alloc] init];
            [[self getPresentedViewController] presentViewController:list animated:NO completion:nil];
        }
    }
}

- (UIViewController *)getPresentedViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (UITabBarController *)createViewControllers{
    
    UITabBarController *tabController = [[UITabBarController alloc] init];
    
    //    UINavigationController *navgation = [[UINavigationController alloc] initWithRootViewController:tabController];
    
    HRRedListController *list = [[HRRedListController alloc] init];
    list.tabBarItem = [self createTabBarItemWith:@"全部" image:@"tab_all" selectedImage:@"tab_all"];
    
    HRRecentController *recent = [[HRRecentController alloc] init];
    recent.tabBarItem = [self createTabBarItemWith:@"最近" image:@"tab_times" selectedImage:@"tab_times"];
    
    HRSsettingController *setting = [[HRSsettingController alloc] init];//tab_setting
    setting.tabBarItem = [self createTabBarItemWith:@"设置" image:@"tab_setting" selectedImage:@"tab_setting"];
    
    tabController.viewControllers = @[[self getNewController:list],[self getNewController:recent],[self getNewController:setting]];
    UIView *bgView = [[UIView alloc] initWithFrame:tabController.tabBar.bounds];
    bgView.backgroundColor = mainColor;
    [tabController.tabBar insertSubview:bgView atIndex:0];
    tabController.tabBar.opaque = YES;
    //    tabController.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    return tabController;
    
}

- (UINavigationController *)getNewController:(UIViewController *)cont{
    UINavigationController *navgation = [[UINavigationController alloc] initWithRootViewController:cont];
    return navgation;
}

- (UITabBarItem *)createTabBarItemWith:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImage{
    UITabBarItem *tabbarItem = [[UITabBarItem alloc] initWithTitle:title image:[self doFormatImage:imageName] selectedImage:[self doFormatImage:selectedImage]];
    [tabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,nil] forState:UIControlStateNormal];
    [tabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,nil] forState:UIControlStateSelected];
    [tabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];

    return tabbarItem;
    
}

// 去掉默认的选中蓝光
- (UIImage *)doFormatImage:(NSString *)_name{
    UIImage *image = [UIImage imageNamed:_name];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

- (void)showTextOnly:(NSString *)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = msg;
    hud.detailsLabelFont = [UIFont systemFontOfSize:12];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}

- (void)showLoadingHUD:(NSString *)msg{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.labelText = msg;
    [self.window addSubview:self.HUD];
    self.HUD.color = RGBA(104, 104, 104, .7f);
    self.HUD.delegate = self;
    self.HUD.labelFont = [UIFont systemFontOfSize:12];
    [self.HUD show:YES];
}

- (void)hidHUD{
    [self.HUD hide:YES];
}

#pragma mark - hud delegate
- (void)hudWasHidden:(MBProgressHUD *)_hud {
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
{
    if (self.window) {
        if (url) {
            NSString *fileNameStr = [url lastPathComponent];
            NSString *Doc = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/copy"] stringByAppendingPathComponent:fileNameStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [data writeToFile:Doc atomically:YES];
//            [XCHUDTool showOKHud:@"文件已存到本地文件夹内" delay:2.0f];
            NSLog(@"文件已存到本地文件夹内");
        }
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveReadSlider" object:nil];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self showPassView];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
