//
//  SGBrowserToolBar.h
//  SGSecurityAlbum
//
//  Created by soulghost on 13/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGBlockToolBar.h"
#import "SGBrowserMainToolBar.h"
#import "SGBrowserSecondToolBar.h"

@class SGBrowserMainToolBar;
@class SGBrowserSecondToolBar;

#define SGBrowserToolButtonEdit -1
#define SGBrowserToolButtonBack -2
#define SGBrowserToolButtonAction -3
#define SGBrowserToolButtonTrash -4

@interface SGBrowserToolBar : UIView

@property (nonatomic, weak) SGBrowserMainToolBar *mainToolBar;
@property (nonatomic, weak) SGBrowserSecondToolBar *secondToolBar;
@property (nonatomic, assign) BOOL isEditing;

@end
