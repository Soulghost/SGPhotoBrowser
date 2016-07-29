//
//  SGImageView.h
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, SGImageViewState) {
    SGImageViewStateNone = 0,
    SGImageViewStateFit,
    SGImageViewStateOrigin
};

typedef void(^SGZoomingImageViewTapHandlerBlock)(void);

@interface SGZoomingImageView : UIScrollView

@property (nonatomic, assign) SGImageViewState state;
@property (nonatomic, strong) UIImageView *innerImageView;
@property (nonatomic, assign) BOOL isOrigin;

- (void)setSingleTapHandler:(SGZoomingImageViewTapHandlerBlock)handler;
- (void)scaleToFitAnimated:(BOOL)animated;
- (void)scaleToOriginSize:(BOOL)animated;
- (void)toggleState:(BOOL)animated;
- (void)scaleToFitIfNeededAnimated:(BOOL)animated;

@end
