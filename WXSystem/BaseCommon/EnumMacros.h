//
//  EnumMacros.h
//  Traceability
//
//  Created by candy.chen on 2019/2/12.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#ifndef EnumMacros_h
#define EnumMacros_h

typedef NS_ENUM(NSInteger, TR_DataLoadingType) {
    TR_DataLoadingTypeRefresh = 1,  //刷新数据
    TR_DataLoadingTypeInfinite = 2, //下一页数据
};

typedef NS_ENUM(NSInteger, ScrollViewLoadingState) {
    ScrollViewLoadingState_Idle       = -1,
    ScrollViewLoadingState_LoadingNew = 0,
    ScrollViewLoadingState_LoadingMore
};

//LOADING
typedef NS_ENUM(NSInteger, SHGProgressHUDType)
{
    SHGProgressHUDTypeNormal = 0,
    SHGProgressHUDTypeGray
};

//推送类型和banner跳转类型
typedef NS_ENUM (NSInteger, TR_JumpType){
    TR_JumpTypeH5 = 0,//H5
    TR_JumpTypeNotice,//公告
    TR_JumpTypeApprove,//审批
    TR_JumpTypeChat,//单聊
    TR_JumpTypeGroup,//群聊
    TR_JumpTypeWorkUp,//上班打卡
    TR_JumpTypeWorkDown,//下班打卡
    TR_JumpTypeMissCardUp,//上班缺卡
    TR_JumpTypeMissCardDown,//下班缺卡
    TR_JumpTypeWithdrawApprove,//审批撤回
};

typedef NS_ENUM(NSInteger,NO_DATATYPE){
    NO_DATATYPE_NODATA = 0,
    NO_DATATYPE_NOMESSAGE,
    NO_DATATYPE_NOAPPMESSAGE,
     NO_DATATYPE_NOSEARCH ,
    NO_DATATYPE_NETERROR,
    NO_DATATYPE_ERROR,
};

// 请求方式
typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeGet = 0,
    RequestTypePost,
    RequestTypeUpLoad,
    RequestTypeUpArrayLoad,
    RequestTypeDownload
};

typedef NS_ENUM(NSInteger, TR_SettingSectionType)
{
    TR_SettingSectionTypeNotice = 100,
    TR_SettingSectionTypeShowNotice,
    TR_SettingSectionTypeNull,
    TR_SettingSectionTypeSound,
};

typedef NS_ENUM(NSInteger, TR_SettingRowType)
{
    TR_SettingRowTypeNotice = 200,
    TR_SettingRowTypeShowNotice,
    TR_SettingRowTypeSound,
    TR_SettingRowTypeVibration,
};

typedef NS_ENUM (NSInteger, TR_PERSON_CHANGE_TYPE){
    TR_PERSON_CHANGE_NAME = 0,///<名字
    TR_PERSON_CHANGE_SEX,///<性别
    TR_PERSON_CHANGE_LANDLINE,///<座机
    TR_PERSON_CHANGE_EMAIL,///<邮箱
    TR_PERSON_CHANGE_PHONE,///<手机
};

typedef NS_ENUM(NSInteger,TR_SELECT_TYPE) {
    TR_SELECT_TYPE_RADIO = 0,///<人员单选
    TR_SELECT_TYPE_MULTI,///<人员多选
    TR_SELECT_TYPE_ORG_MULTI,///<部门多选
};


typedef NS_ENUM(NSInteger, TR_DocmentDownloadStatus) {
    TR_DocmentNotDownload = 0,
    TR_DocmentDownloading = 1,
    TR_DocmentPause = 2,
    TR_DocmentDownloaded = 3,
    TR_DocmentUpdated = 4,
    TR_DocmentUnzip = 5,
};

typedef NS_ENUM(NSInteger,TR_DARPARTMENTHEAD_TYPE) {
    TR_DARPARTMENTHEAD_TYPE_ONE = 0,
    TR_DARPARTMENTHEAD_TYPE_MORE,
    TR_DARPARTMENTHEAD_TYPE_SEARCH,
};

