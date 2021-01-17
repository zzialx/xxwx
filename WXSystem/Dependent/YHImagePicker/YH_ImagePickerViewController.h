//
//  YH_ImagePickerViewController.h
//  YH_Mall
//
//  Created by candy.chen on 18/9/13.
//  Copyright (c) 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetHelper.h"
#import "YH_ImagePickerConstants.h"

@protocol YHImagePickerControllerDelegate;

@interface YH_ImagePickerViewController : UIViewController

//
@property (weak, nonatomic) id<YHImagePickerControllerDelegate> delegate;

@property (assign, nonatomic) NSInteger nMaxCount; // -1 : no limit

@property (assign, nonatomic) NSInteger nInitCount; // [0, nMaxCount)

@property (assign, nonatomic) NSInteger nColumnCount; // 2, 3, or 4

@property (assign, nonatomic) NSInteger nResultType; // default : DO_PICKER_RESULT_UIIMAGE

- (instancetype)initWithSelectAssets:(NSArray *)selectAssets;

@end


@protocol YHImagePickerControllerDelegate <NSObject>

- (void)didSelectPhotosFromYHImagePickerController:(YH_ImagePickerViewController *)picker result:(NSArray *)aSelected finish:(BOOL)flag;

@optional

- (void)didCancelYHImagePickerController:(YH_ImagePickerViewController *)picker;

@end
