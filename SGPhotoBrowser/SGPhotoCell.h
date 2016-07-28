//
//  SGPhotoCell.h
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGPhotoModel;

@interface SGPhotoCell : UICollectionViewCell

@property (nonatomic, strong) SGPhotoModel *model;
@property (nonatomic, assign) BOOL sg_select;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPaht:(NSIndexPath *)indexPath;

@end
