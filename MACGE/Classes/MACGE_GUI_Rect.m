//
//  MACGE_GUI_Rect.m
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

extern id lual_checkObjectiveID(lua_State *L, int i, const char type[]);

static int MACGE_GUI_Rect_Create(lua_State *L)
{
    void* p = (void*)lua_newuserdata(L, sizeof(CGRect));
    
    *((CGRect*)p) = CGRectZero;
    
    luaL_getmetatable(L, "MUI_Rect.Create");
    
    lua_setmetatable(L, -2);
    
    return 1;
}

static int MACGE_GUI_Rect_Destory(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Rect.Create");
    
    free(p);
    
    p = NULL;
    
    return 0;
}

static int MACGE_GUI_Rect_SetX(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Rect.Create");
    
    float x = luaL_checknumber(L, 2);
    
    ((CGRect*)p)->origin.x = x;
    
    return 0;
}

static int MACGE_GUI_Rect_GetX(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Rect.Create");
    
    lua_pushnumber(L, ((CGRect*)p)->origin.x);
    
    return 1;
}

static int MACGE_GUI_Rect_SetY(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Rect.Create");
    
    float y = luaL_checknumber(L, 2);
    
    ((CGRect*)p)->origin.y = y;
    
    return 0;
}

static int MACGE_GUI_Rect_GetY(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Rect.Create");
    
    lua_pushnumber(L, ((CGRect*)p)->origin.y);
    
    return 1;
}


static int MACGE_GUI_Rect_SetW(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Rect.Create");
    
    float w = luaL_checknumber(L, 2);
    
    ((CGRect*)p)->size.width = w;
    
    return 0;
}

static int MACGE_GUI_Rect_GetW(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Rect.Create");
    
    lua_pushnumber(L, ((CGRect*)p)->size.width);
    
    return 1;
}

static int MACGE_GUI_Rect_SetH(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Rect.Create");
    
    float h = luaL_checknumber(L, 2);
    
    ((CGRect*)p)->size.height = h;
    
    return 0;
}

static int MACGE_GUI_Rect_GetH(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Rect.Create");
    
    lua_pushnumber(L, ((CGRect*)p)->size.height);
    
    return 1;
}


static const struct luaL_Reg MACGE_GUI_Rect_m [] = {
    
    {"SetX",            MACGE_GUI_Rect_SetX},
    {"GetX",            MACGE_GUI_Rect_GetX},
    {"SetY",            MACGE_GUI_Rect_SetY},
    {"GetY",            MACGE_GUI_Rect_GetY},
    {"SetW",            MACGE_GUI_Rect_SetW},
    {"GetW",            MACGE_GUI_Rect_GetW},
    {"SetH",            MACGE_GUI_Rect_SetH},
    {"GetH",            MACGE_GUI_Rect_GetH},
    
    {"__gc",            MACGE_GUI_Rect_Destory},
    {NULL, NULL}
};

static luaL_Reg MACGE_GUI_Rect[] = {
    {"Create",   MACGE_GUI_Rect_Create},
    {NULL, NULL},
};

int private_OPEN_MACGE_GUI_Rect(lua_State* L)
{
    luaL_newmetatable(L, "MUI_Rect.Create");
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaL_setfuncs(L, MACGE_GUI_Rect_m, 0);
    luaL_newlib(L, MACGE_GUI_Rect);
    
    return 1;
}

int MACGE_Open_GUI_RectLib(lua_State* L)
{
    luaL_requiref(L,"MUI_Rect", private_OPEN_MACGE_GUI_Rect,1);
    
    return 1;
}


