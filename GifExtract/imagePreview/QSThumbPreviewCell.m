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
    CAShapeLayer       *_borderLayer;
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
//    imgView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(@0).with.inset(2);
        
    }];
    
    _imgView = imgView;
    
    // layer
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.lineWidth = 4;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor cyanColor].CGColor;
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:8];
    borderLayer.path = cornerPath.CGPath;
    [self.layer addSublayer:borderLayer];
    _borderLayer = borderLayer;
    _borderLayer.hidden = YES;
    
    
    
}

- (void)setImgUrl:(NSString *)imgUrl{
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"ppt_placeholder"]];
    
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    _borderLayer.hidden = !selected;
    CGFloat scale = selected ? 1.1 : 1.0;
    [UIView animateWithDuration:0.3f animations:^{
        
        self.transform = CGAffineTransformMakeScale(scale, scale);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    _borderLayer.hidden = !self.selected;
    _borderLayer.frame = self.bounds;
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:8];
    _borderLayer.path = cornerPath.CGPath;

}

@end
