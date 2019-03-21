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

- (instancetype)initWithFrame:(CGRect)frame imgUrls:(NSArray *)imgUrls;

- (void)refreshImgUrls:(NSArray *)imgUrls;

@end


@protocol QSThumbPreviewDelegate <NSObject>

@optional
- (void)thumPreview:(QSThumbPreviewView *)view didScrollToIndex:(NSInteger)index;

@end

