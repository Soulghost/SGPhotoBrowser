//
//  SGBrowserSecondToolBar.m
//  SGSecurityAlbum
//
//  Created by soulghost on 13/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGBrowserSecondToolBar.h"

@implementation SGBrowserSecondToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.translucent = YES;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIBarButtonItem *editBtn = [self createBarButtomItemWithImage:[UIImage imageNamed:@"BackButton"]];
    editBtn.tag = SGBrowserToolButtonBack;
    UIBarButtonItem *actionBtn = [self createBarButtomItemWithSystemItem:UIBarButtonSystemItemAction];
    actionBtn.tag = SGBrowserToolButtonAction;
    UIBarButtonItem *trashBtn = [self createBarButtomItemWithSystemItem:UIBarButtonSystemItemTrash];
    trashBtn.tag = SGBrowserToolButtonTrash;
    self.items = @[editBtn,[self createSpring],actionBtn,[self createSpring],trashBtn];
}

@end
