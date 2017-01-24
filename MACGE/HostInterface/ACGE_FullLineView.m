//
//  ACGE_FullLineView.m
//  MACGE
//
//  Created by Martin.Ren on 2017/1/22.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//

#import "ACGE_FullLineView.h"
#import "ACGE_FandeLabel.h"

@interface ACGE_FullLineView()
{
    
}

@property (nonatomic, strong) UIImageView       *backgoundImageView;
@property (nonatomic, strong) ACGE_FandeLabel   *contentTextView;

@end


@implementation ACGE_FullLineView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        
        self.backgoundImageView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.contentTextView.frame = CGRectMake(100, 100, CGRectGetWidth(frame) - 200, CGRectGetHeight(frame) - 200);
        
        [self addSubview:self.backgoundImageView];
        [self addSubview:self.contentTextView];
        
        UITapGestureRecognizer *tapHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHide)];
        [self addGestureRecognizer:tapHide];
    }
    
    return self;
}

- (void) tapToHide
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullLineViewDidEndAnimation:)] )
    {
        [self.delegate fullLineViewDidTapAnimationoView:self];
    }
}

- (void) lineAnimationStart
{
//    __weak typeof(self) weakSelf = self;
//
//    [self.contentTextView setAnimationFinishedBlock:^{
//        
//        weakSelf.userInteractionEnabled = YES;
//        
//        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(fullLineViewDidEndAnimation:)] )
//        {
//            [weakSelf.delegate fullLineViewDidEndAnimation:weakSelf];
//        }
//        
//    }];

    _contentTextView.text = self.text;

    return ;
}

- (void) setFont:(UIFont *)font
{
    _font = font;
    
    _contentTextView.font = _font;

    return;
}

- (void) setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    _contentTextView.textcolor = textColor;
    
    return ;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    
    _contentTextView.textAlignment = textAlignment;
    
    return ;
}

- (void) setImage:(UIImage *)image
{
    _image = image;
    
    self.backgoundImageView.image = _image;
    
    return ;
}

- (UIImageView*) backgoundImageView
{
    if (!_backgoundImageView)
    {
        _backgoundImageView = [[UIImageView alloc] init];
    }
    
    return _backgoundImageView;
}

- (void) setSingleLineduartion:(CGFloat)singleLineduartion
{
    _singleLineduartion = singleLineduartion;
    
    _contentTextView.singleLineduartion = _singleLineduartion;
    
    return ;
}

- (ACGE_FandeLabel*) contentTextView
{
    if (!_contentTextView)
    {
        _contentTextView = [[ACGE_FandeLabel alloc] initWithFrame:CGRectZero];
        _contentTextView.textcolor = [UIColor darkGrayColor];
        _contentTextView.font = [UIFont systemFontOfSize:16];
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.singleLineduartion = .3f;
    }
    
    return _contentTextView;
}

@end
