//
//  QSThumbPreviewView.m
//  iOSCompusTeacher
//
//  Created by snow on 2018/10/29.
//  Copyright © 2018年 snow. All rights reserved.
//

#import "QSThumbPreviewView.h"
#import "QSThumbPreviewCell.h"


@interface QSThumbPreviewView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray *imgUrls;

@end

@implementation QSThumbPreviewView

- (instancetype)initWithFrame:(CGRect)frame imgUrls:(NSArray *)imgUrls{
    
    self = [super initWithFrame:frame];
    if (self){
        
        _imgUrls = imgUrls;
        [self setupUI];
    }
    return self;
}

- (void)refreshImgUrls:(NSArray *)imgUrls {
    
    _imgUrls = imgUrls;
    [_collectionView reloadData];
}

- (void)setupUI{
    
    // collection view
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16);
    _layout = layout;
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-20) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollsToTop = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentOffset = CGPointMake(0, 0);
    collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:collectionView];
    [collectionView registerClass:[QSThumbPreviewCell class] forCellWithReuseIdentifier:@"QSThumbPreviewCell"];
       [collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    _collectionView = collectionView;
    
}

// MARK: - setter
- (void)setCurrentIndex:(NSInteger)currentIndex{
    
    if (currentIndex < 0 || currentIndex >= _imgUrls.count){
        return;
    }
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    [self collectionView:_collectionView didSelectItemAtIndexPath:selectedIndexPath];
    [_collectionView selectItemAtIndexPath:selectedIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
}

// MARK: - UICollectionView data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _imgUrls.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QSThumbPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QSThumbPreviewCell" forIndexPath:indexPath];
    NSString *url = _imgUrls[indexPath.row];
    cell.imgUrl = url;
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(120, 83);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _currentIndex = indexPath.row;

    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(thumPreview:didScrollToIndex:)]){
        
        [_delegate thumPreview:self didScrollToIndex:_currentIndex];
    }

}

// MARK: - observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentSize"] && object == _collectionView){
        NSIndexPath *preSelIndexPath = _collectionView.indexPathsForSelectedItems.firstObject;
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
        // 初始化完成后，默认选中第一个item
        if (preSelIndexPath == nil){
        [_collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            
        }
    }
}

// MARK: - layout
- (void)layoutSubviews{
    
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
}

- (void)dealloc{
    
    [_collectionView removeObserver:self forKeyPath:@"contentSize"];
}

@end
