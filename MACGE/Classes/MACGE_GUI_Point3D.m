//
//  MACGE_GUI_Point3D.m
//  MACGE
//
//  Created by Martin.Ren on 2017/1/22.
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

static int MACGE_GUI_Point3D_Create(lua_State *L)
{
    void* p = (void*)lua_newuserdata(L, sizeof(Point3D));
    
    Point3D *newPoint = (Point3D*)malloc(sizeof(Point3D));
    
    newPoint->x = 0;
    newPoint->y = 0;
    newPoint->z = 0;
    
    *((Point3D*)p) = *newPoint;
    
    luaL_getmetatable(L, "MUI_Point3D.Create");
    
    lua_setmetatable(L, -2);
    
    return 1;
}

static int MACGE_GUI_Point3D_Destory(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Point3D.Create");
    
    free(p);
    
    p = NULL;
    
    return 0;
}

static int MACGE_GUI_Point3D_SetX(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Point3D.Create");
    
    float x = luaL_checknumber(L, 2);
    
    ((Point3D*)p)->x = x;
    
    return 0;
}

static int MACGE_GUI_Point3D_GetX(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Point3D.Create");
    
    lua_pushnumber(L, ((Point3D*)p)->x);
    
    return 1;
}

static int MACGE_GUI_Point3D_SetY(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Point3D.Create");
    
    float y = luaL_checknumber(L, 2);
    
    ((Point3D*)p)->y = y;
    
    return 0;
}

static int MACGE_GUI_Point3D_GetY(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Point3D.Create");
    
    lua_pushnumber(L, ((Point3D*)p)->y);
    
    return 1;
}

static int MACGE_GUI_Point3D_SetZ(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Point3D.Create");
    
    float z = luaL_checknumber(L, 2);
    
    ((Point3D*)p)->z = z;
    
    return 0;
}

static int MACGE_GUI_Point3D_GetZ(lua_State *L)
{
    void *p = (void *)luaL_checkudata(L, 1, "MUI_Point3D.Create");
    
    lua_pushnumber(L, ((Point3D*)p)->z);
    
    return 1;
}


static const struct luaL_Reg MACGE_GUI_Point3D_m [] = {
    
    {"SetX",            MACGE_GUI_Point3D_SetX},
    {"GetX",            MACGE_GUI_Point3D_GetX},
    {"SetY",            MACGE_GUI_Point3D_SetY},
    {"GetY",            MACGE_GUI_Point3D_GetY},
    {"SetZ",            MACGE_GUI_Point3D_SetZ},
    {"GetZ",            MACGE_GUI_Point3D_GetZ},
    
    {"__gc",            MACGE_GUI_Point3D_Destory},
    {NULL, NULL}
};

static luaL_Reg MACGE_GUI_Point3D[] = {
    {"Create",   MACGE_GUI_Point3D_Create},
    {NULL, NULL},
};

int private_OPEN_MACGE_GUI_Point3D(lua_State* L)
{
    luaL_newmetatable(L, "MUI_Point3D.Create");
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaL_setfuncs(L, MACGE_GUI_Point3D_m, 0);
    luaL_newlib(L, MACGE_GUI_Point3D);
    
    return 1;
}

int MACGE_Open_GUI_Point3DLib(lua_State* L)
{
    luaL_requiref(L,"MUI_Point3D", private_OPEN_MACGE_GUI_Point3D,1);
    
    return 1;
}


