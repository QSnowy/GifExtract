//
//  UIView+Layout.m
//  iOSCompusTeacher
//
//  Created by snow on 2018/10/24.
//  Copyright © 2018年 snow. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)

- (CGFloat)qs_left {
    return self.frame.origin.x;
}

- (void)setQs_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)qs_top {
    return self.frame.origin.y;
}

- (void)setQs_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)qs_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setQs_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)qs_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setQs_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)qs_width {
    return self.frame.size.width;
}

- (void)setQs_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)qs_height {
    return self.frame.size.height;
}

- (void)setQs_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)qs_centerX {
    return self.center.x;
}

- (void)setQs_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)qs_centerY {
    return self.center.y;
}

- (void)setQs_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)qs_origin {
    return self.frame.origin;
}

- (void)setQs_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)qs_size {
    return self.frame.size;
}

- (void)setQs_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}



@end
