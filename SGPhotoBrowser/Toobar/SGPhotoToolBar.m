//
//  SGPhotoToolBar.m
//  SGSecurityAlbum
//
//  Created by soulghost on 12/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoToolBar.h"

@interface SGPhotoToolBar ()

@end

@implementation SGPhotoToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.translucent = YES;
        [self setupViews];
    }
    return self;
}

- (UIBarButtonItem *)createBarButtomItemWithSystemItem:(UIBarButtonSystemItem)systemItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(btnClick:)];
}

- (void)setupViews {
    UIBarButtonItem *trashItem = [self createBarButtomItemWithSystemItem:UIBarButtonSystemItemTrash];
    trashItem.tag = SGPhotoToolBarTrashTag;
    UIBarButtonItem *exportItem = [self createBarButtomItemWithSystemItem:UIBarButtonSystemItemAction];
    exportItem.tag = SGPhotoToolBarExportTag;
    UIBarButtonItem *spring = [self createBarButtomItemWithSystemItem:UIBarButtonSystemItemFlexibleSpace];
    self.items = @[trashItem, spring, exportItem];
}

@end
