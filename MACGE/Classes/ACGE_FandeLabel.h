//
//  ACGE_FandeLabel.h
//  MACGE
//
//  Created by Martin.Ren on 2017/1/9.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACGE_FandeLabel : UIView

@property (nonatomic, strong) UIColor   *textcolor;
@property (nonatomic, strong) UIFont    *font;
@property (nonatomic, strong) NSString  *text;
@property (nonatomic, assign) CGFloat    linespace;
@property (nonatomic, assign) NSTimeInterval singleLineduartion;

@end
