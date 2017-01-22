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

//extern id lual_checkObjectiveID(lua_State *L, int i, const char type[]);
//
//static int MACGE_GUI_Animation_CreateForKey(lua_State *L)
//{
//    //id**
//    POID p = (void**)lua_newuserdata(L, sizeof(POID));
//    
//    NSString *keyPath = NStr(luaL_checkstring(L, 2));
//    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
//    
//    *p = (__bridge void *)(animation);
//    
//    luaL_getmetatable(L, "MACGE_GUI_Animation_CreateForKey");
//    
//    lua_setmetatable(L, -2);
//    
//    [[MACGE_GUI shareInstance] savePoid:p];
//    
//    return 1;
//}
//
//static int MACGE_GUI_Animation_SetFromValue(lua_State *L)
//{
//    return 0;
//}
//
//static const struct luaL_Reg MACGE_GUI_ImageView_m [] = {
////    {kMUI_SetFrame,             MACGE_GUI_ImageView_SetFrame},
////    {kMUI_GetFrame,             MACGE_GUI_ImageView_GetFrame},
////    {kMUI_SetImage,             MACGE_GUI_ImageView_SetImage},
////    {kMUI_AddSubview,           MACGE_GUI_ImageView_AddSubView},
////    {kMUI_SetBackGoundColor,    MACGE_GUI_ImageView_SetBackGoundColor},
////    {"__gc",                    MACGE_GUI_ImageView_Destory},
//    {NULL, NULL}
//};
//
//static luaL_Reg MACGE_GUI_ImageView[] = {
////    {"Create",          MACGE_GUI_ImageView_Create},
//    {NULL, NULL},
//};
//
//int private_OPEN_MACGE_GUI_ImageView(lua_State* L)
//{
//    luaL_newmetatable(L, "MUI_ImageView.Create");
//    lua_pushvalue(L, -1);
//    lua_setfield(L, -2, "__index");
//    luaL_setfuncs(L, MACGE_GUI_ImageView_m, 0);
//    luaL_newlib(L, MACGE_GUI_ImageView);
//    
//    return 1;
//}
//
//int MACGE_Open_GUI_ImageViewLib(lua_State* L)
//{
//    luaL_requiref(L,"MUI_ImageView", private_OPEN_MACGE_GUI_ImageView,1);
//    
//    return 1;
//}


