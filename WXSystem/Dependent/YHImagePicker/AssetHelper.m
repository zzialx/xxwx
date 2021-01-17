//
//  AssetHelper.m
//  YH_Mall
//
//  Created by candy.chen on 18/9/13.
//  Copyright (c) 2018年 candy.chen. All rights reserved.
//

#import "AssetHelper.h"
#import "ALAsset+YHIPC.h"

@implementation AssetHelper


+ (AssetHelper *)sharedAssetHelper
{
    static AssetHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[AssetHelper alloc] init];
    });
    
    return _sharedInstance;
}

- (BOOL)initAsset
{
    if (self.assetsLibrary == nil) {
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        
        switch (status) {
            case ALAuthorizationStatusNotDetermined:
            case ALAuthorizationStatusAuthorized: {
                self.assetsLibrary = [[ALAssetsLibrary alloc] init];
                return YES;
            }
                
            default: {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请打开设置->隐私->照片，开启产权的相册访问权限。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                return NO;
            }
        }
        
    }
    return YES;
}

- (void)setCameraRollAtFirst
{
    for (ALAssetsGroup *group in self.assetGroups) {
        if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos) {
            // send to head
            [self.assetGroups removeObject:group];
            [self.assetGroups insertObject:group atIndex:0];
            
            return;
        }
    }
}

- (void)getGroupList:(void (^)(NSArray *))result
{
    if (![self initAsset]) {
        result(nil);
        return;
    }
    
    WS(weakSelf);
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
        
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        if (group == nil) {
            if (weakSelf.bReverse)
                weakSelf.assetGroups = [[NSMutableArray alloc] initWithArray:[[weakSelf.assetGroups reverseObjectEnumerator] allObjects]];
            
            [weakSelf setCameraRollAtFirst];
            
            // end of enumeration
            result(weakSelf.assetGroups);
            return;
        }
        
        [weakSelf.assetGroups addObject:group];
    };
    
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
        
        NSLog(@"Error : %@", [error description]);
    };
    
    self.assetGroups = [[NSMutableArray alloc] init];
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:assetGroupEnumerator
                                    failureBlock:assetGroupEnumberatorFailure];
}

- (void)getPhotoListOfGroup:(ALAssetsGroup *)alGroup result:(void (^)(NSArray *))result
{
    if (![self initAsset]) {
        result(nil);
        return;
    }
    
    self.assetPhotos = [[NSMutableArray alloc] init];
    [alGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    
    WS(weakSelf);
    NSEnumerationOptions option = weakSelf.bReverse?NSEnumerationReverse:NSEnumerationConcurrent;
    [alGroup enumerateAssetsWithOptions:option usingBlock:^(ALAsset *alPhoto, NSUInteger index, BOOL *stop) {
        if(alPhoto == nil) {
            result(weakSelf.assetPhotos);
            return;
        }
        
        [weakSelf.assetPhotos addObject:alPhoto];
    }];
}

- (void)getPhotoListOfGroupByIndex:(NSInteger)nGroupIndex result:(void (^)(NSArray *))result
{
    WS(weakSelf);
    [self getPhotoListOfGroup:self.assetGroups[nGroupIndex] result:^(NSArray *aResult) {
        
        result(weakSelf.assetPhotos);
        
    }];
}

- (void)getSavedPhotoList:(void (^)(NSArray *))result error:(void (^)(NSError *))error
{
    if (![self initAsset]) {
        result(nil);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        WS(weakSelf);
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
            if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                
                NSEnumerationOptions option = weakSelf.bReverse?NSEnumerationReverse:NSEnumerationConcurrent;
                [group enumerateAssetsWithOptions:option usingBlock:^(ALAsset *alPhoto, NSUInteger index, BOOL *stop) {
                    if(alPhoto == nil) {
                        result(weakSelf.assetPhotos);
                        return;
                    }
                    
                    [weakSelf.assetPhotos addObject:alPhoto];
                }];
            }
        };
        
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *err) {
            NSLog(@"Error : %@", [err description]);
            error(err);
        };
        
        self.assetPhotos = [[NSMutableArray alloc] init];
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                          usingBlock:assetGroupEnumerator
                                        failureBlock:assetGroupEnumberatorFailure];
    });
}

- (NSInteger)getGroupCount
{
    return self.assetGroups.count;
}

- (NSInteger)getPhotoCountOfCurrentGroup
{
    return self.assetPhotos.count;
}

- (NSDictionary *)getGroupInfo:(NSInteger)nIndex
{
    NSString *name = MakeStringNotNil([self.assetGroups[nIndex] valueForProperty:ALAssetsGroupPropertyName]);
    if (name.length == 0) {
        name = @"";
    }
    NSInteger count = [self.assetGroups[nIndex] numberOfAssets];
    NSString *groupid = MakeStringNotNil([self.assetGroups[nIndex] valueForProperty:ALAssetsGroupPropertyPersistentID]);
    if (groupid.length
        == 0) {
        groupid = @"";
    }
    CGImageRef *imageRef = [self.assetGroups[nIndex] posterImage];
    if (!imageRef) {
        UIImage *image = [UIImage imageNamed:@"imagePhoto"];
        imageRef = image.CGImage;
    }
    return @{@"name" : name,
             @"count" : @(count),
             @"groupid" : groupid,
             @"post" : [UIImage imageWithCGImage:imageRef]};
}

