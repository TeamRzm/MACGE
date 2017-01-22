//
//  MACGE_GUI_Point.m
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

static int MACGE_GUI_Point_Create(lua_State *L)
{
    void* p = (void*)lua_newuserdata(L, sizeof(CGPoint));
    
    *((CGPoint*)p) = CGPointMake(0,0);
    
    luaL_getmetatable(L, "MACGE_GUI_Point_Create");
    
    lua_setmetatable(L, -2);
    
    return 1;
}

static int MACGE_GUI_Point_Destory(lua_State *L)
{
    void* p = (void*)lua_touserdata(L, 1);
    
    free(p);
    
    p = NULL;
    
    return 0;
}

static int MACGE_GUI_Point_SetX(lua_State *L)
{
    void* p = (void*)lua_newuserdata(L, sizeof(CGPoint));
    
    float x = luaL_checknumber(L, 2);
    
    ((CGPoint*)p)->x = x;
    
    return 0;
}

static int MACGE_GUI_Point_GetX(lua_State *L)
{
    void* p = (void*)lua_newuserdata(L, sizeof(CGPoint));
    
    lua_pushnumber(L, ((CGPoint*)p)->x);
    
    return 1;
}

static int MACGE_GUI_Point_SetY(lua_State *L)
{
    void* p = (void*)lua_newuserdata(L, sizeof(CGPoint));
    
    float y = luaL_checknumber(L, 2);
    
    ((CGPoint*)p)->y = y;
    
    return 0;
}

static int MACGE_GUI_Point_GetY(lua_State *L)
{
    void* p = (void*)lua_newuserdata(L, sizeof(CGPoint));
    
    lua_pushnumber(L, ((CGPoint*)p)->y);
    
    return 1;
}


static const struct luaL_Reg MACGE_GUI_Point_m [] = {
    {"SetX",             MACGE_GUI_Point_SetX},
    {"GetX",             MACGE_GUI_Point_GetX},
    {"SetY",             MACGE_GUI_Point_SetY},
    {"GetY",             MACGE_GUI_Point_GetY},
    
    {"__gc",                    MACGE_GUI_Point_Destory},
    {NULL, NULL}
};

static luaL_Reg MACGE_GUI_Point[] = {
    {"Create",   MACGE_GUI_Point_Create},
    {NULL, NULL},
};

int private_OPEN_MACGE_GUI_Point(lua_State* L)
{
    luaL_newmetatable(L, "MUI_Point.Create");
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaL_setfuncs(L, MACGE_GUI_Point_m, 0);
    luaL_newlib(L, MACGE_GUI_Point);
    
    return 1;
}

int MACGE_Open_GUI_PointLib(lua_State* L)
{
    luaL_requiref(L,"MUI_Point", private_OPEN_MACGE_GUI_Point,1);
    
    return 1;
}


