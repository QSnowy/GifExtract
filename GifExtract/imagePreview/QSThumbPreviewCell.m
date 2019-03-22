//
//  QSThumbPreviewCell.m
//  iOSCompusTeacher
//
//  Created by snow on 2018/10/29.
//  Copyright © 2018年 snow. All rights reserved.
//

#import "QSThumbPreviewCell.h"
#import "UIImageView+WebCache.h"

@implementation QSThumbPreviewCell
{
    UIImageView        *_imgView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self){
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    // image view
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    [self addSubview:imgView];
    _imgView = imgView;

}

- (void)setThumb:(id)thumb {
    
    if ([thumb isKindOfClass:[NSString class]]){
        
        [_imgView sd_setImageWithURL:[NSURL URLWithString:thumb] placeholderImage:nil];
        
    }else if ([thumb isKindOfClass:[UIImage class]]){
        
        [_imgView setImage:thumb];
        
    }else if ([thumb isKindOfClass:[NSURL class]]){
        
        [_imgView sd_setImageWithURL:thumb placeholderImage:nil];

    }
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    CGFloat scale = selected ? 1.1 : 1.0;
    [UIView animateWithDuration:0.3f animations:^{
        
        self.transform = CGAffineTransformMakeScale(scale, scale);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    _imgView.frame = CGRectMake(2, 2, self.bounds.size.width - 4, self.bounds.size.height - 4);

}

@end
