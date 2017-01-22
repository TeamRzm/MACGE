//
//  ACGEDirector.h
//  MACGE
//
//  Created by Martin.Ren on 2016/12/22.
//  Copyright © 2016年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MACGE_SCENE_CHANGED_ALPHIM_ANM) {
    MACGE_SCENE_CHANGED_ALPHIM_ANM_NONE,
    MACGE_SCENE_CHANGED_ALPHIM_ANM_TOP_TO_BOTTOM,
    MACGE_SCENE_CHANGED_ALPHIM_ANM_BOTTOM_TO_TOP,
    MACGE_SCENE_CHANGED_ALPHIM_ANM_LEFT_TO_RIGHT,
    MACGE_SCENE_CHANGED_ALPHIM_ANM_RIGHT_TO_LEFT,
};


@interface ACGEDirector : NSObject

@property (nonatomic, strong) UIView* screenView;

+ (instancetype) shareInstance;

//简单场景切换
- (void) screenChangedWithTitle : (NSString*) title
                       subTitle : (NSString*) subTitle
                      backgound : (UIImage*) bgimg;

//使用Alpha通道遮罩图片动画，就行场景切换
- (void) screenChangedWithTitle : (NSString*)   title
                       subTitle : (NSString*)   subTitle
             maskBacnGoundBgImg : (UIImage*)    maskBgimg
                 sceneBackgound : (UIImage*)    bgimg
                    alphaAnmImg : (UIImage*)    alphaImg
                        anmType : (MACGE_SCENE_CHANGED_ALPHIM_ANM) type;

//注册一个角色，并且分配资源
- (void) addActorWithIdentifier : (NSString *) actorIdentifier img : (UIImage *) imgFrame;

//按照参数显示角色
- (void) displayActorWithIdentifier : (NSString *) actorIdentifier InRect : (CGRect) frame;

//按照参数显示角色
- (void) displayActorWithIdnetifier : (NSString*) actorIdentifier postionStr : (NSString*) pString size : (CGSize) size;

//隐藏角色
- (void) hideActorWithIdentifier : (NSString*) actorIdentifier;

//移除一个角色的资源
- (void) deleteActorWithIdentifier : (NSString*) actorIdentifier;

//显示字幕内容
- (void) displayLineWithStr : (NSString*) lineStr actorName : (NSString*) actorName;

//隐藏字幕
- (void) hideLineView;

//黑屏字幕
- (void) fullLineViewWithContentString : (NSString*) string
                    singleLineduartion : (CGFloat) lineduartion
                        backgoundColor : (UIColor*) bgColor
                              fontSize : (CGFloat) fontSize
                             textColor : (UIColor*) textColor
                               bgimg   : (UIImage*) bgimg
                         textAlignment : (NSTextAlignment) alignment;

@end
