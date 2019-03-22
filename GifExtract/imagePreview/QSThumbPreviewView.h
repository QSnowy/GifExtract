//
//  QSThumbPreviewView.h
//  iOSCompusTeacher
//
//  Created by snow on 2018/10/29.
//  Copyright © 2018年 snow. All rights reserved.
//  课件小图预览

#import <UIKit/UIKit.h>


@protocol QSThumbPreviewDelegate;

@interface QSThumbPreviewView : UIView

@property (nonatomic, weak) id <QSThumbPreviewDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;

/**
 创建缩略图预览

 @param frame rect for view
 @param thumbs 缩略图数组 url或者image
 @return instance of view
 */
- (instancetype)initWithFrame:(CGRect)frame thumbs:(NSArray *)thumbs;

- (void)refreshThumbs:(NSArray *)thumbs;

@end


@protocol QSThumbPreviewDelegate <NSObject>

@optional
- (void)thumPreview:(QSThumbPreviewView *)view didScrollToIndex:(NSInteger)index;

@end

