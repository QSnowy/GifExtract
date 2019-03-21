//
//  UIAlertController+Simple.m
//  GifExtract
//
//  Created by snow on 2019/3/21.
//  Copyright © 2019年 snow. All rights reserved.
//

#import "UIAlertController+Simple.h"

@implementation UIAlertController (Simple)

+ (UIAlertController *)simpleAlertWithTitle:(NSString *)title msg:(NSString *)msg {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    return alert;
    
}

@end
