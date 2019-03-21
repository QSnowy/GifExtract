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

@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, weak) id <QSImagePreviewDelegate> delegate;

/**
 初始化图片预览

 @param frame 预览view frame
 @param urls 预览网络图片 urls
 @return instance of preview
 */
- (instancetype)initWithFrame:(CGRect)frame withImgUrls:(NSArray *)urls;

- (instancetype)initWithFrame:(CGRect)frame withImgs:(NSArray <UIImage *>*)imgs;

- (instancetype)initWithFrame:(CGRect)frame withSources:(NSArray *)sources;

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;


- (void)refreshSources:(NSArray *)sources;

@end

@protocol QSImagePreviewDelegate <NSObject>

- (void)imagePreview:(QSImagePreviewView *)preview didScrollToIndex:(NSInteger)index;

@end

