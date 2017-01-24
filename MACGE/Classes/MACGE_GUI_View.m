//
//  MACGE_GUI_View.m
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

static int MACGE_GUI_View_Create(lua_State *L)
{
    POID p = (void**)lua_newuserdata(L, sizeof(POID));
    
    UIView *newOCObject = [[UIView alloc] init];
    
    newOCObject.layer.masksToBounds = YES;
    
    newOCObject.userInteractionEnabled = YES;
    
    *p = (__bridge void *)(newOCObject);
    
    luaL_getmetatable(L, "MUI_View.Create");
    
    lua_setmetatable(L, -2);
    
    [[MACGE_GUI shareInstance] savePoid:p];
    
    return 1;
}

static int MACGE_GUI_View_Destory(lua_State *L)
{
    POID p = (POID)lua_touserdata(L, 1);
    
    [[MACGE_GUI shareInstance] deletePoid:p];
    
    return 0;
}

static int MACGE_GUI_View_SetFrame(lua_State *L)
{
    UIView *view = (UIView*)lual_checkObjectiveID(L, 1, "MUI_View.Create");
    
    float x = luaL_checknumber(L, 2);
    float y = luaL_checknumber(L, 3);
    float w = luaL_checknumber(L, 4);
    float h = luaL_checknumber(L, 5);
    
    view.frame = CGRectMake(x, y, w, h);
    
    return 0;
}


static int MACGE_GUI_View_GetFrame(lua_State *L)
{
    UIImageView *view = (UIImageView*)lual_checkObjectiveID(L, 1, "MUI_View.Create");
    
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

static int MACGE_GUI_View_AddSubView(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_View.Create");
    
    POID s = lua_touserdata(L, 2);
    
    UIView *subview = (__bridge UIView *)(*s);
    
    if (shareScreenView && subview)
    {
        [shareScreenView addSubview:subview];
    }
    
    return 0;
}

static int MACGE_GUI_View_SetBackGoundColor(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_View.Create");
    
    NSString *hexColor = NStr(luaL_checkstring(L, 2));
    
    float alpha = luaL_checknumber(L, 3);
    
    shareScreenView.backgroundColor = [UIColor colorWithHexString:hexColor alpha:alpha];
    
    return 0;
}

static int MACGE_GUI_View_AddAnimation(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_View.Create");
    
    POID s = lua_touserdata(L, 2);
    
    NSString *anmKey = NStr(luaL_checkstring(L, 3));
    
    CABasicAnimation *layAnimtion = (__bridge CABasicAnimation *)(*s);
    
    [shareScreenView.layer addAnimation:layAnimtion forKey:anmKey];
    
    return 0;
}

static int MACGE_GUI_View_RemoveAnimation(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_View.Create");
    
    NSString *anmKey = NStr(luaL_checkstring(L, 2));
    
    [shareScreenView.layer removeAnimationForKey:anmKey];
    
    return 0;
}

static int MACGE_GUI_View_RemovefromSuperview(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_View.Create");
    
    [shareScreenView removeFromSuperview];
    
    return 0;
}

static int MACGE_GUI_View_ClearView(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_View.Create");
    
    for (UIView *subView in shareScreenView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    return 0;
}

static const struct luaL_Reg MACGE_GUI_View_m [] = {
    
    {kMUI_SetFrame,             MACGE_GUI_View_SetFrame},
    {kMUI_GetFrame,             MACGE_GUI_View_GetFrame},
    {kMUI_AddSubview,           MACGE_GUI_View_AddSubView},
    {kMUI_SetBackGoundColor,    MACGE_GUI_View_SetBackGoundColor},
    {KMUI_ClearView,            MACGE_GUI_View_ClearView},
    {kMUI_Removeview,           MACGE_GUI_View_RemovefromSuperview},
    
    {kMUI_AddAnimation,         MACGE_GUI_View_AddAnimation},
    {kMUI_RemoveAnimation,      MACGE_GUI_View_RemoveAnimation},
    
    {"__gc",                    MACGE_GUI_View_Destory},
    {NULL, NULL}
};

static luaL_Reg MACGE_GUI_View[] = {
    {"Create",   MACGE_GUI_View_Create},
    {NULL, NULL},
};

int private_OPEN_MACGE_GUI_View(lua_State* L)
{
    luaL_newmetatable(L, "MUI_View.Create");
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaL_setfuncs(L, MACGE_GUI_View_m, 0);
    luaL_newlib(L, MACGE_GUI_View);
    
    return 1;
}

int MACGE_Open_GUI_ViewLib(lua_State* L)
{
    luaL_requiref(L,"MUI_View", private_OPEN_MACGE_GUI_View,1);
    
    return 1;
}


