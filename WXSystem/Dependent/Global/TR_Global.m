//
//  TR_Global.m
//  Traceability
//
//  Created by candy.chen on 2019/2/12/3.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TR_Global.h"

@interface TR_Global ()
@property (copy, nonatomic) NSArray *loadingAnimationImages;
@end

@implementation TR_Global

+ (instancetype)sharedInstance
{
    static TR_Global *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TR_Global alloc] init];
    });
    return instance;
}

- (NSArray *)pullingAnimationImages {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:22];
    NSInteger beginIndex = 10;
    for (NSInteger i=1; i<= 33; i++) {
        NSString *imageName = [@"dropdown_anim__000" stringByAppendingString:@(i<=beginIndex?1:i-beginIndex).stringValue];
        UIImage *tempImage = [UIImage imageNamed:imageName];
        UIImage * image = [self imageWithImageSimple:tempImage scaledToSize:CGSizeMake(50, 50)];
        if (image) {
            [array addObject:image];
        }
    }
    
    return array;
}

- (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize{
    
    newSize.height=image.size.height*(newSize.width/image.size.width);   //确保新图片的高等比例缩放，不会造成变形
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
    
}

- (NSArray *)refreshAnimationImages
{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSInteger i = 1; i <= 33; i++) {
        
        NSString *imageName = [@"dropdown_anim__000" stringByAppendingString:@(i).stringValue];
        UIImage *tempImage = [UIImage imageNamed:imageName];
        UIImage * image = [self imageWithImageSimple:tempImage scaledToSize:CGSizeMake(50, 50)];
        
        if (image) {
            [imageArray addObject:image];
        }
    }
    return [NSArray arrayWithArray:imageArray];
}

- (NSArray *)loadingAnimationImages
{
    if (!_loadingAnimationImages) {
        NSMutableArray *imageArray = [NSMutableArray array];
        for (NSInteger i = 1; i <= 33; i++) {
            
            NSString *imageName = [@"dropdown_anim__000" stringByAppendingString:@(i).stringValue];
            UIImage *tempImage = [UIImage imageNamed:imageName];
            UIImage * image = [self imageWithImageSimple:tempImage scaledToSize:CGSizeMake(50, 50)];
            
            if (image) {
                [imageArray addObject:image];
            }
        }
        
        _loadingAnimationImages = imageArray;
    }
    
    return _loadingAnimationImages;
}

@end
