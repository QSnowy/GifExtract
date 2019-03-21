//
//  QSImagePreviewView.m
//  iOSCompusTeacher
//
//  Created by snow on 2018/10/24.
//  Copyright © 2018年 snow. All rights reserved.
//

#import "QSImagePreviewView.h"
#import "QSImagePreviewCell.h"

@interface QSImagePreviewView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray *sourceArray;

@end

@implementation QSImagePreviewView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self){
        
        [self setupUI];
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame withImgUrls:(NSArray *)urls{
    
    self = [super initWithFrame:frame];
    if (self){
        _sourceArray = urls;
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withImgs:(NSArray <UIImage *>*)imgs {
    
    self = [super initWithFrame:frame];
    if (self){
        _sourceArray = imgs;
        [self setupUI];
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame withSources:(NSArray *)sources{
    
    self = [super initWithFrame:frame];
    if (self){
        _sourceArray = sources;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _layout = layout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor blackColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.scrollsToTop = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentOffset = CGPointMake(0, 0);
    [self addSubview:collectionView];
    [collectionView registerClass:[QSImagePreviewCell class] forCellWithReuseIdentifier:@"QSImagePreviewCell"];
    _collectionView = collectionView;
}


- (void)refreshSources:(NSArray *)sources {
    
    _sourceArray = sources;
    [_collectionView reloadData];
    
    
}

// MARK: - UICollectionView data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _sourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QSImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QSImagePreviewCell" forIndexPath:indexPath];
    id source = _sourceArray[indexPath.row];
    cell.source = source;
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell isKindOfClass:[QSImagePreviewCell class]]){
        
        [(QSImagePreviewCell *)cell resetSubViews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell isKindOfClass:[QSImagePreviewCell class]]){
        
        [(QSImagePreviewCell *)cell resetSubViews];
    }
}

// MARK: - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 去执行did end scroll animation
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.1];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSInteger index = scrollView.contentOffset.x / _layout.itemSize.width;
    if (_currentIndex == index){
        return;
    }
    _currentIndex = index;
    
    if (_delegate && [_delegate respondsToSelector:@selector(imagePreview:didScrollToIndex:)]){
        
        [_delegate imagePreview:self didScrollToIndex:index];
    }

}

// MARK: - layout
- (void)layoutSubviews{
    
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
}

// MARK: - public methods
- (void)setCurrentIndex:(NSInteger)currentIndex{
    
    [self setIndex:currentIndex animated:NO];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated{
    
    [self setIndex:index animated:animated];
}

// MARK: - private
- (void)setIndex:(NSInteger)index animated:(BOOL)animated{
    
    if (index >= 0 && index < _sourceArray.count){
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
   
    }
    
}

@end