typedef NS_ENUM(NSInteger,TR_APPROVE_TYPE) {
    TR_APPROVE_TYPE_DEFALT=0,
    TR_APPROVE_TYPE_ONE=1,
     TR_APPROVE_TYPE_TWO=2,
    TR_APPROVE_TYPE_MORE=3,
};
typedef NS_ENUM(NSInteger,TR_APPROVELIST_TYPE) {
    TR_APPROVELIST_TYPE_WIAT = 0,//待审批
    TR_APPROVELIST_TYPE_APPROVED,//已审批
    TR_APPROVELIST_TYPE_MINE,//我发起的
    TR_APPROVELIST_TYPE_CC,//抄送我的
    TR_APPROVELIST_TYPE_DB,//草稿箱
};
typedef NS_ENUM(NSInteger,TR_FORMFOOT_TYPE) {
    TR_FORMFOOT_TYPE_AGREENANDDISAGREEN =0,///<同意和驳回
    TR_FORMFOOT_TYPE_AGAINCOMMIT,///<重新提交
    TR_FORMFOOT_TYPE_CUIBANANDUNDO,///<催办和撤销
    TR_FORMFOOT_TYPE_NONEFOOT,///<无审批按钮
    TR_FORMFOOT_TYPE_CUIBAN,///<催办 撤销不可点击
    TR_FORMFOOT_TYPE_DELETEEDIT,///<删除编辑
};
typedef NS_ENUM(NSInteger,TR_CARD_TYPE){
    TR_CARD_TYPE_FORMAL = 0,///<异常
    TR_CARD_TYPE_OUTWORk,///<外勤
     TR_CARD_TYPE_OUTWORk_LATER,///<外勤迟到
    TR_CARD_TYPE_OUTWORk_EARLY,///<外勤早退

};

typedef NS_ENUM(NSInteger, Card_State) {
    Card_State_Morning                 = 1,///<上午未打卡
    Carded_State_Morning             = 2,///<上午已打卡
    Card_State_Afternoon             = 3,///<下午未打卡显示打卡按钮
    Carded_State_Afternoon          = 4,///<下午已打卡
    Card_State_Afternoon_No       = 5,///<未到下午卡
    Card_State_Lack_Morning        = 6,///<上午缺卡
    Card_State_Lack_Afternoon     = 7,///<下午缺卡
    Card_State_Morning_later        = 8,///<上午迟到
    Card_State_Afternoon_zaotui        = 9,///<下午早退
    
};
typedef NS_ENUM(NSInteger,SignCard_Type){
    SignCard_Morning_Normal        = 0,///<正常
    SignCard_Morning_Later           = 1,///<迟到
    SignCard_Morning_Lack           = 2,///<缺卡
    SignCard_Afternoon_Normal    =3,///<下午正常
    SignCard_Afternoon_Early       = 4,///<早退
    SignCard_Afternoon_Lack       = 5,///<下午打卡
    SignCard_Afternoon_No          = 6,///<下午不到打卡时间
};

typedef NS_ENUM(NSInteger,DailyBtnType) {
    DailyBtnType_See=0,///<查看人员信息
    DailyBtnType_Dele,///<删除选中人员
    DailyBtnType_Add,///<添加人员
    DailyBtnType_StartTime,///<开始时间
    DailyBtnType_EndTime,///<结束时间
    DailyBtnType_Clear,///<清空选中
    DailyBtnType_Confirm,///<确定选择
};
typedef void(^clickDailyAction)(DailyBtnType btnType,NSString*userId);
//首页点击
typedef NS_ENUM(NSInteger,OrderType) {
    OrderType_Receive=0,///<待我接单
    OrderType_Service=1,///<待我服务
    OrderType_Finish=2,///<待我完成
    OrderType_OutTime=3,///<逾期工单
};
typedef void(^clickHomeItem)(OrderType type);


typedef NS_ENUM(NSInteger,RepairBtnType) {
    RepairBtnType_Address=0,
    RepairBtnType_Phone=1,
};

typedef NS_ENUM(NSInteger,RepairOD_Type) {
    RepairOD_Type_Wait_Receive = 0,///<待接单
    RepairOD_Type_Wait_Service = 1,///<待服务
    RepairOD_Type_In_Service =2,///<服务中
    RepairOD_Type_Wait_Visit=3,///<待回访
    RepairOD_Type_Finish=4,///<已完成
    RepairOD_Type_Cancle,///<已取消
};
typedef NS_ENUM(NSInteger,Repair_Foot_Type) {
    Repair_Foot_Type_Recive = 0,///<接收工单
    Repair_Foot_Type_Start = 1,///<开始服务
    Repair_Foot_Type_Equ = 2,///<补充设备信息
    Repair_Foot_Type_Pro = 3,///<添加服务进度
    Repair_Foot_Type_Leavel = 4,///<留言
    Repair_Foot_Type_Cancle = 5,///<查看取消原因
};
//查看大图
typedef void(^showBigPic)(NSInteger index);
//公单详情VC刷新数据
typedef void(^reloadVC)(void);

#endif /* EnumMacros_h */
