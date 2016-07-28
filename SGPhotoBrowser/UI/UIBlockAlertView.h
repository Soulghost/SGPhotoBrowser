//
//  UIBlockAlertView.h
//  MagicCrush
//
//  Created by soulghost on 21/4/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIBlockAlertViewBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@interface UIBlockAlertView : UIAlertView

@property (nonatomic, copy) UIBlockAlertViewBlock callback;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle callback:(UIBlockAlertViewBlock)callback;

@end
