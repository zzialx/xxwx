//
//  TR_SearchBar.h
//  WXSystem
//
//  Created by zzialx on 2019/2/13.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^goBack)(void);
typedef void(^searchPerson)(NSString * serchText);
@interface TR_SearchBar : UIView
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property(nonatomic,copy)goBack back;
@property(nonatomic,copy)searchPerson searchPerson;
@end

NS_ASSUME_NONNULL_END
