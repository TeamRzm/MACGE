//
//  ACGE_FullLineView.h
//  MACGE
//
//  Created by Martin.Ren on 2017/1/22.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACGE_FullLineView;

@protocol ACGE_FullLineViewDelegate <NSObject>

- (void) fullLineViewDidEndAnimation : (ACGE_FullLineView*) lineView;
- (void) fullLineViewDidTapAnimationoView : (ACGE_FullLineView*) lineView;

@end

@interface ACGE_FullLineView : UIView

@property (nonatomic, strong) NSString          *text;
@property (nonatomic, strong) UIFont            *font;
@property (nonatomic, strong) UIColor           *textColor;
@property (nonatomic, assign) NSTextAlignment    textAlignment;
@property (nonatomic, strong) UIImage           *image;
@property (nonatomic, assign) CGFloat           singleLineduartion;

@property (nonatomic, assign) id<ACGE_FullLineViewDelegate> delegate;

- (void) lineAnimationStart;

@end
