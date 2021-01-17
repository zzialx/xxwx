//
//  AppDelegate.m
//  WXSystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "AppDelegate.h"
#import "TR_PushMessageEngine.h"
#import "SoundControlSingle.h"
#import "TR_LoginViewController.h"
#import "TR_NavigationViewController.h"
#import "TR_TabBarViewController.h"


@interface AppDelegate ()<UNUserNotificationCenterDelegate,AMapLocationManagerDelegate>
@property(nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation AppDelegate

+ (AppDelegate *)currentAppdelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    [self configuerIQKeyboard];
    //避免屏幕内多个button被同时点击
    [[UIButton appearance] setExclusiveTouch:YES];
    //注册角标
//    [self configureBadgeRegister:application];
    //定位
    [self configureLocation];
    //友盟配置
    [self configureUMPushSetingWithLaunchOptions:launchOptions];
    
    NSString *string = [NSString stringWithFormat:@"%@", MakeStringNotNil([GVUserDefaults standardUserDefaults].token)];
    if ([string isEqualToString:@""]) {
        TR_LoginViewController *loginVC = [[TR_LoginViewController alloc] initWithNibName:@"TR_LoginViewController" bundle:nil];
        TR_NavigationViewController *navVC = [[TR_NavigationViewController alloc] initWithRootViewController:loginVC];
        navVC.navigationBarHidden = YES;
        loginVC.loginResult = ^(BOOL loginSuccess) {
            if (loginSuccess) {
                TR_TabBarViewController *tabBarController = [TR_TabBarViewController defaultTabBar];
                self.window.rootViewController = tabBarController;
            }
        };
        self.window.rootViewController = navVC;
    }else{
        TR_TabBarViewController *tabBarController = [TR_TabBarViewController defaultTabBar];
        self.window.rootViewController = tabBarController;
    }
    return YES;
}
-(void)alwaysLoaction{
    
    //初始化定位管理器
    self.locationManager = [[AMapLocationManager alloc]init];
    // 设置代理对象
    self.locationManager.delegate = self;
    // 设置反地理编码
    self.locationManager.locatingWithReGeocode = YES;
    //开启持续定位
    [self.locationManager startUpdatingLocation];
    
}
//iOS10以下使用这两个方法接收通知,友盟推送10以下执行前台的是这个方法
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if ([GVUserDefaults standardUserDefaults].soundState) {
        SoundControlSingle * single = [SoundControlSingle sharedInstanceForSound];//获取声音对象
        [single play];
    }
    if ([GVUserDefaults standardUserDefaults].vibrationState) {
        SoundControlSingle * single = [SoundControlSingle sharedInstanceForVibrate]; //获取震动对象
        [single play];
    }
    //关闭U-Push自带的弹出框
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    NSLog(@"userInfo:%@---",userInfo);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
//iOS10以下使用这个方法后台接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"userInf1111o:%@",userInfo);
    if ([GVUserDefaults standardUserDefaults].soundState) {
        SoundControlSingle * single = [SoundControlSingle sharedInstanceForSound];//获取声音对象
        [single play];
    }
    if ([GVUserDefaults standardUserDefaults].vibrationState) {
        SoundControlSingle * single = [SoundControlSingle sharedInstanceForVibrate]; //获取震动对象
        [single play];
    }
    
    [TR_PushMessageEngine sharedHandler].messages = userInfo;
    [[TR_PushMessageEngine sharedHandler] handleReceivedMessage];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    if ([GVUserDefaults standardUserDefaults].soundState) {
        SoundControlSingle * single = [SoundControlSingle sharedInstanceForSound];//获取声音对象
        [single play];
    }
    if ([GVUserDefaults standardUserDefaults].vibrationState) {
        SoundControlSingle * single = [SoundControlSingle sharedInstanceForVibrate]; //获取震动对象
        [single play];
    }
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"userInf1111o:%@",userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionBadge);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    if ([GVUserDefaults standardUserDefaults].soundState) {
        SoundControlSingle * single = [SoundControlSingle sharedInstanceForSound];//获取声音对象
        [single play];
    }
    if ([GVUserDefaults standardUserDefaults].vibrationState) {
        SoundControlSingle * single = [SoundControlSingle sharedInstanceForVibrate]; //获取震动对象
        [single play];
    }
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
    NSLog(@"userInf1111o:%@",userInfo);
    [TR_PushMessageEngine sharedHandler].messages = userInfo;
    [[TR_PushMessageEngine sharedHandler] handleReceivedMessage];
}
- (void)applicationDidBecomeActive:(UIApplication * )application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationSetting" object:self];
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (!(notificationSettings.types & UIUserNotificationTypeBadge)) { //没有设置角标
        NSLog(@"授权失败，引导用户前往设置");
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"deviceToken:%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""]);
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken:%@",hexToken);
    [UMessage registerDeviceToken:deviceToken];
    [GVUserDefaults standardUserDefaults].deviceToken = hexToken;
    //绑定别名
    [UMessage addAlias:hexToken type:@"NLX_ALIAS" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"error -----%@",error);
        NSLog(@"%@",responseObject);
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     [[NSNotificationCenter defaultCenter]postNotificationName:UIApplicationDidEnterBackgroundNotification object:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter]postNotificationName:UIApplicationWillEnterForegroundNotification object:nil];

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)configuerIQKeyboard{
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)configureLocation{
    [AMapServices sharedServices].apiKey = MAP_KEY;
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [self alwaysLoaction];
}
- (void)configureBadgeRegister:(UIApplication*)application{
    //注册角标授权
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge|UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"请求权限成功!");
            }
        }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"%@",settings);
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        // Fallback on earlier versions
    }
}
- (void)configureUMPushSetingWithLaunchOptions:(NSDictionary*)launchOptions{
    //友盟
    [UMConfigure initWithAppkey:UM_KEY channel:@"App Store"];
    [UMessage setBadgeClear:YES];
    [MobClick setScenarioType:E_UM_NORMAL];//支持普通场景
    //打开日志，方便调试
    [UMConfigure setLogEnabled:YES];
    // Push功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound;
    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    if (([[[UIDevice currentDevice] systemVersion]intValue]>=8)&&([[[UIDevice currentDevice] systemVersion]intValue]<10)) {
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"1";
        action1.title=@"打开应用";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"2";
        action2.title=@"忽略";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
        actionCategory1.identifier = @"category1";//这组动作的唯一标示
        [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
        entity.categories=categories;
    }
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"1" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"2" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories = [NSSet setWithObjects:category1_ios10, nil];
        entity.categories=categories;
    }
    
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            
            
        }else{
        }
    }];
}
@end
