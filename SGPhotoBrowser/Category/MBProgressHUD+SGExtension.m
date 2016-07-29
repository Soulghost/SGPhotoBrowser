//
//  MBProgressHUD+SGExtension.m
//  codeSprite
//
//  Created by soulghost on 13/5/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "MBProgressHUD+SGExtension.h"

@implementation MBProgressHUD (SGExtension)

+ (void)showLabelText:(NSString *)text {
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:hud afterDelay:0.7];
}

+ (void)showText:(NSString *)text withImageNamed:(NSString *)imageName {
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = text;
    UIImage *image = [[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@",imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:hud afterDelay:0.7];
}

+ (void)showSuccess:(NSString *)success {
    [self showText:success withImageNamed:@"Checkmark.png"];
}

+ (void)showError:(NSString *)error {
    [self showLabelText:error];
}

+ (void)showMessage:(NSString *)message {
    [self showMessage:message toView:nil];
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject].rootViewController.view;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
    hud.dimBackground = YES;
}

+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject].rootViewController.view;
    }
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD {
    [self hideHUDForView:nil];
}

@end
