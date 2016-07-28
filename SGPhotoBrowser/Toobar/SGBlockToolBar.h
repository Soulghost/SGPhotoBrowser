//
//  SGBlockToolBar.h
//  SGSecurityAlbum
//
//  Created by soulghost on 13/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SGBlockToolBarActionBlock)(UIBarButtonItem *item);

@interface SGBlockToolBar : UIToolbar

- (void)setButtonActionHandlerBlock:(SGBlockToolBarActionBlock)handler;
- (void)btnClick:(UIBarButtonItem *)sender;
- (UIBarButtonItem *)createBarButtomItemWithSystemItem:(UIBarButtonSystemItem)systemItem;
- (UIBarButtonItem *)createBarButtomItemWithImage:(UIImage *)image;
- (UIBarButtonItem *)createSpring;

@end
