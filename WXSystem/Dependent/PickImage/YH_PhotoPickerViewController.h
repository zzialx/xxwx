//
//  YH_PhotoPickerViewController.h
//  YH_Community
//
//  Created by candy.chen on 18/7/6.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetHelper.h"
#import "YH_ImagePickerConstants.h"


@protocol YHPhotoPickerControllerDelegate;

@interface YH_PhotoPickerViewController : UIViewController

@property (weak, nonatomic) id<YHPhotoPickerControllerDelegate> delegate;

@property (assign, nonatomic) NSInteger nMaxCount; // -1 : no limit

@property (assign, nonatomic) NSInteger nInitCount; // [0, nMaxCount)

@property (assign, nonatomic) NSInteger nColumnCount; // 2, 3, or 4

@property (assign, nonatomic) NSInteger nResultType; // default : DO_PICKER_RESULT_UIIMAGE

@property (strong, nonatomic) NSMutableArray *selectAssets;

@property (strong, nonatomic, readonly) UIButton *cameraButton;

- (instancetype)initWithSelectAssets:(NSArray *)selectAssets;

@end

@protocol YHPhotoPickerControllerDelegate <NSObject>

- (void)didSelectPhotosFromPhotoPickerController:(YH_PhotoPickerViewController *)picker result:(NSArray *)aSelected finish:(BOOL)flag;

@optional

- (void)didCancelFromPhotoPickerController:(YH_PhotoPickerViewController *)picker;

@end



