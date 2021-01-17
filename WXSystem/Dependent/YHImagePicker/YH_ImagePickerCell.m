//
//  YH_ImagePickerCell.m
//  YH_Mall
//
//  Created by candy.chen on 18/9/13.
//  Copyright (c) 2018年 candy.chen. All rights reserved.
//

#import "YH_ImagePickerCell.h"
#import "YH_ImagePickerConstants.h"

#define kImagePickerSelectedViewWidth       23.0f
#define kImagePickerSelectedViewMargin      3.0f

@implementation YH_ImagePickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.imageView];
        
        NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kImagePickerBundleName];
        NSString *selectedPath = [bundlePath stringByAppendingPathComponent:@"imagepickercell_selected.png"];
        UIImage *selectedImage = [UIImage imageWithContentsOfFile:selectedPath];
        
        self.selectedView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - kImagePickerSelectedViewWidth - kImagePickerSelectedViewMargin, kImagePickerSelectedViewMargin, kImagePickerSelectedViewWidth, kImagePickerSelectedViewWidth)];
        self.selectedView.backgroundColor = [UIColor clearColor];
        self.selectedView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.selectedView.image = selectedImage;
        [self.contentView addSubview:self.selectedView];
        self.selectedView.hidden = YES;
        
        NSString *unselectPath = [bundlePath stringByAppendingPathComponent:@"imagepickercell_unselect.png"];
        UIImage *unselectImage = [UIImage imageWithContentsOfFile:unselectPath];
        
        self.unselectedView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - kImagePickerSelectedViewWidth - kImagePickerSelectedViewMargin, kImagePickerSelectedViewMargin, kImagePickerSelectedViewWidth, kImagePickerSelectedViewWidth)];
        self.unselectedView.backgroundColor = [UIColor clearColor];
        self.unselectedView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.unselectedView.image = unselectImage;
        [self.contentView addSubview:self.unselectedView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self showSelectedView:NO];
}

- (void)showSelectedView:(BOOL)show
{
    [self.selectedView setHidden:!show];
    [self.unselectedView setHidden:show];
}

@end
