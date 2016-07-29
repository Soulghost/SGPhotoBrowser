//
//  UIImageView+SGExtension.m
//  SGSecurityAlbum
//
//  Created by soulghost on 14/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "UIImageView+SGExtension.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>
#import "SDImageCache.h"
#import "SGPhotoModel.h"
#import "MBProgressHUD.h"

@implementation UIImageView (SGExtension)

static char hudKey;
static char modelKey;

@dynamic hud;
@dynamic model;

- (void)sg_setImageWithURL:(NSURL *)url {
    if (![url isFileURL]) {
        SDImageCache *cache = [SDImageCache sharedImageCache];
        SDWebImageManager *mgr = [SDWebImageManager sharedManager];
        NSString *key = [mgr cacheKeyForURL:url];
        if ([cache diskImageExistsWithKey:key] || ([cache imageFromMemoryCacheForKey:key] != nil)) {
            [self sd_setImageWithURL:url];
            return;
        }
        if (self.hud != nil) {
            return;
        }
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
        self.hud = hud;
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        [self addSubview:hud];
        [hud showAnimated:YES];
        UIImage *placeHolderImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SGPhotoBrowser.bundle/ImagePlaceholder.png" ofType:nil]];
        if (self.model.thumbURL) {
            NSString *key = [mgr cacheKeyForURL:self.model.thumbURL];
            UIImage *tempImage = [cache imageFromMemoryCacheForKey:key];
            if (tempImage == nil) {
                tempImage = [cache imageFromDiskCacheForKey:key];
            }
            if (tempImage) {
                placeHolderImage = tempImage;
            }
        }
        [self sd_setImageWithURL:url placeholderImage:placeHolderImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            hud.progress = (float)receivedSize / expectedSize;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [hud removeFromSuperview];
            self.hud = nil;
        }];
    } else {
        self.image = [UIImage imageWithContentsOfFile:url.path];
    }
}

- (void)sg_setImageWithURL:(NSURL *)url model:(SGPhotoModel *)model {
    self.model = model;
    [self sg_setImageWithURL:url];
}

#pragma mark - Setter
- (void)setHud:(MBProgressHUD *)hud {
    objc_setAssociatedObject(self, &hudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setModel:(SGPhotoModel *)model {
    objc_setAssociatedObject(self, &modelKey, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter
- (MBProgressHUD *)hud {
    return objc_getAssociatedObject(self, &hudKey);
}

- (SGPhotoModel *)model {
    return objc_getAssociatedObject(self, &modelKey);
}

@end
