//
//  SGBlockToolBar.m
//  SGSecurityAlbum
//
//  Created by soulghost on 13/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGBlockToolBar.h"

@interface SGBlockToolBar ()

@property (nonatomic, copy) SGBlockToolBarActionBlock actionHandler;

@end

@implementation SGBlockToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setButtonActionHandlerBlock:(SGBlockToolBarActionBlock)handler {
    self.actionHandler = handler;
}

- (UIBarButtonItem *)createBarButtomItemWithSystemItem:(UIBarButtonSystemItem)systemItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(btnClick:)];
}

- (UIBarButtonItem *)createBarButtomItemWithImage:(UIImage *)image {
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(btnClick:)];
}

- (UIBarButtonItem *)createSpring {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

- (void)btnClick:(UIBarButtonItem *)sender {
    if (self.actionHandler) {
        self.actionHandler(sender);
    }
}

@end
