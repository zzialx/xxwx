//
//  TR_PersonModel.h
//  WXSystem
//
//  Created by zzialx on 2019/2/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_Model.h"
NS_ASSUME_NONNULL_BEGIN

@interface TR_PersonModel : TR_Model
@property(nonatomic,copy)NSString * birthDay;
@property(nonatomic,copy)NSString * createTime;
@property(nonatomic,copy)NSString * creator;
@property(nonatomic,copy)NSString * duties;///<职务
@property(nonatomic,copy)NSString * email;
@property(nonatomic,copy)NSString * joinTime;
@property(nonatomic,copy)NSString * lineTelephone;
@property(nonatomic,copy)NSString * logo;
@property(nonatomic,copy)NSString * realName;
@property(nonatomic,copy)NSString * sex;
@property(nonatomic,copy)NSString * telephone;
@property(nonatomic,copy)NSString * userCode;
@property(nonatomic,copy)NSString * userName;
@property(nonatomic,copy)NSString * status;
@property(nonatomic,copy)NSString * pinyin;
@property(nonatomic,copy)NSString * userId;

@end

@interface TR_SearchPersonModel : TR_Model
@property(nonatomic,copy)NSString * logo;
@property(nonatomic,copy)NSString * orgName;
@property(nonatomic,copy)NSString * userId;
@property(nonatomic,copy)NSString * userName;
@property(nonatomic,assign)BOOL isSelect;///<已经被选中
//@property(nonatomic,copy)NSString * pcode;///<父节点code
//@property(nonatomic,copy)NSString * aid;///<用户id
//@property(nonatomic,copy)NSString *unid;
@end
NS_ASSUME_NONNULL_END
