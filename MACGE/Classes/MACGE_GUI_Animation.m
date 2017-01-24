//
//  MACGE_GUI_Animation.m
//  MACGE
//
//  Created by Martin.Ren on 2017/1/20.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"

#import "MACGE.h"
#import "MACGE_GUI.h"
#import "ACGEDirector.h"

#import "UIColor+HEXString.h"

NSDictionary *MACGE_GUI_ANIMATION_KEYMAP;

extern id lual_checkObjectiveID(lua_State *L, int i, const char type[]);

static int MACGE_GUI_Animation_CreateForKey(lua_State *L)
{
    //id**
    POID p = (void**)lua_newuserdata(L, sizeof(POID));
    
    NSString *keyPath = NStr(luaL_checkstring(L, 1));
    
    NSString *animationKey = MACGE_GUI_ANIMATION_KEYMAP[keyPath];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:animationKey];
    
    *p = (__bridge void *)(animation);
    
    luaL_getmetatable(L, "MUI_Animation.CreateForKey");
    
    lua_setmetatable(L, -2);
    
    [[MACGE_GUI shareInstance] savePoid:p];
    
    return 1;
}

static int MACGE_GUI_Animation_Destory(lua_State *L)
{
    POID p = (POID)lua_touserdata(L, 1);
    
    [[MACGE_GUI shareInstance] deletePoid:p];
    
    return 0;
}

static int MACGE_GUI_Animation_SetFromValue(lua_State *L)
{
    CABasicAnimation *layerAnimation = (CABasicAnimation*)lual_checkObjectiveID(L, 1, "MUI_Animation.CreateForKey");
    
    float number = lua_tonumber(L, 2);
        
    layerAnimation.fromValue = @(number);
    
    return 0;
}


static int MACGE_GUI_Animation_SetToValue(lua_State *L)
{
    CABasicAnimation *layerAnimation = (CABasicAnimation*)lual_checkObjectiveID(L, 1, "MUI_Animation.CreateForKey");
    
    float number = lua_tonumber(L, 2);
    
    layerAnimation.toValue = @(number);
    
    return 0;
}


static int MACGE_GUI_Animation_SetDuration(lua_State *L)
{
    CABasicAnimation *layerAnimation = (CABasicAnimation*)lual_checkObjectiveID(L, 1, "MUI_Animation.CreateForKey");
    
    float number = lua_tonumber(L, 2);
    
    layerAnimation.duration = number;
    
    return 0;
}

static int MACGE_GUI_Animation_SetRepeatCount(lua_State *L)
{
    CABasicAnimation *layerAnimation = (CABasicAnimation*)lual_checkObjectiveID(L, 1, "MUI_Animation.CreateForKey");
    
    float number = lua_tonumber(L, 2);
    
    layerAnimation.repeatCount = number;
    
    return 0;
}

static int MACGE_GUI_Animation_SetAutoreverses(lua_State *L)
{
    CABasicAnimation *layerAnimation = (CABasicAnimation*)lual_checkObjectiveID(L, 1, "MUI_Animation.CreateForKey");
    
    BOOL autoreverses = lua_toboolean(L, 2);
    
    layerAnimation.autoreverses = autoreverses;
    
    return 0;
}

static int MACGE_GUI_Animation_SetRemovedOnCompletion(lua_State *L)
{
    CABasicAnimation *layerAnimation = (CABasicAnimation*)lual_checkObjectiveID(L, 1, "MUI_Animation.CreateForKey");
    
    BOOL removeOnCompletion = lua_toboolean(L, 2);
    
    layerAnimation.autoreverses = removeOnCompletion;
    
    return 0;
}


static const struct luaL_Reg MACGE_GUI_Animation_m [] = {
    {"SetFromValue",            MACGE_GUI_Animation_SetFromValue},
    {"SetToValue",              MACGE_GUI_Animation_SetToValue},
    {"SetDuration",             MACGE_GUI_Animation_SetDuration},
    {"SetRepeatCount",          MACGE_GUI_Animation_SetRepeatCount},
    {"SetAutoreverses",         MACGE_GUI_Animation_SetAutoreverses},
    {"SetRemovedOnCompletion",  MACGE_GUI_Animation_SetRemovedOnCompletion},
    {"__gc",                    MACGE_GUI_Animation_Destory},
    {NULL, NULL}
};

static luaL_Reg MACGE_GUI_Animation[] = {
    {"CreateForKey",          MACGE_GUI_Animation_CreateForKey},
    {NULL, NULL},
};

int private_OPEN_MACGE_GUI_Animation(lua_State* L)
{
    luaL_newmetatable(L, "MUI_Animation.CreateForKey");
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaL_setfuncs(L, MACGE_GUI_Animation_m, 0);
    luaL_newlib(L, MACGE_GUI_Animation);
    
    return 1;
}

int MACGE_Open_GUI_AnimationLib(lua_State* L)
{
    luaL_requiref(L,"MUI_Animation", private_OPEN_MACGE_GUI_Animation,1);

    MACGE_GUI_ANIMATION_KEYMAP = @{
                                   @"MACGE_GUI_ANIMATION_KEY_ROTATION_X"    : @"transform.rotation.x",
                                   @"MACGE_GUI_ANIMATION_KEY_ROTATION_Y"    : @"transform.rotation.y",
                                   @"MACGE_GUI_ANIMATION_KEY_ROTATION_Z"    : @"transform.rotation.z",
                                   
                                   @"MACGE_GUI_ANIMATION_KEY_SCALE_X"       : @"transform.scale.x",
                                   @"MACGE_GUI_ANIMATION_KEY_SCALE_Y"       : @"transform.scale.y",
                                   @"MACGE_GUI_ANIMATION_KEY_SCALE_Z"       : @"transform.scale.z",
                                   
                                   @"MACGE_GUI_ANIMATION_KEY_TRANSLATION_X" : @"transform.translation.x",
                                   @"MACGE_GUI_ANIMATION_KEY_TRANSLATION_Y" : @"transform.translation.y",
                                   @"MACGE_GUI_ANIMATION_KEY_TRANSLATION_Z" : @"transform.translation.z",
                                   };
    
    return 1;
}
