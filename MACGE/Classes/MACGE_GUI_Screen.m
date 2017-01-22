//
//  MACGE_GUI_Screen.m
//  MACGE
//
//  Created by Martin.Ren on 2017/1/13.
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

extern id lual_checkObjectiveID(lua_State *L, int i, const char type[]);

static int MACGE_GUI_Screen_ShareInstance(lua_State *L)
{
    //id**
    POID p = (void**)lua_newuserdata(L, sizeof(POID));
    
    UIView *newOCObject = [ACGEDirector shareInstance].screenView;
    
    *p = (__bridge void *)(newOCObject);
    
    luaL_getmetatable(L, "MUI_Screen.ShareInstance");
    
    lua_setmetatable(L, -2);
    
    return 1;
}

static int MACGE_GUI_Screen_Destory(lua_State *L)
{
    return 0;
}

static int MACGE_GUI_Screen_GetFrame(lua_State *L)
{
    UIImageView *view = (UIImageView*)lual_checkObjectiveID(L, 1, "MUI_Screen.ShareInstance");
    
    float x = view.frame.origin.x;
    float y = view.frame.origin.y;
    float w = view.frame.size.width;
    float h = view.frame.size.height;
    
    lua_pushnumber(L, x);
    lua_pushnumber(L, y);
    lua_pushnumber(L, w);
    lua_pushnumber(L, h);
    
    return 4;
}

static int MACGE_GUI_Screen_AddSubView(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_Screen.ShareInstance");

    POID s = lua_touserdata(L, 2);
    
    UIView *subview = (__bridge UIView *)(*s);
    
    if (shareScreenView && subview)
    {
        [shareScreenView addSubview:subview];
    }
    
    return 0;
}

static int MACGE_GUI_Screen_SetBackGoundColor(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_Screen.ShareInstance");
    
    NSString *hexColor = NStr(luaL_checkstring(L, 2));
    
    float alpha = luaL_checknumber(L, 3);
    
    shareScreenView.backgroundColor = [UIColor colorWithHexString:hexColor alpha:alpha];
    
    return 0;
}


static int MACGE_GUI_Screen_AddAnimation(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_View.Create");
    
    POID s = lua_touserdata(L, 2);
    
    NSString *anmKey = NStr(luaL_checkstring(L, 3));
    
    CABasicAnimation *layAnimtion = (__bridge CABasicAnimation *)(*s);
    
    [shareScreenView.layer addAnimation:layAnimtion forKey:anmKey];
    
    return 0;
}

static int MACGE_GUI_Screen_RemoveAnimation(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_View.Create");
    
    NSString *anmKey = NStr(luaL_checkstring(L, 2));
    
    [shareScreenView.layer removeAnimationForKey:anmKey];
    
    return 0;
}


static const struct luaL_Reg MACGE_GUI_Screen_m [] = {
    
    {kMUI_GetFrame,             MACGE_GUI_Screen_GetFrame},
    {kMUI_AddSubview,           MACGE_GUI_Screen_AddSubView},
    {kMUI_SetBackGoundColor,    MACGE_GUI_Screen_SetBackGoundColor},
    
    {kMUI_AddAnimation,         MACGE_GUI_Screen_AddAnimation},
    {kMUI_RemoveAnimation,      MACGE_GUI_Screen_RemoveAnimation},
    
    {"__gc",                    MACGE_GUI_Screen_Destory},
    {NULL, NULL}
};

static luaL_Reg MACGE_GUI_Screen[] = {
    {"ShareInstance",   MACGE_GUI_Screen_ShareInstance},
    {NULL, NULL},
};

int private_OPEN_MACGE_GUI_Screen(lua_State* L)
{
    luaL_newmetatable(L, "MUI_Screen.ShareInstance");
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaL_setfuncs(L, MACGE_GUI_Screen_m, 0);
    luaL_newlib(L, MACGE_GUI_Screen);
    
    return 1;
}

int MACGE_Open_GUI_ScreenLib(lua_State* L)
{
    luaL_requiref(L,"MUI_Screen", private_OPEN_MACGE_GUI_Screen,1);
    
    return 1;
}


