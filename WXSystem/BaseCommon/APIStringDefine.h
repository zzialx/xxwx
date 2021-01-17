//
//  APIStringDefine.h
//  Traceability
//
//  Created by candy.chen on 2019/2/12.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#ifndef APIStringDefine_h
#define APIStringDefine_h

//正式环境
//#define API_BASE_URL_STRING                        @"http://oa.newlixon.com:5001/"
//#define WEB_URL                                    @"http://oa.newlixon.com:8000/"
//#define SOCKET_URL                                 @"ws://oa.newlixon.com:5001/ims"


//测试环境

#define API_BASE_URL_STRING                        @"http://192.168.2.93:8080"
#define WEB_URL                                                 @"http://192.168.10.152:8113/"

//联调环境
//#define API_BASE_URL_STRING                        @"http://192.168.2.12:8080"
//#define WEB_URL                                    @"http://192.168.10.152:8113/"
//#define SOCKET_URL                                 @"ws://36.152.34.20:5001/ims"

/**
 我的页面相关接口
*/
#define POST_LOGIN                              @"/app/login" //登录接口
#define POST_FINDUSERINFO              @"/app/my/personal-info" //查看相关用户信息 //个人信息
#define POST_UPLOAD                            @"/app/upload" //通用的上传文件接口
#define POST_APP_UPHEAD                    @"/app/my/modify-avatar"//更新用户头像
#define POST_LOGOUT                            @"/app/logout" //登出
#define POST_SHORTMAIL                     @"/app/my/verification-code/get" //更换手机号发送短信验证码
#define POST_APP_UPDATE_PHOE          @"/app/my/replace-mobile"//用户修改手机
#define POST_UPDATEPWD                      @"/app/my/modify-password" //用户修改密码
#define POST_PHONECODE                      @"/app/verification-code/get" //忘记密码获取验证码
#define POST_CHECKSHORTMAIL            @"/app/verification-code/check" //校验短信验证码
#define POST_FORGETPWD                       @"/app/forget-reset-pass" //忘记密码接口
#define POST_SET                                       @"/app/my/setting/get" //设置相关
#define POST_SAVE_SET                              @"/app/my/setting/save" //设置保存
#define POST_FILEURL                               @"/app/serverUrl" //获取文件服务器地址
#define POST_UPLOAD_AREA                     @"/app/reportingPosition" //上传经纬度


//首页相关
#define POST_HOME_COUNT                     @"/app/indexCount"
#define POST_HOME_LIST                              @"/app/indexOrderList"///<首页统计列表
#define POST_HOME_LIST_SEARCH                @"/app/indexOrderListSearch"///<首页统计列表搜索
#define POST_ORDER_LIST_SEARCH                @"/app/search"///<搜索

//工单详情
#define POST_DETIAL                                           @"/app/orderInfo"///<工单详情
#define POST_DETIAL_RECEIVE                         @"/app/receiptOrder"///<接受工单
#define POST_DETIAL_EUMENT                          @"/app/equipmentInfo"///<设备详情
#define POST_DETIAL_SERVICE                          @"/app/startServiceOrder"///<开始服务
#define POST_DETIAL_ADD_EQU                         @"/app/addEquipmentInfo"///<添加设备
#define POST_DETIAL_ADD_LEAMSG                        @"/app/addOrderMessageInfo"///<添加留言
#define POST_DETIAL_LSG_LIST                          @"/app/orderMessageList" ///<留言列表
#define POST_DETIAL_LSG_INFO                         @"/app/orderMessageInfo"///<留言详情
#define POST_DETIAL_SAVE_PGR                             @"/app/saveEndService" ///<保存进度
#define POST_DETIAL_PGR_LIST                            @"/app/showProcessList"///<服务进度列表
#define POST_DETIAL_PGR_INFO                            @"/app/showProcessInfo"///<进度详情
#define POST_DETIAL_PGR_DRAFT                            @"/app/showSaveEndService"///<草稿编辑进度详情
#define POST_DETIAL_PGR_FINISH                            @"/app/endService"///<完成服务
#define POST_DETIAL_LOG_LIST                                @"/app/orderLogList"///<日志列表
#define POST_DETIAL_VISIT_LIST                                @"/app/showVisitInfo"///<回访列表
#define POST_DETIAL_AREA_LIST                                @"/app/getAreaList"///<地址列表
#define POST_DETIAL_CANCLE                                      @"/app/showCancelInfo" ///<取消工单详情


//工单模块
#define POST_ORDER_HEAD                                 @"/app/orderCountList"///<工单统计列表
#define POST_ORDER_LIST                                     @"/app/orderList"///<工单统计列表


#define POST_USERINFO                @"oabase/login/userInfo" //用户信息获取接口
#define POST_UPDATEUSERINFO          @"oabase/user/updateuserInfo" //修改相关用户信息
#define POST_VERSION                 @"/app/latest-version" //查询APP最新版本信息接口



#define CHECK_TOKENSTATUS            @"oabase/login/getTokenStatus"  //查看token状态




#endif /* APIStringDefine_h */




