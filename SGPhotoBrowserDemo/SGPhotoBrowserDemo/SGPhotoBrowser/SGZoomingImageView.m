//
//  SGImageView.m
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGZoomingImageView.h"
#import "SGPhotoBrowser.h"
#import "UIImageView+SGExtension.h"

@interface SGZoomingImageView () <UIScrollViewDelegate> {
    NSTimeInterval _animationDuration;
}

@property (nonatomic, copy) SGZoomingImageViewTapHandlerBlock singleTapHandlerBlock;
@property (nonatomic, assign) CGPoint currentTouchPoint;

@end

@implementation SGZoomingImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.backgroundColor = [UIColor blackColor];
        self.maximumZoomScale = 5.0f;
        self.minimumZoomScale = 1.0f;
        self.showsVerticalScrollIndicator = self.showsHorizontalScrollIndicator = NO;
        UIImageView *imageView = [UIImageView new];
        self.innerImageView = imageView;
        [self addSubview:imageView];
    }
    return self;
}

- (void)scaleToFitAnimated:(BOOL)animated {
    self.state = SGImageViewStateFit;
    _animationDuration = 0.3f;
    UIImage *image = self.innerImageView.image;
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    if (imageW == 0 || imageH == 0) return;
    CGSize visibleSize = self.bounds.size;
    if (!isLandScape()) {
        CGFloat scale = visibleSize.width / imageW;
        imageW = visibleSize.width;
        imageH = imageH * scale;
    } else {
        CGFloat scale = visibleSize.height / imageH;
        imageW = imageW * scale;
        imageH = visibleSize.height;
    }
    void (^ModifyBlock)() = ^{
        self.zoomScale = 1.0f;
        self.contentSize = self.bounds.size;
        CGRect frame = self.innerImageView.frame;
        frame.size.width = imageW;
        frame.size.height = imageH;
        frame.origin.x = (self.contentSize.width - imageW) * 0.5f;
        frame.origin.y = (self.contentSize.height - imageH) * 0.5f;
        self.innerImageView.frame = frame;
    };
    if (animated) {
        [UIView animateWithDuration:_animationDuration animations:^{
            ModifyBlock();
        }];
    } else {
        ModifyBlock();
    }
}

- (void)scaleToFitIfNeededAnimated:(BOOL)animated {
    if (self.zoomScale != 1.0f) {
        [self scaleToFitAnimated:animated];
    }
}

- (void)scaleToOriginSize:(BOOL)animated {
    self.state = SGImageViewStateOrigin;
    UIImage *image = self.innerImageView.image;
    CGFloat imageW = image.size.width;
    CGFloat scale = imageW / self.bounds.size.width;
    if (scale <= 1.0f) scale = 2.0f;
    self.maximumZoomScale = scale;
    CGFloat destScale = scale;
    CGFloat xSize = self.bounds.size.width / destScale;
    CGFloat ySize = self.bounds.size.height / destScale;
    CGRect zoomRect = CGRectMake(self.currentTouchPoint.x - xSize * 0.5f, self.currentTouchPoint.y - ySize * 0.5f, xSize, ySize);
    [self zoomToRect:zoomRect animated:animated];
}

- (void)toggleState:(BOOL)animated {
    if (self.state == SGImageViewStateNone || self.state == SGImageViewStateFit) {
        [self scaleToOriginSize:animated];
    } else {
        [self scaleToFitAnimated:animated];
    }
}

- (void)setSingleTapHandler:(SGZoomingImageViewTapHandlerBlock)handler {
    self.singleTapHandlerBlock = handler;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPt = [touch locationInView:self.innerImageView];
    self.currentTouchPoint = touchPt;
    NSInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            [self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:0.2];
            break;
        case 2:
            [self handleDoubleTap];
            break;
        default:
            break;
    }
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)handleSingleTap {
    if (self.singleTapHandlerBlock) {
        self.singleTapHandlerBlock();
    }
}

- (void)handleDoubleTap {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self toggleState:YES];
}

#pragma mark -
#pragma mark UIScrollView Delegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView; {
    return self.innerImageView.hud == nil ? self.innerImageView : nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.innerImageView.frame;
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) * 0.5f);
    } else {
        frameToCenter.origin.x = 0;
    }
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) * 0.5f);
    } else {
        frameToCenter.origin.y = 0;
    }
    if (!CGRectEqualToRect(self.innerImageView.frame, frameToCenter)) {
        self.innerImageView.frame = frameToCenter;
    }
}

@end
