//
//  MACGE.h
//  MACGE
//
//  Created by Martin.Ren on 2016/12/22.
//  Copyright © 2016年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ACGE_ResHelper.h"

typedef void(^MACGE_SIMPLE_BLOCK)(void);

typedef NS_ENUM(NSUInteger, MACGE_EVENT) {
    MACGE_EVENT_TOUCH_SCREEN,
};

@interface MACGE : NSObject

@property (nonatomic, copy) NSString* baseResPath;
@property (nonatomic, strong) ACGE_ResHelper *resHelper;

+ (instancetype) shareInstance;

- (void) beginGameWithScriptName : (NSString*) filename;
- (void) beginGameWithPack : (NSString*) packFile;

//LUA 回调函数原型 function MACGE_Event_Handle(event, userinfo); event 为字符串
- (void) sendEventToScript : (MACGE_EVENT) event;

@end
