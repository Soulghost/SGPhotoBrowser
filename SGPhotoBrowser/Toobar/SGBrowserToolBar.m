//
//  SGBrowserToolBar.m
//  SGSecurityAlbum
//
//  Created by soulghost on 13/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGBrowserToolBar.h"
#import "SGPhotoBrowser.h"

@interface SGBrowserToolBar ()

@property (nonatomic, assign) CGRect outFrame;
@property (nonatomic, assign) CGRect frontFrame;
@property (nonatomic, assign) CGRect backFrame;

@end

@implementation SGBrowserToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    SGBrowserMainToolBar *mainToolBar = [[SGBrowserMainToolBar alloc] initWithFrame:self.frontFrame];
    self.mainToolBar = mainToolBar;
    [self addSubview:mainToolBar];
    sg_ws();
    [mainToolBar setButtonActionHandlerBlock:^(UIBarButtonItem *item) {
        switch (item.tag) {
            case SGBrowserToolButtonEdit:
                weakSelf.isEditing = YES;
                break;
        }
    }];
    SGBrowserSecondToolBar *secondToolBar = [[SGBrowserSecondToolBar alloc] initWithFrame:self.backFrame];
    self.secondToolBar = secondToolBar;
    [self addSubview:secondToolBar];
    [secondToolBar setButtonActionHandlerBlock:^(UIBarButtonItem *item) {
        switch (item.tag) {
            case SGBrowserToolButtonBack:
                weakSelf.isEditing = NO;
                break;
        }
    }];
}

- (void)setIsEditing:(BOOL)isEditing {
    _isEditing = isEditing;
    if (self.isEditing) {
        [UIView animateWithDuration:0.3 animations:^{
            self.mainToolBar.frame = self.outFrame;
            self.secondToolBar.frame = self.frontFrame;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.mainToolBar.frame = self.frontFrame;
            self.secondToolBar.frame = self.backFrame;
        }];
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.outFrame = (CGRect){-self.bounds.size.width, 0, self.bounds.size};
    self.frontFrame = self.bounds;
    self.backFrame = (CGRect){self.bounds.size.width, 0, self.bounds.size};
    [self setIsEditing:_isEditing];
}

@end
