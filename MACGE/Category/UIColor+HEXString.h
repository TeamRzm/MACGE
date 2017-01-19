//
//  UIColor+HEXString.h
//  MACGE
//
//  Created by Martin.Ren on 2017/1/13.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(HEXString)

+ (UIColor *)colorWithHexString:(NSString *)hex alpha : (CGFloat) alphaValue;

@end
