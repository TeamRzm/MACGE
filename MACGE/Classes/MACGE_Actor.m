//
//  MACGE_Actor.m
//  MACGE
//
//  Created by Martin.Ren on 2016/12/22.
//  Copyright © 2016年 Martin.Ren. All rights reserved.
//

#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"
#import "ACGEDirector.h"
#import "MACGE.h"

static int MACGE_Actor_Add(lua_State *L)
{
    //音频文件路径
    const char *identifier = luaL_checkstring(L, 1);
    
    //音频标识符
    const char *imagePath = luaL_checkstring(L, 2);
    
    UIImage *bgImg = [[MACGE shareInstance].resHelper loadImageWithLocalPath:NStr(imagePath)];

    [[ACGEDirector shareInstance] addActorWithIdentifier:NStr(identifier) img:bgImg];
    
    return 1;
}

static int MACGE_Actor_Display(lua_State *L)
{
    const char *identifier = luaL_checkstring(L, 1);
    
    int dx = luaL_checknumber(L, 2);
    int dy = luaL_checknumber(L, 3);
    int dw = luaL_checknumber(L, 4);
    int dh = luaL_checknumber(L, 5);
    
    [[ACGEDirector shareInstance] displayActorWithIdentifier:NStr(identifier) InRect:CGRectMake(dx, dy, dw, dh)];
    
    return 1;
}

static int MACGE_Actor_DisplayAtSize(lua_State *L)
{
    const char *identifier = luaL_checkstring(L, 1);
    const char *postionStr = luaL_checkstring(L, 2);
    int dw = luaL_checknumber(L, 3);
    int dh = luaL_checknumber(L, 4);
    
    [[ACGEDirector shareInstance] displayActorWithIdnetifier:NStr(identifier) postionStr:NStr(postionStr) size:CGSizeMake(dw, dh)];
    
    return 1;
}

static int MACGE_Actor_Hide(lua_State *L)
{
   const char *identifier = luaL_checkstring(L, 1);
    [[ACGEDirector shareInstance] hideActorWithIdentifier:NStr(identifier)];
    return 1;
}

static int MACGE_Actor_Delete(lua_State *L)
{
    const char *identifier = luaL_checkstring(L, 1);
    [[ACGEDirector shareInstance] deleteActorWithIdentifier:NStr(identifier)];
    return 1;
}


static luaL_Reg MACGE_Scene_Lib[] = {
    
    {"Add",             MACGE_Actor_Add},
    {"Display",         MACGE_Actor_Display},
    {"DisplayAtSize",   MACGE_Actor_DisplayAtSize},
    {"Hide",            MACGE_Actor_Hide},
    {"Delete",          MACGE_Actor_Delete},
    {NULL, NULL},
};


int private_MACGE_OpenActorLib(lua_State* L)
{
    luaL_newlib(L,MACGE_Scene_Lib);
    
    return 1; //return one value
}

int MACGE_OpenActorLib(lua_State* L)
{
    luaL_requiref(L,"MACGE_Actor", private_MACGE_OpenActorLib,1);
    
    return 1;
}


