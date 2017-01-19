//
//  ACGE_SimpleLine.m
//  MACGE
//
//  Created by Martin.Ren on 2017/1/9.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//

#import "ACGE_SimpleLine.h"
#import "ACGE_FandeLabel.h"
#import "CFTextView.h"
#import "CFTextModel.h"

#define LINE_VIEW_HEIGHT 110

@interface ACGE_SimpleLine()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) CFTextView *lineLabel;

@end


@implementation ACGE_SimpleLine

+ (instancetype) LineView
{
    ACGE_SimpleLine *lineView = [[ACGE_SimpleLine alloc] initWithFrame:CGRectMake(0,
                                                                                  [UIScreen mainScreen].bounds.size.height - LINE_VIEW_HEIGHT,
                                                                                  [UIScreen mainScreen].bounds.size.width,
                                                                                  LINE_VIEW_HEIGHT)];
    
    return lineView;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        self.backgroundColor = [UIColor colorWithWhite:.90f alpha:.95f];
        
        [self addSubview:self.nameLabel];
        
        [self addSubview:self.lineLabel];
       
    }
    return self;
}

- (void) displayLineString : (NSString*) lineStr actorName : (NSString*) actorName
{
    self.nameLabel.text = actorName;
    
    NSDictionary *format = @{
                             NSFontAttributeName : self.lineLabel.font,
                             NSForegroundColorAttributeName : self.lineLabel.textColor,
                             };
    
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:lineStr attributes:format];
    
    self.lineLabel.attributedText = [CFTextModel CreateGIFAttributedStringWithContentStr:attr];
    
    return;
}

- (UILabel*) nameLabel
{
    if ( !_nameLabel )
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 15)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    }
    
    return _nameLabel;
}

- (CFTextView*) lineLabel
{
    if ( !_lineLabel )
    {
        _lineLabel = [[CFTextView alloc] initWithFrame:CGRectMake(10,
                                                                  35,
                                                                  self.frame.size.width - 20,
                                                                  CGRectGetHeight(self.frame) - 45)];
        _lineLabel.textColor = [UIColor darkGrayColor];
        _lineLabel.font = [UIFont systemFontOfSize:16];
        _lineLabel.backgroundColor = [UIColor clearColor];
        _lineLabel.singleLineduartion = .3f;
    }
    
    return _lineLabel;
}

@end
