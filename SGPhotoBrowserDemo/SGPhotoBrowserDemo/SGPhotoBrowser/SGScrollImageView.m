//
//  SGImageView.m
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGScrollImageView.h"

@interface SGScrollImageView () <UIScrollViewDelegate>

@end

@implementation SGScrollImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.delegate = self;
    self.maximumZoomScale = 5.0f;
    self.minimumZoomScale = 1.0f;
    UIImageView *imageView = [UIImageView new];
    self.innerImageView = imageView;
    [self insertSubview:imageView atIndex:0];
}

- (void)scaleToFitAnimated:(BOOL)animated {
    self.state = SGImageViewStateFit;
    UIImage *image = self.innerImageView.image;
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    CGSize visibleSize = [UIScreen mainScreen].bounds.size;
    CGFloat scale = visibleSize.width / imageW;
    imageW = visibleSize.width;
    imageH = imageH * scale;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.innerImageView.bounds = CGRectMake(0, 0, imageW, imageH);
        }];
    } else {
        self.innerImageView.bounds = CGRectMake(0, 0, imageW, imageH);
    }
}

- (void)scaleToOriginSize:(BOOL)animated {
    self.state = SGImageViewStateOrigin;
    UIImage *image = self.innerImageView.image;
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.innerImageView.bounds = CGRectMake(0, 0, imageW, imageH);
        }];
    } else {
        self.innerImageView.bounds = CGRectMake(0, 0, imageW, imageH);
    }
}

- (void)toggleState:(BOOL)animated {
    if (self.state == SGImageViewStateNone) return;
    if (self.state == SGImageViewStateFit) {
        [self scaleToOriginSize:animated];
    } else {
        [self scaleToFitAnimated:animated];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize visibleSize = [UIScreen mainScreen].bounds.size;
    self.innerImageView.center = CGPointMake(visibleSize.width * 0.5f, visibleSize.height * 0.5f);
}

#pragma mark -
#pragma mark UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.innerImageView;
}

@end
