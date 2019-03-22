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
@property (nonatomic, strong) NSArray *thumbs;

@end

@implementation QSThumbPreviewView

- (instancetype)initWithFrame:(CGRect)frame thumbs:(NSArray *)thumbs {
    
    self = [super initWithFrame:frame];
    if (self){
        
        _thumbs = thumbs;
        [self setupUI];
    }
    return self;
}

- (void)refreshThumbs:(NSArray *)thumbs {
    _thumbs = thumbs;
    [_collectionView reloadData];
}

- (void)setupUI{
    
    // collection view
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
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
    collectionView.contentInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width * 0.5, 0, [UIScreen mainScreen].bounds.size.width * 0.5);
    _collectionView = collectionView;
    
    
}

// MARK: - setter
- (void)setCurrentIndex:(NSInteger)currentIndex{
    
    if (currentIndex < 0 || currentIndex >= _thumbs.count){
        return;
    }
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    [self collectionView:_collectionView didSelectItemAtIndexPath:selectedIndexPath];
    [_collectionView selectItemAtIndexPath:selectedIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
}

// MARK: - UICollectionView data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _thumbs.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QSThumbPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QSThumbPreviewCell" forIndexPath:indexPath];
    id thumb = _thumbs[indexPath.row];
    cell.thumb = thumb;
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(collectionView.bounds.size.height * 0.5 + 10, collectionView.bounds.size.height);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _currentIndex = indexPath.row;
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 计算当前中间位置的index
    if (scrollView == _collectionView){
       NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:CGPointMake(scrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width*0.5, 0)];
        if (indexPath == nil || indexPath.row == _currentIndex){
            return;
        }
        _currentIndex = indexPath.row;
        NSLog(@"scroll center index = %@",@(_currentIndex));
        if (_delegate && [_delegate respondsToSelector:@selector(thumPreview:didScrollToIndex:)]){
            
            [_delegate thumPreview:self didScrollToIndex:_currentIndex];
        }

        
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
