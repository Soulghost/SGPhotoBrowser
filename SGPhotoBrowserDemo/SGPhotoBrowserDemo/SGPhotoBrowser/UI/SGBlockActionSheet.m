//
//  SGActionSheet.m
//  codeSprite
//
//  Created by soulghost on 27/4/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGBlockActionSheet.h"

@interface SGBlockActionSheet () <UIActionSheetDelegate>

@end

@implementation SGBlockActionSheet

- (instancetype)initWithTitle:(NSString *)title callback:(SGBlockActionSheetBlock)callback cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitlesArray:(NSArray<NSString *> *)otherButtonTitlesArray {
    if (self = [super initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil]) {
        for (NSUInteger i = 0; i < otherButtonTitlesArray.count; i++) {
            [self addButtonWithTitle:otherButtonTitlesArray[i]];
        }
        self.callback = callback;
    }
    return self;
}

#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.callback) {
        self.callback(actionSheet, buttonIndex);
    }
}

@end
