//
//  SGPhoto.h
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGPhotoModel : NSObject

@property (nonatomic, copy) NSURL *photoURL;
@property (nonatomic, copy) NSURL *thumbURL;
@property (nonatomic, assign) BOOL isSelected;

@end
