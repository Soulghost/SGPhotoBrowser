//
//  SGPhotoView.m
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoView.h"
#import "SGPhotoModel.h"
#import "UIImageView+WebCache.h"
#import "SGPhotoBrowser.h"
#import "SGPhotoModel.h"
#import "SGZoomingImageView.h"
#import "SGPhotoViewController.h"
#import "UIImageView+SGExtension.h"

@interface SGPhotoView () <UIScrollViewDelegate> {
    CGFloat _pageW;
}

@property (nonatomic, copy) SGPhotoViewTapHandlerBlcok singleTapHandler;
@property (nonatomic, strong) NSArray<SGZoomingImageView *> *imageViews;
@property (nonatomic, assign) NSInteger titleIndex;

@end

@implementation SGPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor blackColor];
    self.pagingEnabled = YES;
    self.delegate = self;
}

- (void)handleDoubleTap {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.currentImageView toggleStateAnimated:YES];
}

- (void)setBrowser:(SGPhotoBrowser *)browser {
    _browser = browser;
    NSInteger count = browser.numberOfPhotosHandler();
    NSMutableArray *imageViews = @[].mutableCopy;
    for (NSUInteger i = 0; i < count; i++) {
        SGZoomingImageView *imageView = [SGZoomingImageView new];
        SGPhotoModel *model = self.browser.photoAtIndexHandler(i);
        [imageView.innerImageView sg_setImageWithURL:model.thumbURL model:model];
        imageView.isOrigin = NO;
        [imageViews addObject:imageView];
        [self addSubview:imageView];
        [imageView scaleToFitAnimated:NO];
    }
    self.imageViews = imageViews;
    [self layoutImageViews];
}

- (void)layoutImageViews {
    NSInteger count = self.browser.numberOfPhotosHandler();
    CGFloat imageViewWidth = self.bounds.size.width;
    _pageW = imageViewWidth;
    self.contentSize = CGSizeMake(count * imageViewWidth, 0);
    for (NSUInteger i = 0; i < self.imageViews.count; i++) {
        SGZoomingImageView *imageView = self.imageViews[i];
        imageView.isOrigin = NO;
        CGRect frame = (CGRect){imageViewWidth * i, 0, imageViewWidth, self.bounds.size.height};
        imageView.frame = CGRectInset(frame, PhotoGutt, 0);
        [self addSubview:imageView];
        [imageView scaleToFitAnimated:NO];
    }
    self.contentOffset = CGPointMake(self.index * _pageW, 0);
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    self.contentOffset = CGPointMake(index * _pageW, 0);
    [self loadImageAtIndex:index];
}

- (void)updateNavBarTitleWithIndex:(NSInteger)index {
    self.controller.navigationItem.title = [NSString stringWithFormat:@"%@ Of %@",@(index + 1),@(self.browser.numberOfPhotosHandler())];
}

- (void)loadImageAtIndex:(NSInteger)index {
    self.titleIndex = index;
    NSInteger count = self.browser.numberOfPhotosHandler();
    for (NSInteger i = 0; i < count; i++) {
        SGPhotoModel *model = self.browser.photoAtIndexHandler(i);
        SGZoomingImageView *imageView = self.imageViews[i];
        if (i == index) {
            self.currentImageView = imageView;
        } else {
            [imageView scaleToFitIfNeededAnimated:NO];
        }
        NSURL *photoURL = model.photoURL;
        NSURL *thumbURL = model.thumbURL;
        if (i >= index - 1 && i <= index + 1) {
            if (imageView.isOrigin) continue;
            [imageView.innerImageView sg_setImageWithURL:photoURL model:model];
            imageView.isOrigin = YES;
            [imageView scaleToFitAnimated:NO];
        } else {
            if (!imageView.isOrigin) continue;
            [imageView.innerImageView sg_setImageWithURL:thumbURL model:model];
            imageView.isOrigin = NO;
            [imageView scaleToFitAnimated:NO];
        }
    }
}

- (void)setCurrentImageView:(SGZoomingImageView *)currentImageView {
    if (_currentImageView != nil) {
        [_currentImageView setSingleTapHandler:nil];
    }
    _currentImageView = currentImageView;
    sg_ws();
    [_currentImageView setSingleTapHandler:^{
        if (weakSelf.singleTapHandler) {
            weakSelf.singleTapHandler();
        }
    }];
}

- (void)setSingleTapHandlerBlock:(SGPhotoViewTapHandlerBlcok)handler {
    self.singleTapHandler = handler;
}

- (SGPhotoModel *)currentPhoto {
    return self.browser.photoAtIndexHandler(_index);
}

- (void)setTitleIndex:(NSInteger)titleIndex {
    if (_titleIndex == titleIndex) return;
    _titleIndex = titleIndex;
    [self updateNavBarTitleWithIndex:titleIndex];
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (offsetX + _pageW * 0.5f) / _pageW;
    if (_index != index) {
        _index = index;
        [self loadImageAtIndex:_index];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    self.titleIndex = (offsetX + _pageW * 0.5f) / _pageW;
}

@end
