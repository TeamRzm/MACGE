//
//  CFTextView.m
//  11 - 动态表情
//
//  Created by 于传峰 on 15/12/29.
//  Copyright © 2015年 于传峰. All rights reserved.
//

#import "CFTextView.h"
#import "UIImage+GIF.h"
#import "CFTextAttachment.h"

@implementation CFTextView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void) startAnimation
{
    self.selectedRange = NSMakeRange(0, self.attributedText.length);
    NSArray *arrar = [self selectionRectsForRange:self.selectedTextRange];
    self.selectedRange = NSMakeRange(0, 0);
    
    NSTimeInterval delaySum = 0.0f;
    
    UIView *boundMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    boundMask.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    
    self.maskView = boundMask;
    
    for (UITextSelectionRect *subRect in arrar)
    {
        CGRect frame = subRect.rect;
        
        UIImageView *maskAlphaView = [[UIImageView alloc] initWithFrame:CGRectMake(-CGRectGetWidth(frame) - 28.0f,
                                                                                   frame.origin.y,
                                                                                   CGRectGetWidth(frame) + 28.0f,
                                                                                   CGRectGetHeight(frame))];
        
        
        maskAlphaView.image = [[UIImage imageNamed:@"lineAphlaMask"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 40) resizingMode:UIImageResizingModeTile];
        
        [boundMask addSubview:maskAlphaView];

        NSTimeInterval currentAnmDuration = frame.size.width / 100.0f * self.singleLineduartion;
        
        [UIView animateWithDuration:currentAnmDuration delay:delaySum options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             maskAlphaView.frame = CGRectMake(0, frame.origin.y, CGRectGetWidth(maskAlphaView.frame), CGRectGetHeight(maskAlphaView.frame));
                             
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
        delaySum += currentAnmDuration;
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    for (UIView* subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    [self.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(CFTextAttachment* value, NSRange range, BOOL * _Nonnull stop) {
        
        if (value.gifName && value.gifName.length > 0)
        {
            UIImage *gifImg = [UIImage imageNamed:[value.gifName stringByAppendingString:@".gif"]];
            
            self.selectedRange = range;
            CGRect rect = [self firstRectForRange:self.selectedTextRange];
            self.selectedRange = NSMakeRange(0, 0);

            UIImageView* imageView = [[UIImageView alloc] init];
            [self addSubview:imageView];
            imageView.frame = CGRectMake(rect.origin.x + 1, rect.origin.y, gifImg.size.width *.8f, gifImg.size.height *.8f);
            imageView.image = [UIImage sd_animatedGIFNamed:value.gifName];
        }
    }];
    
    [self startAnimation];
}

@end
