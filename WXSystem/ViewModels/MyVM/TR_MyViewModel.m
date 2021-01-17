//
//  TR_MyViewModel.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/13.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_MyViewModel.h"

@interface TR_MyViewModel ()

@end

@implementation TR_MyViewModel


+ (instancetype)defaultMyVM
{
    static TR_MyViewModel * _myViewModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _myViewModel = [[self alloc]init];
    });
    return _myViewModel;
}

- (void)getMyDataWithBlock:(BoolBlock)block
{
    WS(weakSelf);
    NSDictionary *parameters = @{};
    [TR_HttpClient postRequestUrlString:POST_FINDUSERINFO withDic:parameters success:^(NSDictionary *requestDic, NSString *msg) {
        if (IsDictionaryClass(requestDic)) {
            weakSelf.userModel = [TR_UserModel yy_modelWithDictionary:requestDic];
               weakSelf.userModel.avatarUrl=[NSString stringWithFormat:@"%@%@",[GVUserDefaults standardUserDefaults].fileUrl,weakSelf.userModel.avatarUrl];
            [[TR_SystemInfo mainSystem] saveUserInfo:weakSelf.userModel];
            BLOCK_EXEC(block,YES, nil);
            NSMutableArray * dataArr = [NSMutableArray arrayWithArray:[GVUserDefaults standardUserDefaults].logoArray];
            NSMutableArray * phoneArr = [NSMutableArray array];
            if (dataArr.count > 0) {
                for (NSData *data in dataArr) {
                    TR_UserModel *locationModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [phoneArr addObject:locationModel];
                }
                __block BOOL isExist = NO;
                [phoneArr enumerateObjectsUsingBlock:^(TR_UserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.mobile isEqualToString: weakSelf.userModel.mobile]) {
                        obj.avatarUrl = weakSelf.userModel.avatarUrl;
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
                        [dataArr replaceObjectAtIndex:idx withObject:data];
                        *stop = YES;
                        isExist = YES;
                    }
                }];
                if (!isExist) {
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.userModel];
                    [dataArr addObject:data];
                }
                [GVUserDefaults standardUserDefaults].logoArray = dataArr;
            } else {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.userModel];
                [dataArr addObject:data];
                [GVUserDefaults standardUserDefaults].logoArray = dataArr;
            }
        }else {
            BLOCK_EXEC(block,NO,msg);
        }
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

