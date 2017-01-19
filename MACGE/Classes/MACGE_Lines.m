//
//  MACGE_Lines.m
//  MACGE
//
//  Created by Martin.Ren on 2017/1/9.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//


#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"
#import "ACGEDirector.h"

static int MACGE_Lines_Display(lua_State *L)
{
    const char *name = luaL_checkstring(L, 1);
    const char *line = luaL_checkstring(L, 2);

    [[ACGEDirector shareInstance] displayLineWithStr:NStr(line) actorName:NStr(name)];
    
    return 1;
}

static int MACGE_Lines_Hide(lua_State *L)
{
    [[ACGEDirector shareInstance] hideLineView];
    
    return 1;
}

static luaL_Reg MACGE_Line_Lib[] = {
    {"Display",        MACGE_Lines_Display},
    {"Hide",           MACGE_Lines_Hide},
    {NULL, NULL},
};


int private_MACGE_OpenLineLib(lua_State* L)
{
    luaL_newlib(L,MACGE_Line_Lib);
    
    return 1; //return one value
}

int MACGE_OpenLineLib(lua_State* L)
{
    luaL_requiref(L,"MACGE_Line", private_MACGE_OpenLineLib,1);
    
    return 1;
}


