//
//  ACGEDirector.m
//  MACGE
//
//  Created by Martin.Ren on 2016/12/22.
//  Copyright © 2016年 Martin.Ren. All rights reserved.
//

#import "ACGEDirector.h"
#import "MACGE.h"
#import "MACGE_GUI.h"
#import "ACGE_Actor.h"
#import "ACGE_SimpleLine.h"
#import "ACGE_FullLineView.h"

@interface ACGEDirector()<CAAnimationDelegate,ACGE_FullLineViewDelegate>
{
    //Copy Anm Config;
    UIImageView *alphMaskView;
    MACGE_SCENE_CHANGED_ALPHIM_ANM anmType;
}

@property (nonatomic, strong) UIImageView       *backgoundView;
@property (nonatomic, strong) UIView            *maskScreenView;
@property (nonatomic, strong) ACGE_SimpleLine   *linesView;
@property (nonatomic, strong) NSMutableArray    *actorList;
@property (nonatomic, strong) NSMutableArray    *actorInSceneList;
@end

@implementation ACGEDirector

+ (instancetype) shareInstance
{
    static ACGEDirector *staticDirector;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticDirector = [[ACGEDirector alloc] init];
    });
    
    return staticDirector;
}

- (void) setScreenView:(UIView *) t_screenView
{
    _screenView = t_screenView;
    
    [MACGE_GUI shareInstance].currentScreenView = _screenView;
    
    [_screenView addSubview:self.backgoundView];
    [_screenView addSubview:self.linesView];
    
    UITapGestureRecognizer *screenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapAction:)];
    _screenView.userInteractionEnabled = YES;
    [_screenView addGestureRecognizer:screenTap];
    
    return ;
}

- (void) displayLineWithStr : (NSString*) lineStr actorName : (NSString*) actorName
{
    if (self.linesView.alpha < 1.0f)
    {
        [UIView animateWithDuration:.25f animations:^{
            self.linesView.alpha = 1.0f;
        }];
    }
    
    [self.linesView displayLineString:lineStr actorName:actorName];
    
    [self alphaOtherActor:[self findActorWithIdentifier:actorName]];
    
    return;
}

- (void) hideLineView
{
    if (self.linesView.alpha > 0)
    {
        [UIView animateWithDuration:.25f animations:^{
            self.linesView.alpha = 0.0f;
        }];
    }
}

- (void) fullLineViewWithContentString : (NSString*) string
                    singleLineduartion : (CGFloat) lineduartion
                        backgoundColor : (UIColor*) bgColor
                              fontSize : (CGFloat) fontSize
                             textColor : (UIColor*) textColor
                               bgimg   : (UIImage*) bgimg
                         textAlignment : (NSTextAlignment) alignment
{
    ACGE_FullLineView *fullLineView = [[ACGE_FullLineView alloc] initWithFrame:CGRectMake(0,
                                                                                          0,
                                                                                          self.screenView.frame.size.width,
                                                                                          self.screenView.frame.size.height)];
    fullLineView.delegate = self;
    fullLineView.backgroundColor = bgColor;
    fullLineView.font = [UIFont systemFontOfSize:fontSize];
    fullLineView.textAlignment = alignment;
    fullLineView.textColor = textColor;
    fullLineView.singleLineduartion = lineduartion;
    fullLineView.text = string;
    fullLineView.image = bgimg;
    
    fullLineView.alpha = 0.0f;
    
    [self.screenView addSubview:fullLineView];
    
    [UIView animateWithDuration:1.0f animations:^{
        fullLineView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [fullLineView lineAnimationStart];
    }];
    
    return ;
}


- (void) screenTapAction : (UITapGestureRecognizer*) gesture
{
    [[MACGE shareInstance] sendEventToScript:MACGE_EVENT_TOUCH_SCREEN];
    
    return ;
}

- (void) screenChangedWithTitle : (NSString*) title
                       subTitle : (NSString*) subTitle
                      backgound : (UIImage*) bgimg
{
    self.screenView.userInteractionEnabled = NO;
    
    self.backgoundView.image = bgimg;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:20.0f];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.maskScreenView addSubview:titleLabel];
    
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 2.5f;
    
    //设置运动type
    animation.type = @"rippleEffect";
    
    animation.delegate = self;
    
    //设置运动速度
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.screenView.layer addAnimation:animation forKey:@"animation"];
    
    [self.screenView addSubview:self.maskScreenView];

    return ;
}

