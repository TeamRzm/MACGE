//
//  MACGE_GUI_Size.m
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

static int MACGE_GUI_Size_Create(lua_State *L)
{
    void* p = (void*)lua_newuserdata(L, sizeof(CGSize));
    
    *((CGSize*)p) = CGSizeMake(0, 0);
    
    luaL_getmetatable(L, "MUI_Size.Create");
    
    lua_setmetatable(L, -2);
    
    return 1;
}

static int MACGE_GUI_Size_Destory(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Size.Create");
    
    free(p);
    
    p = NULL;
    
    return 0;
}

static int MACGE_GUI_Size_SetW(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Size.Create");
    
    float w = luaL_checknumber(L, 2);
    
    ((CGSize*)p)->width = w;
    
    return 0;
}

static int MACGE_GUI_Size_GetW(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Size.Create");
    
    lua_pushnumber(L, ((CGSize*)p)->width);
    
    return 1;
}

static int MACGE_GUI_Size_SetH(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Size.Create");
    
    float h = luaL_checknumber(L, 2);
    
    ((CGSize*)p)->height = h;
    
    return 0;
}

static int MACGE_GUI_Size_GetH(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Size.Create");
    
    lua_pushnumber(L, ((CGSize*)p)->height);
    
    return 1;
}


static const struct luaL_Reg MACGE_GUI_Size_m [] = {
    
    {"SetW",            MACGE_GUI_Size_SetW},
    {"GetW",            MACGE_GUI_Size_GetW},
    {"SetH",            MACGE_GUI_Size_SetH},
    {"GetH",            MACGE_GUI_Size_GetH},
    
    {"__gc",            MACGE_GUI_Size_Destory},
    {NULL, NULL}
};

static luaL_Reg MACGE_GUI_Size[] = {
    {"Create",   MACGE_GUI_Size_Create},
    {NULL, NULL},
};

int private_OPEN_MACGE_GUI_Size(lua_State* L)
{
    luaL_newmetatable(L, "MUI_Size.Create");
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaL_setfuncs(L, MACGE_GUI_Size_m, 0);
    luaL_newlib(L, MACGE_GUI_Size);
    
    return 1;
}

int MACGE_Open_GUI_SizeLib(lua_State* L)
{
    luaL_requiref(L,"MUI_Size", private_OPEN_MACGE_GUI_Size,1);
    
    return 1;
}


