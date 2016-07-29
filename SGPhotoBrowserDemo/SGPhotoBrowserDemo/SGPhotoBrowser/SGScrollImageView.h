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

@interface SGScrollImageView : UIScrollView

@property (nonatomic, assign) SGImageViewState state;
@property (nonatomic, strong) UIImageView *innerImageView;

- (void)scaleToFitAnimated:(BOOL)animated;
- (void)scaleToOriginSize:(BOOL)animated;
- (void)toggleState:(BOOL)animated;

@end