- (void) screenChangedWithTitle : (NSString*)   title
                       subTitle : (NSString*)   subTitle
             maskBacnGoundBgImg : (UIImage*)    maskBgimg
                 sceneBackgound : (UIImage*)    bgimg
                    alphaAnmImg : (UIImage*)    alphaImg
                        anmType : (MACGE_SCENE_CHANGED_ALPHIM_ANM) type
{
    self.screenView.userInteractionEnabled = NO;
    
    for (UIView *subView in self.maskScreenView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    //场景切换的标题页面背景图片
    UIImageView *maskBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.screenView.frame), CGRectGetHeight(self.screenView.frame))];
    maskBgView.image = maskBgimg;
    [self.maskScreenView addSubview:maskBgView];
    
    
    //主标题
    UILabel *headTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.screenView.frame) - 40, CGRectGetHeight(self.screenView.frame))];
    headTitleLb.textAlignment = NSTextAlignmentCenter;
    headTitleLb.font = [UIFont boldSystemFontOfSize:20.0f];
    headTitleLb.textColor = [UIColor darkGrayColor];
    headTitleLb.numberOfLines = 0;
    headTitleLb.text = title;
    [self.maskScreenView addSubview:headTitleLb];
    
    
    //子标题
    UILabel *subTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(self.screenView.frame) - 45.0f, CGRectGetWidth(self.screenView.frame) - 40, 40.0f)];
    subTitleLb.textAlignment = NSTextAlignmentCenter;
    subTitleLb.font = [UIFont systemFontOfSize:15.0f];
    subTitleLb.numberOfLines = 0;
    subTitleLb.textColor = [UIColor darkGrayColor];
    subTitleLb.text = subTitle;
    subTitleLb.alpha = .85f;
    [self.maskScreenView addSubview:subTitleLb];
    [self.screenView addSubview:self.maskScreenView];
    
    //alphaAnmMask
    UIImageView *anmMaskAlphaView = [[UIImageView alloc] init];
    
    CGRect resultFrame = CGRectZero;
    
    switch (type)
    {
        case MACGE_SCENE_CHANGED_ALPHIM_ANM_TOP_TO_BOTTOM:
        {
            resultFrame = CGRectMake(0,
                                     -(CGRectGetHeight(self.maskScreenView.frame) * 2.0f),
                                     CGRectGetWidth(self.maskScreenView.frame),
                                     CGRectGetHeight(self.maskScreenView.frame) * 2.0f
                                     );
        }
            break;
            
        case MACGE_SCENE_CHANGED_ALPHIM_ANM_BOTTOM_TO_TOP:
        {
            resultFrame = CGRectMake(0,
                                     (CGRectGetHeight(self.maskScreenView.frame) * 2.0f),
                                     CGRectGetWidth(self.maskScreenView.frame),
                                     CGRectGetHeight(self.maskScreenView.frame) * 2.0f
                                     );
        }
            break;
            
        case MACGE_SCENE_CHANGED_ALPHIM_ANM_LEFT_TO_RIGHT:
        {
            resultFrame = CGRectMake(-CGRectGetWidth(self.maskScreenView.frame) * 2.0f,
                                     0,
                                     CGRectGetWidth(self.maskScreenView.frame) * 2.0f,
                                     CGRectGetHeight(self.maskScreenView.frame)
                                     );
        }
            break ;
            
        case MACGE_SCENE_CHANGED_ALPHIM_ANM_RIGHT_TO_LEFT:
        {
            resultFrame = CGRectMake(CGRectGetWidth(self.maskScreenView.frame) * 2.0f,
                                     0,
                                     CGRectGetWidth(self.maskScreenView.frame) * 2.0f,
                                     CGRectGetHeight(self.maskScreenView.frame)
                                     );
        }
            break ;
            
        case MACGE_SCENE_CHANGED_ALPHIM_ANM_NONE:
        {
            
        }
        default:
            break;
    }
    
    anmMaskAlphaView.frame = resultFrame;
    anmMaskAlphaView.image = alphaImg;
    anmMaskAlphaView.backgroundColor = [UIColor clearColor];
    
    self.maskScreenView.maskView = anmMaskAlphaView;
    
    
    //备份动画配置
    alphMaskView = anmMaskAlphaView;
    anmType = type;
    
    [UIView animateWithDuration:.8f animations:^{
        
        anmMaskAlphaView.frame = CGRectMake(0, 0, CGRectGetWidth(resultFrame), CGRectGetHeight(resultFrame));
        
    } completion:^(BOOL finished) {
        
        self.backgoundView.image = bgimg;
        self.screenView.userInteractionEnabled = YES;
        
        for (ACGE_Actor *subActor in self.actorList)
        {
            [subActor.displayView removeFromSuperview];
        }
        
        [self.actorList removeAllObjects];
        [self.actorInSceneList removeAllObjects];
    }];
    
    return ;
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //释放所有场景使用的资源
    
    //演员
    for (ACGE_Actor *subActor in self.actorList)
    {
        [subActor.displayView removeFromSuperview];
    }
    
    [self.actorList removeAllObjects];
    [self.actorInSceneList removeAllObjects];
    
    self.screenView.userInteractionEnabled = YES;
}

