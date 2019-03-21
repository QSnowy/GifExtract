//
//  UIAlertController+Simple.h
//  GifExtract
//
//  Created by snow on 2019/3/21.
//  Copyright © 2019年 snow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Simple)

+ (UIAlertController *)simpleAlertWithTitle:(NSString *)title msg:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