- (void)getPersonInfoBlock:(BoolBlock)block{
    [self.infoArray removeAllObjects];
    [self.infoArray addObject:@"头像"];
    [self.infoArray addObject:MakeStringNotNil([TR_SystemInfo mainSystem].userInfo.mobile)];
    BLOCK_EXEC(block,YES, nil);
}
- (void)userLogin:(NSDictionary *)parameter completionBlock:(BoolBlock)block
{
    WS(weakSelf);
    [TR_HttpClient postRequestUrlString:POST_LOGIN withDic:parameter success:^(NSString *request, NSString *msg) {
        [GVUserDefaults standardUserDefaults].token = request;
        [[TR_SystemInfo mainSystem] setLogin:YES];
        [weakSelf getFileUrl];
        [weakSelf getUserInfo];
//        NSString *string = [NSString stringWithFormat:@"%@?token=%@&platform=APP",SOCKET_URL,[GVUserDefaults standardUserDefaults].token];
//        NSLog(@"%@",string);
//        [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:[NSString stringWithFormat:@"%@",string]];//打开soket
        BLOCK_EXEC(block,YES,nil);
    } failure:^(NSString *errorInfo) {
        [[TR_SystemInfo mainSystem] setLogin:NO];
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}
- (void)getFileUrl{
    [self getFileAddressUrl];
}
- (void)getUserInfo
{
    WS(weakSelf);
    NSDictionary *parameters = @{};
    [TR_HttpClient postRequestUrlString:POST_FINDUSERINFO withDic:parameters success:^(NSDictionary *requestDic, NSString *msg) {
        if (IsDictionaryClass(requestDic)) {
            weakSelf.userModel = [TR_UserModel yy_modelWithDictionary:requestDic];
            weakSelf.userModel.avatarUrl=[NSString stringWithFormat:@"%@%@",API_BASE_URL_STRING,weakSelf.userModel.avatarUrl];
            [[TR_SystemInfo mainSystem] saveUserInfo:weakSelf.userModel];
            //绑定别名
            [UMessage addAlias:[GVUserDefaults standardUserDefaults].deviceToken type:@"NLX_ALIAS" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            }];

            NSMutableArray * dataArr = [NSMutableArray arrayWithArray:[GVUserDefaults standardUserDefaults].logoArray];
            NSMutableArray * phoneArr = [NSMutableArray array];
            if (dataArr.count > 0) {
                for (NSData *data in dataArr) {
                    TR_UserModel *locationModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [phoneArr addObject:locationModel];
                }
                __block BOOL isExist = NO;
                [phoneArr enumerateObjectsUsingBlock:^(TR_UserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.mobile isEqualToString: weakSelf.userModel.mobile]) {
                        obj.avatarUrl = weakSelf.userModel.avatarUrl;
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
                        [dataArr replaceObjectAtIndex:idx withObject:data];
                        *stop = YES;
                        isExist = YES;
                    }
                }];
                if (!isExist) {
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.userModel];
                    [dataArr addObject:data];
                }
                [GVUserDefaults standardUserDefaults].logoArray = dataArr;
            } else {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.userModel];
                [dataArr addObject:data];
                [GVUserDefaults standardUserDefaults].logoArray = dataArr;
            }
        }else {
            
        }
    } failure:^(NSString *errorInfo) {
    }];
}
- (void)userLoginOut:(NSDictionary *)parameter completionBlock:(BoolBlock)block
{
    [TR_HttpClient postRequestUrlString:POST_LOGOUT withDic:parameter success:^(NSString *request, NSString *msg) {
        //移除缓存
        [[TR_SystemInfo mainSystem]clearApplicationConfigure];
        [GVUserDefaults standardUserDefaults].token = @"";
        [[TR_SystemInfo mainSystem] setLogin:NO];
        BLOCK_EXEC(block,YES,nil);
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

- (void)resetUserPassword:(NSDictionary *)parameter completionBlock:(BoolBlock)block
{
    [TR_HttpClient postRequestUrlString:POST_FORGETPWD withDic:parameter success:^(NSDictionary *requestDic, NSString *msg) {
        BLOCK_EXEC(block,YES,nil);
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

- (void)getMessageCode:(NSDictionary *)parameter completionBlock:(BoolBlock)block
{
    [TR_HttpClient postRequestUrlString:POST_SHORTMAIL withDic:parameter success:^(NSDictionary *requestDic, NSString *msg) {
        BLOCK_EXEC(block,YES,nil);
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}
- (void)getPhoneCode:(NSDictionary *)parameter completionBlock:(BoolBlock)block{
    [TR_HttpClient postRequestUrlString:POST_PHONECODE withDic:parameter success:^(NSDictionary *requestDic, NSString *msg) {
        BLOCK_EXEC(block,YES,nil);
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

- (void)checkMessageCode:(NSDictionary *)parameter completionBlock:(BoolBlock)block
{
    [TR_HttpClient postRequestUrlString:POST_CHECKSHORTMAIL withDic:parameter success:^(NSDictionary *requestDic, NSString *msg) {
        BLOCK_EXEC(block,YES,nil);
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

- (void)userVersion:(NSDictionary *)parameter completionBlock:(BoolBlock)block
{
    WS(weakSelf);
    [TR_HttpClient postRequestUrlString:POST_VERSION withDic:parameter success:^(NSDictionary *requestDic, NSString *msg) {
        if (IsDictionaryClass(requestDic)) {
            weakSelf.versionModel = [TR_VersionModel yy_modelWithDictionary:requestDic];
//            BOOL update = [weakSelf compareVesionWithServerVersion:weakSelf.versionModel.versionCode];
            if ([weakSelf.versionModel.versionRule isEqualToString:@"0"]){
                  BLOCK_EXEC(block,NO,nil);
            } else {
                  BLOCK_EXEC(block,YES,nil);
            }
        }else {
            BLOCK_EXEC(block,NO,nil);
        }
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

- (void)modifyUserPassword:(NSDictionary *)parameter completionBlock:(BoolBlock)block
{
    [TR_HttpClient postRequestUrlString:POST_UPDATEPWD withDic:parameter success:^(NSDictionary *requestDic, NSString *msg) {
        BLOCK_EXEC(block,YES,nil);
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

- (void)uploadImage:(NSArray *)array completionBlock:(DictionaryBlock)block
{
    [TR_HttpClient upLoadImageArrayWithUrlString:POST_UPLOAD withDic:nil imageArray:array upLoadProgress:^(float progress) {
    } success:^(id requestDic, NSString *msg) {
        BLOCK_EXEC(block,requestDic,nil);
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,nil,errorInfo);
    }];
}

- (void)updateUserinfoPhone:(NSDictionary*)parameters completionBlock:(BoolBlock)block{
    [TR_HttpClient postRequestUrlString:POST_APP_UPDATE_PHOE withDic:parameters success:^(NSDictionary *requestDic, NSString *msg) {
        BLOCK_EXEC(block,YES, nil);
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO, errorInfo);
    }];
}

- (void)updateUserinfo:(NSDictionary*)parameters isHeadImg:(BOOL)isHeadImg completionBlock:(BoolBlock)block{
    [TR_HttpClient postRequestUrlString:POST_APP_UPHEAD withDic:parameters success:^(NSDictionary *requestDic, NSString *msg) {
        if ([msg isEqualToString:@"已保存"]) {
            BLOCK_EXEC(block,YES, msg);
        }
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO, errorInfo);
    }];
}

-(BOOL)compareVesionWithServerVersion:(NSString *)version{
    
    NSArray *versionArray = [version componentsSeparatedByString:@"."];//服务器返回版
    NSArray *currentVesionArray = [kBundleVersionString componentsSeparatedByString:@"."];//当前版本
    NSInteger a = (versionArray.count> currentVesionArray.count)?currentVesionArray.count : versionArray.count;
    for (int i = 0; i< a; i++) {
        
        NSInteger a = [[versionArray objectAtIndex:i] integerValue];
        
        NSInteger b = [[currentVesionArray objectAtIndex:i] integerValue];
        
        if (a > b) {
            NSLog(@"有新版本");
            return YES;
        }else if(a < b){
            return NO;
        }
    }
    return NO;
}

- (NSMutableArray *)titleArray
{
    if (IsNilOrNull(_titleArray)) {
        NSArray *accountArray =  @[@"账户与安全",@"新信息通知"];
        NSArray *aboutArray =  @[@"关于",@"清除缓存"];
        _titleArray = [NSMutableArray arrayWithArray:@[accountArray,aboutArray]];
    }
    return _titleArray;
}

- (NSArray *)sectionTitleArray
{
    if (IsNilOrNull(_sectionTitleArray)) {
        _sectionTitleArray = @[@"应用未打开时",@"应用打开时"];
    }
    return _sectionTitleArray;
}
- (NSArray*)infoHeadArray{
    if (IsNilOrNull(_infoHeadArray)) {
        _infoHeadArray =@[@"头像",@"手机号",@"工作邮箱",@"座机",@"组织",@"部门",@"职务/职级"];
    }
    return _infoHeadArray;
}

- (NSArray*)personArray{
    if (IsNilOrNull(_personArray)) {
        _personArray =@[@"头像",@"姓名",@"性别"];
    }
    return _personArray;
}
- (void)settingWithBlock:(VoidBlock)block
{
   
}
- (void)getAppSetMessageCompletionBlock:(BoolBlock)block{
    NSDictionary *normarlArray = @{@"section": @(TR_SettingSectionTypeNotice),
                                   @"row"    : @[@(TR_SettingRowTypeNotice)]};
    NSDictionary *recommendArray = @{@"section": @(TR_SettingSectionTypeSound),
                                     @"row"    : @[@(TR_SettingRowTypeSound),
                                                   @(TR_SettingRowTypeVibration)]};
    self.settingArray = [NSMutableArray arrayWithArray:@[normarlArray,recommendArray]];
    NSDictionary * parameter = @{};
    [TR_HttpClient postRequestUrlString:POST_SET withDic:parameter success:^(NSDictionary *requestDic, NSString *msg) {
        self.setModel = [TR_SetModel yy_modelWithJSON:requestDic];
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO, errorInfo);
    }];
}
- (void)updateSetInfo:(NSDictionary*)parameter completionBlock:(BoolBlock)block{
    [TR_HttpClient postRequestUrlString:POST_SAVE_SET withDic:parameter success:^(NSDictionary *requestDic, NSString *msg) {
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO, errorInfo);
    }];
}
- (void)getFileAddressUrl{
    [TR_HttpClient postRequestUrlString:POST_FILEURL withDic:@{} success:^(NSDictionary *requestDic, NSString *msg) {
        [GVUserDefaults standardUserDefaults].fileUrl =(NSString*) requestDic;
    } failure:^(NSString *errorInfo) {
        
    }];
}


- (TR_UserModel*)userModel{
    if (IsNilOrNull(_userModel)) {
        _userModel = [[TR_UserModel alloc]init];
    }
    return _userModel;
}
@end