- (UIImageView*) backgoundView
{
    if (!_backgoundView)
    {
        _backgoundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    return _backgoundView;
}

- (UIView*) maskScreenView
{
    if (!_maskScreenView)
    {
        _maskScreenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        _maskScreenView.backgroundColor = [UIColor colorWithWhite:.2f alpha:1.0f];
        
        UITapGestureRecognizer *maskTapToHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMaskView)];
        
        _maskScreenView.userInteractionEnabled = YES;
        [_maskScreenView addGestureRecognizer:maskTapToHide];
    }
    
    return _maskScreenView;
}

- (void) hideMaskView
{
    
    if (anmType != MACGE_SCENE_CHANGED_ALPHIM_ANM_NONE)
    {
        self.screenView.userInteractionEnabled = NO;
        
        CGRect resultFrame = CGRectZero;
        
        switch (anmType)
        {
            case MACGE_SCENE_CHANGED_ALPHIM_ANM_TOP_TO_BOTTOM:
            {
                resultFrame = CGRectMake(0,
                                         -(CGRectGetHeight(self.maskScreenView.frame) * 2.0f),
                                         CGRectGetWidth(self.maskScreenView.frame),
                                         CGRectGetHeight(self.maskScreenView.frame) * 2.0f
                                         );
            }
                break;
                
            case MACGE_SCENE_CHANGED_ALPHIM_ANM_BOTTOM_TO_TOP:
            {
                resultFrame = CGRectMake(0,
                                         (CGRectGetHeight(self.maskScreenView.frame) * 2.0f),
                                         CGRectGetWidth(self.maskScreenView.frame),
                                         CGRectGetHeight(self.maskScreenView.frame) * 2.0f
                                         );
            }
                break;
                
            case MACGE_SCENE_CHANGED_ALPHIM_ANM_LEFT_TO_RIGHT:
            {
                resultFrame = CGRectMake(-CGRectGetWidth(self.maskScreenView.frame) * 2.0f,
                                         0,
                                         CGRectGetWidth(self.maskScreenView.frame) * 2.0f,
                                         CGRectGetHeight(self.maskScreenView.frame)
                                         );
            }
                break ;
                
            case MACGE_SCENE_CHANGED_ALPHIM_ANM_RIGHT_TO_LEFT:
            {
                resultFrame = CGRectMake(CGRectGetWidth(self.maskScreenView.frame) * 2.0f,
                                         0,
                                         CGRectGetWidth(self.maskScreenView.frame) * 2.0f,
                                         CGRectGetHeight(self.maskScreenView.frame)
                                         );
            }
                break ;
                
            case MACGE_SCENE_CHANGED_ALPHIM_ANM_NONE:
            {
                
            }
            default:
                break;
        }
        
        [UIView animateWithDuration:.8f animations:^{
            
            alphMaskView.frame = resultFrame;
            
        } completion:^(BOOL finished) {
            [self.maskScreenView removeFromSuperview];
            self.maskScreenView = nil;
            self.screenView.userInteractionEnabled = YES;
        }];
    }
    else
    {
        [UIView animateWithDuration:1.0f animations:^{
            self.maskScreenView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.maskScreenView removeFromSuperview];
            self.maskScreenView = nil;
        }];
    }
}


#pragma mark -- Acotr
- (NSMutableArray*) actorList
{
    if (!_actorList)
    {
        _actorList = [[NSMutableArray alloc] init];
    }
    
    return _actorList;
}

- (NSMutableArray*) actorInSceneList
{
    if (!_actorInSceneList)
    {
        _actorInSceneList = [[NSMutableArray alloc] init];
    }
    
    return _actorInSceneList;
}

- (ACGE_SimpleLine*) linesView
{
    if (!_linesView)
    {
        _linesView = [ACGE_SimpleLine LineView];
        _linesView.alpha = 0.0f;
    }
    return _linesView;
}

- (ACGE_Actor*) findActorWithIdentifier : (NSString*) identifier
{
    for (ACGE_Actor *subActor in self.actorList)
    {
        if ([subActor.identifier isEqualToString:identifier])
        {
            return subActor;
        }
    }
    return nil;
}

