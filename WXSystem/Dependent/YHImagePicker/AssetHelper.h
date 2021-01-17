//
//  AssetHelper.h
//  YH_Mall
//
//  Created by candy.chen on 18/9/13.
//  Copyright (c) 2018年 candy.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define ASSETHELPER    [AssetHelper sharedAssetHelper]

#define ASSET_PHOTO_THUMBNAIL           0 //小正方形的缩略图）
#define ASSET_PHOTO_ASPECT_THUMBNAIL    1 //按原始资源长宽比例的缩略图
#define ASSET_PHOTO_SCREEN_SIZE         2 //获取资源图片的全屏图
#define ASSET_PHOTO_FULL_RESOLUTION     3    //获取资源图片的高清图

@interface AssetHelper : NSObject

- (BOOL)initAsset;

@property (strong, nonatomic)   ALAssetsLibrary			*assetsLibrary;
@property (strong, nonatomic)   NSMutableArray          *assetPhotos;
@property (strong, nonatomic)   NSMutableArray          *assetGroups;

@property (assign, readwrite)   BOOL                    bReverse;

+ (AssetHelper *)sharedAssetHelper;

// get album list from asset
- (void)getGroupList:(void (^)(NSArray *))result;
// get photos from specific album with ALAssetsGroup object
- (void)getPhotoListOfGroup:(ALAssetsGroup *)alGroup result:(void (^)(NSArray *))result;
// get photos from specific album with index of album array
- (void)getPhotoListOfGroupByIndex:(NSInteger)nGroupIndex result:(void (^)(NSArray *))result;
// get photos from camera roll
- (void)getSavedPhotoList:(void (^)(NSArray *))result error:(void (^)(NSError *))error;

- (NSInteger)getGroupCount;
- (NSInteger)getPhotoCountOfCurrentGroup;
- (NSDictionary *)getGroupInfo:(NSInteger)nIndex;

- (void)clearData;

// utils
- (UIImage *)getCroppedImage:(NSURL *)urlImage;
- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(NSInteger)nType;
- (UIImage *)getImageAtIndex:(NSInteger)nIndex type:(NSInteger)nType;
- (ALAsset *)getAssetAtIndex:(NSInteger)nIndex;
- (ALAssetsGroup *)getGroupAtIndex:(NSInteger)nIndex;
- (NSUInteger)indexOfAsset:(ALAsset *)asset;

// get a list of asset from urls
- (NSArray *)getAssetsWithURLs:(NSArray *)urls;
@end

