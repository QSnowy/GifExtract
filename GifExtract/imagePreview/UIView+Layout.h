//
//  UIView+Layout.h
//  iOSCompusTeacher
//
//  Created by snow on 2018/10/24.
//  Copyright © 2018年 snow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Layout)

@property (nonatomic) CGFloat qs_left;        /// frame.origin.x.
@property (nonatomic) CGFloat qs_top;         /// frame.origin.y
@property (nonatomic) CGFloat qs_right;       /// frame.origin.x + frame.size.width
@property (nonatomic) CGFloat qs_bottom;      /// frame.origin.y + frame.size.height
@property (nonatomic) CGFloat qs_width;       /// frame.size.width.
@property (nonatomic) CGFloat qs_height;      /// frame.size.height.
@property (nonatomic) CGFloat qs_centerX;     /// center.x
@property (nonatomic) CGFloat qs_centerY;     /// center.y
@property (nonatomic) CGPoint qs_origin;      /// frame.origin.
@property (nonatomic) CGSize  qs_size;        /// frame.size.

@end

NS_ASSUME_NONNULL_END