- (void) addActorWithIdentifier : (NSString *) actorIdentifier img : (UIImage *) imgFrame
{
    if (![self findActorWithIdentifier:actorIdentifier])
    {
        ACGE_Actor *newActor = [[ACGE_Actor alloc] init];
        newActor.identifier = actorIdentifier;
        newActor.img = imgFrame;
        newActor.frame = CGRectZero;
        
        [self.actorList addObject:newActor];
    }
}

- (void) alphaOtherActor : (ACGE_Actor*) currAcotr
{
    [UIView animateWithDuration:.25f animations:^{
        
        for (ACGE_Actor *suba in self.actorInSceneList)
        {
            if (suba != currAcotr)
            {
                suba.displayView.alpha = 0.20;
            }
            else
            {
                suba.displayView.alpha = 1.0f;
            }
        }
    }];
}

- (void) displayActorWithIdentifier : (NSString *) actorIdentifier InRect : (CGRect) frame
{
    ACGE_Actor *actor = [self findActorWithIdentifier:actorIdentifier];
    
    if (actor)
    {
        actor.frame = frame;
        
        [self.screenView addSubview:actor.displayView];
        [self.screenView bringSubviewToFront:actor.displayView];
        [self.screenView bringSubviewToFront:self.linesView];
        
        [self.actorInSceneList addObject:actor];
        
        if (actor.displayView.alpha > 0.0)
        {
            //说明已经上台，只需要移动
            [UIView animateWithDuration:.25f delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                actor.frame = frame;
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            [UIView animateWithDuration:.25f animations:^{
                actor.displayView.alpha = 1.0f;
                
            } completion:^(BOOL finished) {
                
            }];
        }
        
        if (![self.actorInSceneList containsObject:actor])
        {
            [self.actorInSceneList addObject:actor];
        }
    }
    
    return ;
}

- (void) displayActorWithIdnetifier : (NSString*) actorIdentifier postionStr : (NSString*) pString size : (CGSize) size
{
    ACGE_Actor *actor = [self findActorWithIdentifier:actorIdentifier];
    
    if (actor)
    {
        CGRect frame;
        
        if ( [pString isEqualToString:@"LEFT"] )
        {
            frame = CGRectMake(10, self.screenView.frame.size.height - size.height, size.width, size.height);
        }
        else if ( [pString isEqualToString:@"RIGHT"] )
        {
            frame = CGRectMake(self.screenView.frame.size.width - size.width - 10, self.screenView.frame.size.height - size.height, size.width, size.height);
        }
        else //Center
        {
            frame = CGRectMake(self.screenView.frame.size.width / 2.0f - size.width / 2.0f,
                               self.screenView.frame.size.height - size.height,
                               size.width, size.height);
        }
        
        [self.screenView addSubview:actor.displayView];
        
        [self.screenView bringSubviewToFront:actor.displayView];
        [self.screenView bringSubviewToFront:self.linesView];
        
        [self.actorInSceneList addObject:actor];
        
        if (actor.displayView.alpha > 0.0)
        {
            //说明已经上台，只需要移动
            [UIView animateWithDuration:.25f delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                actor.frame = frame;
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            actor.frame = frame;
            
            [UIView animateWithDuration:.25f animations:^{
                actor.displayView.alpha = 1.0f;
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (void) hideActorWithIdentifier : (NSString*) actorIdentifier
{
    ACGE_Actor *actor = [self findActorWithIdentifier:actorIdentifier];
    
    if (actor && actor.displayView.superview)
    {
        actor.displayView.alpha = 1.0f;
        
        [UIView animateWithDuration:.25f animations:^{
            actor.displayView.alpha = 0.0f;
            
        } completion:^(BOOL finished) {

        }];
    }
    
    [self.actorInSceneList removeObject:actor];
    
    return ;
}

- (void) deleteActorWithIdentifier : (NSString*) actorIdentifier
{
    ACGE_Actor *actor = [self findActorWithIdentifier:actorIdentifier];
    
    if (actor && actor.displayView.superview)
    {
        [UIView animateWithDuration:.25f animations:^{
            actor.displayView.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            [actor.displayView removeFromSuperview];
            [self.actorList removeObject:actor];
        }];
    }
    
    [self.actorInSceneList removeObject:actor];
    
    return ;
}

#pragma mark FullLineViewDelegate
- (void)fullLineViewDidEndAnimation:(ACGE_FullLineView *)lineView
{
    return ;
}

- (void) fullLineViewDidTapAnimationoView:(ACGE_FullLineView *)lineView
{
    [UIView animateWithDuration:.25f animations:^{
        lineView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [lineView removeFromSuperview];
    }];
    return ;
}

@end
