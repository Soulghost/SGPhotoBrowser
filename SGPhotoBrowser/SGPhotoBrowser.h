//
//  SGPhotoBrowserViewController.h
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGPhotoModel.h"

typedef SGPhotoModel * (^SGPhotoBrowserDataSourcePhotoBlock)(NSInteger index);
typedef NSInteger (^SGPhotoBrowserDataSourceNumberBlock)(void);
typedef void(^SGPhotoBrowserReloadRequestBlock)(void);

@interface SGPhotoBrowser : UIViewController

@property (nonatomic, assign) NSInteger numberOfPhotosPerRow;
@property (nonatomic, copy, readonly) SGPhotoBrowserDataSourceNumberBlock numberOfPhotosHandler;
@property (nonatomic, copy, readonly) SGPhotoBrowserDataSourcePhotoBlock photoAtIndexHandler;
@property (nonatomic, copy, readonly) SGPhotoBrowserReloadRequestBlock reloadHandler;

- (void)setNumberOfPhotosHandlerBlock:(SGPhotoBrowserDataSourceNumberBlock)handler;
- (void)setphotoAtIndexHandlerBlock:(SGPhotoBrowserDataSourcePhotoBlock)handler;
- (void)setReloadHandlerBlock:(SGPhotoBrowserReloadRequestBlock)handler;
- (void)reloadData;

@end

#define isLandScape() (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) || \
                      ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight))
#define sg_ws() __weak typeof(self) weakSelf = self
