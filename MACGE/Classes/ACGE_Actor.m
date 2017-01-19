//
//  ACGE_Actor.m
//  MACGE
//
//  Created by Martin.Ren on 2016/12/22.
//  Copyright © 2016年 Martin.Ren. All rights reserved.
//

#import "ACGE_Actor.h"

@implementation ACGE_Actor

- (void) setFrame:(CGRect) _tframe
{
    _frame = _tframe;
    self.displayView.frame = _frame;
    
    return ;
}

- (void) setImg:(UIImage *) _timg
{
    _img = _timg;
    self.displayView.image = _img;
    return ;
}

- (UIImageView*) displayView
{
    if (!_displayView)
    {
        _displayView = [[UIImageView alloc] init];
        _displayView.alpha = 0.0f;
    }
    
    return _displayView;
}

@end
