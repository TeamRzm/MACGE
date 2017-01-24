//
//  ACGE_FandeLabel.m
//  MACGE
//
//  Created by Martin.Ren on 2017/1/9.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//

#import "ACGE_FandeLabel.h"
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import "UIImage+GIF.h"
#import "CFTextView.h"
#import "CFTextModel.h"

@interface ACGE_FandeLabel()

@property (nonatomic, strong) NSMutableArray<UILabel*>      *subLabels;

@end

@implementation ACGE_FandeLabel

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self ) {
        self.subLabels = [[NSMutableArray alloc] init];
        self.font = [UIFont systemFontOfSize:13.0f];
        self.textcolor = [UIColor darkTextColor];
        self.linespace = 0.0f;
        self.singleLineduartion = .25f;
    }
    return self;
}

- (NSArray*) getLinesArrContentString : (NSAttributedString*) attStr
{
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,self.frame.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [self.text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}

- (void) reDrawSubLabels
{
    for (UIView *subview in self.subLabels)
    {
        [subview removeFromSuperview];
    }
    
    [self.subLabels removeAllObjects];
    
    NSDictionary *subLabelAttrFormat = @{
                                         NSFontAttributeName : self.font,
                                         NSForegroundColorAttributeName : self.textcolor,
                                         };

    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:self.text attributes:subLabelAttrFormat];
    
    mutableAttr = [CFTextModel CreateGIFAttributedStringWithContentStr:mutableAttr];
    
    NSArray *comStrArr = [self getLinesArrContentString:mutableAttr];

    NSTimeInterval delaySum = 0.0f;
    
    for ( int i = 0; i < comStrArr.count; i++)
    {
        NSAttributedString *attText = [[NSAttributedString alloc] initWithString:comStrArr[i] attributes:subLabelAttrFormat];
        
        CGSize singleLineSize = [@"Singline" sizeWithAttributes:subLabelAttrFormat];
        
        CGFloat singleLineHeihgt = singleLineSize.height;
        
        UILabel *subLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, i * (singleLineHeihgt + self.linespace) + self.linespace, self.frame.size.width, singleLineHeihgt)];
        
        subLineLabel.attributedText = attText;
        
        [self.subLabels addObject:subLineLabel];

        UIImageView *maskAlphaView = [[UIImageView alloc] initWithFrame:CGRectMake(-CGRectGetWidth(subLineLabel.frame) - 28.0f,
                                                                                   0,
                                                                                   CGRectGetWidth(subLineLabel.frame) + 28.0f,
                                                                                   CGRectGetHeight(subLineLabel.frame))];
        
        maskAlphaView.image = [[UIImage imageNamed:@"lineAphlaMask"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 40) resizingMode:UIImageResizingModeTile];
        subLineLabel.maskView = maskAlphaView;
        
        NSTimeInterval currentAnmDuration = subLineLabel.frame.size.width / 100.0f * self.singleLineduartion;
        
        [UIView animateWithDuration:currentAnmDuration delay:delaySum options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             maskAlphaView.frame = CGRectMake(0, 0, CGRectGetWidth(maskAlphaView.frame), CGRectGetHeight(maskAlphaView.frame));
                             
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
        delaySum += currentAnmDuration;
        
        [self addSubview:subLineLabel];
    }
    
    return ;
}

- (void) setText:(NSString *) ptext
{
    _text = ptext;
    
    [self reDrawSubLabels];
    
    return ;
}

- (void) setTextcolor:(UIColor *) ptextcolor
{
    _textcolor = ptextcolor;
    
    if (self.text.length > 0)
    {
        [self reDrawSubLabels];
    }
    
    return ;
}

- (void) setFont:(UIFont *) font
{
    _font = font;
    
    if (self.text.length > 0)
    {
        [self reDrawSubLabels];
    }
    
    return ;
}

- (void) setLinespace:(CGFloat)linespace
{
    _linespace = linespace;
    
    if (self.text.length > 0)
    {
        [self reDrawSubLabels];
    }
    
    return ;
}


@end
