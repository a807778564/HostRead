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
        [dic setValue:[UIColor blackColor] forKey:@"readBack"];//黑色字体
        [dic setValue:[UIColor whiteColor] forKey:@"contentColor"];//背景
        NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [[NSUserDefaults standardUserDefaults] setValue:personEncodedObject forKey:@"ReadStyle"];
    }else{

    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UITabBarController *rootController = [self createViewControllers];
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];
    
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageWithColor:[UIColor whiteColor] Size:CGSizeMake([[UIScreen mainScreen] bounds].size.width/tabCount, 49) Alpha:0.2]];
    //tab 字体颜色 00bb9c
    return YES;
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
