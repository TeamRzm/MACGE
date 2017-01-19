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

- (void) screenChangedWithTitle : (NSString*) title
                       subTitle : (NSString*) subTitle
                      backgound : (UIImage*) bgimg;

- (void) screenChangedWithTitle : (NSString*)   title
                       subTitle : (NSString*)   subTitle
             maskBacnGoundBgImg : (UIImage*)    maskBgimg
                 sceneBackgound : (UIImage*)    bgimg
                    alphaAnmImg : (UIImage*)    alphaImg
                        anmType : (MACGE_SCENE_CHANGED_ALPHIM_ANM) type;

- (void) addActorWithIdentifier : (NSString *) actorIdentifier img : (UIImage *) imgFrame;

- (void) displayActorWithIdentifier : (NSString *) actorIdentifier InRect : (CGRect) frame;

- (void) displayActorWithIdnetifier : (NSString*) actorIdentifier postionStr : (NSString*) pString size : (CGSize) size;

- (void) hideActorWithIdentifier : (NSString*) actorIdentifier;

- (void) deleteActorWithIdentifier : (NSString*) actorIdentifier;

- (void) displayLineWithStr : (NSString*) lineStr actorName : (NSString*) actorName;

- (void) hideLineView;

@end
