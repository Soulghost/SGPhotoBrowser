//
//  SGActionSheet.h
//  codeSprite
//
//  Created by soulghost on 27/4/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SGBlockActionSheetBlock)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface SGBlockActionSheet : UIActionSheet

@property (nonatomic, copy) SGBlockActionSheetBlock callback;

- (instancetype)initWithTitle:(NSString *)title callback:(SGBlockActionSheetBlock)callback cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitlesArray:(NSArray<NSString *> *)otherButtonTitlesArray;

@end
