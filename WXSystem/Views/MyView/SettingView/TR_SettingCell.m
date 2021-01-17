//
//  TR_SettingCell.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_SettingCell.h"
@interface TR_SettingCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;

@end

@implementation TR_SettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)bindViewModel:(TR_MyViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath
{
    TR_MyViewModel *settingModel = (TR_MyViewModel *)viewModel;
    
    NSArray *rowArray = [settingModel.settingArray[indexPath.section] objectForKey:@"row"];
    TR_SettingRowType rowType = [rowArray[indexPath.row] integerValue];
   
    switch (rowType) {
        case TR_SettingRowTypeNotice: {
            self.titleLabel.text = @"新消息通知";
            if ([self notificationSettingsOrNot]) {
                self.openSwitch.on = viewModel.setModel.msgFlag.boolValue;
                [GVUserDefaults standardUserDefaults].noticeState = viewModel.setModel.msgFlag.boolValue;
//                self.openSwitch.userInteractionEnabled=YES;
            }else{
                self.openSwitch.on = NO;
                [GVUserDefaults standardUserDefaults].noticeState = NO;
//                self.openSwitch.userInteractionEnabled=NO;
//                self.openSwitch.onImage=[UIImage imageNamed:@"switch_select"];
            }
            self.openSwitch.tag = TR_SettingRowTypeNotice;
            [self.openSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        }
            break;
        case TR_SettingRowTypeSound: {
            self.titleLabel.text = @"声音";
            self.openSwitch.on= viewModel.setModel.voiceFlag.boolValue;
            [GVUserDefaults standardUserDefaults].soundState = viewModel.setModel.voiceFlag.boolValue;
            self.openSwitch.tag = TR_SettingRowTypeSound;
            [self.openSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        }
            break;
        case TR_SettingRowTypeVibration: {
            self.titleLabel.text = @"震动";
            self.openSwitch.on= viewModel.setModel.shockFlag.boolValue;
            [GVUserDefaults standardUserDefaults].vibrationState  = viewModel.setModel.shockFlag.boolValue;
            self.openSwitch.tag = TR_SettingRowTypeVibration;
            [self.openSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        }
            break;
            
        default:
            break;
    }
}

//选择了开关
-(void)switchChange:(UISwitch *)switchStatus{
    switch (switchStatus.tag) {
        case TR_SettingRowTypeNotice:{
            if ([self notificationSettingsOrNot]){
                if (!switchStatus.on) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"关闭后，手机不再接收新消息通知" preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction *action1= [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [self updateSetOpen:switchStatus.on withType:TR_SettingRowTypeNotice];
                    }];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        self.openSwitch.on=YES;
                    }];
                    [alertController addAction:action1];
                    [alertController addAction:action2];
                    [action2 setValue:UICOLOR_RGBA(180, 180, 180) forKey:@"titleTextColor"];
                    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
                    [[self viewController] presentViewController:alertController animated:YES completion:nil];
                }else{
                    [self updateSetOpen:switchStatus.on withType:TR_SettingRowTypeNotice];
                }
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"开启消息通知" message:@"开启消息通知\n及时处理工作消息" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    switchStatus.on = 0;
                    [GVUserDefaults standardUserDefaults].noticeState = NO;
                }];
                [alertController addAction:action];
                
                UIAlertAction *actionDelete = [UIAlertAction actionWithTitle:@"前往开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self getSet];
                }];
                [alertController addAction:actionDelete];
                alertController.modalPresentationStyle = UIModalPresentationFullScreen;
                [[self viewController] presentViewController:alertController animated:YES completion:nil];
            }
        }
            break;
        case TR_SettingRowTypeSound:{
            [self updateSetOpen:switchStatus.on withType:TR_SettingRowTypeSound];
        }
            break;
        case TR_SettingRowTypeVibration:{
            [self updateSetOpen:switchStatus.on withType:TR_SettingRowTypeVibration];
        }
            break;
        default:
            break;
    }
}
- (void)updateSetOpen:(BOOL)Open withType:(TR_SettingRowType)type{
    NSString * settingType = @"";
    if (type==TR_SettingRowTypeNotice) {
        settingType = @"0";
    }if (type==TR_SettingRowTypeSound) {
        settingType = @"1";
    }if (type==TR_SettingRowTypeVibration) {
        settingType = @"2";
    }
    NSString * settingFlag = Open?@"1":@"0";
    NSDictionary * paramet = @{@"settingType":settingType,@"settingFlag":settingFlag};
    TR_MyViewModel * setModel = [[TR_MyViewModel alloc]init];
    WS(weakSelf);
    [setModel updateSetInfo:paramet completionBlock:^(BOOL flag, NSString *error) {
        if (!flag) {
            weakSelf.openSwitch.on = !weakSelf.openSwitch.on;
            if (type==TR_SettingRowTypeNotice) {
                [GVUserDefaults standardUserDefaults].noticeState = weakSelf.openSwitch.on;
            }if (type==TR_SettingRowTypeSound) {
                 [GVUserDefaults standardUserDefaults].soundState = weakSelf.openSwitch.on;
            }if (type==TR_SettingRowTypeVibration) {
               [GVUserDefaults standardUserDefaults].vibrationState = weakSelf.openSwitch.on;
            }
        }
    }];
}
#pragma mark --跳转到系统设置修改通知
-(void)getSet{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark --判断系统通知是否开启
-(BOOL)notificationSettingsOrNot{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        NSLog(@"%ld",setting.types);
        if (UIUserNotificationTypeNone == setting.types) {
            NSLog(@"推送关闭");
            return NO;
        }else{
            NSLog(@"推送打开");
            return YES;
        }
    }else{
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone == type){
            NSLog(@"推送关闭");
            return NO;
        }else{
            NSLog(@"推送打开");
            return YES;
        }
    }
}


@end
