//
//  QSImagePreviewCell.h
//  iOSCompusTeacher
//
//  Created by snow on 2018/10/24.
//  Copyright © 2018年 snow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QSImagePreviewCell : UICollectionViewCell

@property (nonatomic, strong) id source;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)resetSubViews;

@end

