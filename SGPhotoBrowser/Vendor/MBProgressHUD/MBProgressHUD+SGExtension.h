//
//  MBProgressHUD+SGExtension.h
//  codeSprite
//
//  Created by soulghost on 13/5/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (SGExtension)

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (void)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)showMessage:(NSString *)message;
+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