- (void)clearData
{
    self.assetGroups = nil;
    self.assetPhotos = nil;
}

#pragma mark - utils
- (UIImage *)getCroppedImage:(NSURL *)urlImage
{
    __block UIImage *iImage = nil;
    __block BOOL bBusy = YES;
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
        
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        NSString *strXMP = rep.metadata[@"AdjustmentXMP"];
        if (strXMP == nil || [strXMP isKindOfClass:[NSNull class]]) {
            
            CGImageRef iref = [rep fullResolutionImage];
            if (iref) {
                iImage = [UIImage imageWithCGImage:iref scale:1.0 orientation:(UIImageOrientation)rep.orientation];
            } else {
                iImage = nil;
            }
        } else {
            
            // to get edited photo by photo app
            NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
            
            CIImage *image = [CIImage imageWithCGImage:rep.fullResolutionImage];
            
            NSError *error = nil;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:dXMP
                                                         inputImageExtent:image.extent
                                                                    error:&error];
            if (error) {
                NSLog(@"Error during CIFilter creation: %@", [error localizedDescription]);
            }
            
            for (CIFilter *filter in filterArray) {
                [filter setValue:image forKey:kCIInputImageKey];
                image = [filter outputImage];
            }
            
            iImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)rep.orientation];
        }
        
        bBusy = NO;
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror) {
        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
    };
    
    [self.assetsLibrary assetForURL:urlImage
                        resultBlock:resultblock
                       failureBlock:failureblock];
    
    while (bBusy)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
    return iImage;
}

- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(NSInteger)nType
{
    CGImageRef iRef = nil;
    if (nType == ASSET_PHOTO_THUMBNAIL) {
        iRef = [asset thumbnail];
    } else if (nType == ASSET_PHOTO_ASPECT_THUMBNAIL) {
        iRef = [asset aspectRatioThumbnail];
    } else if (nType == ASSET_PHOTO_SCREEN_SIZE) {
        iRef = [asset.defaultRepresentation fullScreenImage];
    } else if (nType == ASSET_PHOTO_FULL_RESOLUTION) {
        NSString *strXMP = asset.defaultRepresentation.metadata[@"AdjustmentXMP"];
        if (strXMP == nil || [strXMP isKindOfClass:[NSNull class]]) {
            iRef = [asset.defaultRepresentation fullResolutionImage];
            return [UIImage imageWithCGImage:iRef scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        } else {
            NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
            
            CIImage *image = [CIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
            
            NSError *error = nil;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:dXMP
                                                         inputImageExtent:image.extent
                                                                    error:&error];
            if (error) {
                NSLog(@"Error during CIFilter creation: %@", [error localizedDescription]);
            }
            
            for (CIFilter *filter in filterArray) {
                [filter setValue:image forKey:kCIInputImageKey];
                image = [filter outputImage];
            }
            
            UIImage *iImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
            return iImage;
        }
    }
    
    return [UIImage imageWithCGImage:iRef];
}

- (UIImage *)getImageAtIndex:(NSInteger)nIndex type:(NSInteger)nType
{
    if (nIndex >= self.assetPhotos.count) {
        return nil;
    }
    return [self getImageFromAsset:(ALAsset *)self.assetPhotos[nIndex] type:nType];
}

- (ALAsset *)getAssetAtIndex:(NSInteger)nIndex
{
    if (nIndex >= self.assetPhotos.count) {
        return nil;
    }
    return self.assetPhotos[nIndex];
}

- (ALAssetsGroup *)getGroupAtIndex:(NSInteger)nIndex
{
    if (nIndex >= self.assetGroups.count) {
        return nil;
    }
    return self.assetGroups[nIndex];
}

- (NSUInteger)indexOfAsset:(ALAsset *)asset
{
    return [self.assetPhotos indexOfObject:asset];
}

- (NSArray *)getAssetsWithURLs:(NSArray *)urls
{
    if (![self initAsset]) {
        return [NSArray array];
    }
    
    __block NSMutableArray *tempMArr = [NSMutableArray array];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    for (NSURL *url in urls) {
        if (![url isKindOfClass:[NSURL class]]) {
            continue;
        }
        
        dispatch_async(queue, ^{
            [self.assetsLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                if (asset) {
                    [tempMArr addObject:asset];
                } else {
                    LogInfo(@"not found photo:%@", url.absoluteString);
                }
                
                dispatch_semaphore_signal(sema);
            } failureBlock:^(NSError *error) {
                dispatch_semaphore_signal(sema);
            }];
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    return tempMArr;
}

@end
