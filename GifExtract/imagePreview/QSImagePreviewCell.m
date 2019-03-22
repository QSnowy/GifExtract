//
//  QSImagePreviewCell.m
//  iOSCompusTeacher
//
//  Created by snow on 2018/10/24.
//  Copyright © 2018年 snow. All rights reserved.
//

#import "QSImagePreviewCell.h"
#import "UIView+Layout.h"
#import "UIImageView+WebCache.h"

@interface QSImagePreviewCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *imageContainerView;

@end

@implementation QSImagePreviewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self){
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI{
    
    // scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.bouncesZoom = YES;
    scrollView.maximumZoomScale = 2.5;
    scrollView.minimumZoomScale = 1.0;
    scrollView.multipleTouchEnabled = YES;
    scrollView.delegate = self;
    scrollView.scrollsToTop = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.delaysContentTouches = NO;
    scrollView.canCancelContentTouches = YES;
    scrollView.alwaysBounceVertical = NO;
    if (@available(iOS 11, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.contentView addSubview:scrollView];
    
    UIView *imageContainerView = [[UIView alloc] init];
    imageContainerView.clipsToBounds = YES;
    imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
    [scrollView addSubview:imageContainerView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.700];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageContainerView addSubview:imageView];
    
    _scrollView = scrollView;
    _imageContainerView = imageContainerView;
    _imageView = imageView;

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self addGestureRecognizer:tap2];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(0, 0, self.qs_width, self.qs_height);
    [self resetSubViews];
}

- (void)resetSubViews {
    
    [_scrollView setZoomScale:1.0 animated:NO];
    _imageContainerView.qs_origin = CGPointZero;
    _imageContainerView.qs_width = self.scrollView.qs_width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.qs_height / self.scrollView.qs_width) {
        _imageContainerView.qs_height = floor(image.size.height / (image.size.width / self.scrollView.qs_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.qs_width;
        if (height < 1 || isnan(height)) height = self.qs_height;
        height = floor(height);
        _imageContainerView.qs_height = height;
        _imageContainerView.qs_centerY = self.qs_height / 2;
    }
    if (_imageContainerView.qs_height > self.qs_height && _imageContainerView.qs_height - self.qs_height <= 1) {
        _imageContainerView.qs_height = self.qs_height;
    }
    CGFloat contentSizeH = MAX(_imageContainerView.qs_height, self.qs_height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.qs_width, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.qs_height <= self.qs_height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
    
}

- (void)setSource:(id)source {
    
    _source = source;
    
    if ([source isKindOfClass:NSString.class]){
        NSString *url = (NSString *)source;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:url]];

    }else if ([source isKindOfClass:UIImage.class]){
        UIImage *img = (UIImage *)source;
        [_imageView setImage:img];
    }
}

// MARK: - UITapGestureRecognizer Event
- (void)doubleTap:(UITapGestureRecognizer *)tap {
    
    if (_scrollView.zoomScale > 1.0) {
        
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:1.0 animated:YES];
        
    } else {
        
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {

    
}


// MARK: - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    
    
}

- (void)refreshImageContainerViewCenter {
    
    CGFloat offsetX = (_scrollView.qs_width > _scrollView.contentSize.width) ? ((_scrollView.qs_width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.qs_height > _scrollView.contentSize.height) ? ((_scrollView.qs_height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}

@end
