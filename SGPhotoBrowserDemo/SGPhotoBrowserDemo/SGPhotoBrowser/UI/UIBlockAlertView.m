//
//  UIBlockAlertView.m
//  MagicCrush
//
//  Created by soulghost on 21/4/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "UIBlockAlertView.h"

@interface UIBlockAlertView () <UIAlertViewDelegate>

@end

@implementation UIBlockAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle callback:(UIBlockAlertViewBlock)callback {
    if (self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:confirmButtonTitle, nil]) {
        self.callback = callback;
    }
    return self;
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.callback) {
        self.callback(self, buttonIndex);
    }
}

@end
