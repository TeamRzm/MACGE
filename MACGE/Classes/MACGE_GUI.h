//
//  MACGE_GUI.h
//  MACGE
//
//  Created by Martin.Ren on 2017/1/13.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"

//point of id
typedef void** POID;

id lual_checkObjectiveID(lua_State *L, int i, const char type[]);

@interface MACGE_GUI : NSObject

@property (nonatomic, strong) UIView *currentScreenView;

+ (instancetype) shareInstance;

- (void) destoryAll;

- (void) savePoid : (POID) poidPoint;

- (void) deletePoid : (POID) poidPoint;

@end


//成员属性名称，防治写错或者弄错大小写
#define kMUI_AddSubview                 "AddSubview"
#define kMUI_SetImage                   "SetImage"
#define kMUI_SetFrame                   "SetFrame"
#define kMUI_GetFrame                   "GetFrame"
#define kMUI_SetBackGoundColor          "SetBackGoundColor"
