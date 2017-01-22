//
//  ACGE_FullLineView.m
//  MACGE
//
//  Created by Martin.Ren on 2017/1/22.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//

#import "ACGE_FullLineView.h"
#import "CFTextView.h"

@interface ACGE_FullLineView()
{
    
}

@property (nonatomic, strong) UIImageView   *backgoundImageView;
@property (nonatomic, strong) CFTextView    *contentTextView;

@end


@implementation ACGE_FullLineView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        
        self.backgoundImageView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.contentTextView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        
        [self addSubview:self.backgoundImageView];
        [self addSubview:self.contentTextView];
    }
    
    return self;
}

- (void) lineAnimationStart
{
    __weak typeof(self) weakSelf = self;
    
    [self.contentTextView setAnimationFinishedBlock:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(fullLineViewDidEndAnimation:)] )
        {
            [weakSelf.delegate fullLineViewDidEndAnimation:weakSelf];
        }
        
    }];
    
    NSDictionary *contentFormatDict = @{
                                        NSFontAttributeName : self.font,
                                        NSForegroundColorAttributeName : self.textColor,
                                        };
    
    _contentTextView.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:contentFormatDict];
    
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
    
    _contentTextView.textColor = textColor;
    
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

- (CFTextView*) contentTextView
{
    if (!_contentTextView)
    {
        _contentTextView = [[CFTextView alloc] initWithFrame:CGRectZero];
        _contentTextView.textColor = [UIColor darkGrayColor];
        _contentTextView.font = [UIFont systemFontOfSize:16];
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.singleLineduartion = .3f;
    }
    
    return _contentTextView;
}

@end
