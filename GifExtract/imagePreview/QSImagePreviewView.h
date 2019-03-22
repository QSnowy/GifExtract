//
//  QSImagePreviewView.h
//  iOSCompusTeacher
//
//  Created by snow on 2018/10/24.
//  Copyright © 2018年 snow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QSImagePreviewDelegate;

@interface QSImagePreviewView : UIView

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, weak) id <QSImagePreviewDelegate> delegate;

/**
 初始化图片预览

 @param frame 预览view frame
 @param sources 预览资源数组 urls或者images
 @return instance of preview
 */
- (instancetype)initWithFrame:(CGRect)frame withSources:(NSArray *)sources;

/**
 浏览器滚动到指定索引

 @param index 资源索引
 @param animated 是否有滚动动画
 */
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

/**
 刷新资源

 @param sources 预览资源数组
 */
- (void)refreshSources:(NSArray *)sources;

@end

@protocol QSImagePreviewDelegate <NSObject>

- (void)imagePreview:(QSImagePreviewView *)preview didScrollToIndex:(NSInteger)index;

@end

