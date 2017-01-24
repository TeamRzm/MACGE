//
//  MACGE_GUI_TextField.m
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

static int MACGE_GUI_TextField_Create(lua_State *L)
{
    POID p = (void**)lua_newuserdata(L, sizeof(POID));
    
    UITextField *newOCObject = [[UITextField alloc] init];
    newOCObject.userInteractionEnabled = NO;
    
    *p = (__bridge void *)(newOCObject);
    
    luaL_getmetatable(L, "MUI_TextField.Create");
    
    lua_setmetatable(L, -2);
    
    [[MACGE_GUI shareInstance] savePoid:p];
    
    return 1;
}

static int MACGE_GUI_TextField_Destory(lua_State *L)
{
    POID p = (POID)lua_touserdata(L, 1);
    
    [[MACGE_GUI shareInstance] deletePoid:p];
    
    return 0;
}

static int MACGE_GUI_TextField_SetFrame(lua_State *L)
{
    UIView *view = (UIView*)lual_checkObjectiveID(L, 1, "MUI_TextField.Create");
    
    float x = luaL_checknumber(L, 2);
    float y = luaL_checknumber(L, 3);
    float w = luaL_checknumber(L, 4);
    float h = luaL_checknumber(L, 5);
    
    view.frame = CGRectMake(x, y, w, h);
    
    return 0;
}


static int MACGE_GUI_TextField_GetFrame(lua_State *L)
{
    UIImageView *view = (UIImageView*)lual_checkObjectiveID(L, 1, "MUI_TextField.Create");
    
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

static int MACGE_GUI_TextField_AddSubView(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_TextField.Create");
    
    POID s = lua_touserdata(L, 2);
    
    UIView *subview = (__bridge UIView *)(*s);
    
    if (shareScreenView && subview)
    {
        [shareScreenView addSubview:subview];
    }
    
    return 0;
}

static int MACGE_GUI_TextField_SetBackGoundColor(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_TextField.Create");
    
    NSString *hexColor = NStr(luaL_checkstring(L, 2));
    
    float alpha = luaL_checknumber(L, 3);
    
    shareScreenView.backgroundColor = [UIColor colorWithHexString:hexColor alpha:alpha];
    
    return 0;
}

static int MACGE_GUI_TextField_SetText(lua_State *L)
{
    UITextField *view = (UITextField*)lual_checkObjectiveID(L, 1, "MUI_TextField.Create");
    
    NSString *text = NStr(luaL_checkstring(L, 2));
    
    view.text = text;
    
    return 0;
}

static int MACGE_GUI_TextField_GetText(lua_State *L)
{
    UITextField *view = (UITextField*)lual_checkObjectiveID(L, 1, "MUI_TextField.Create");
    
    lua_pushstring(L, view.text.UTF8String);
    
    return 1;
}


static int MACGE_GUI_TextField_SetFontSize(lua_State *L)
{
    UITextField *view = (UITextField*)lual_checkObjectiveID(L, 1, "MUI_TextField.Create");
    
    int fontsize = luaL_checknumber(L, 2);
    
    view.font = [UIFont systemFontOfSize:fontsize];
    
    return 0;
}

static int MACGE_GUI_TextField_SetTextColor(lua_State *L)
{
    UITextField *view = (UITextField*)lual_checkObjectiveID(L, 1, "MUI_TextField.Create");
    
    NSString *hexColor = NStr(luaL_checkstring(L, 2));
    
    float alpha = luaL_checknumber(L, 3);
    
    view.textColor = [UIColor colorWithHexString:hexColor alpha:alpha];
    
    return 0;
}

static int MACGE_GUI_TextField_SetInput(lua_State *L)
{
    UITextField *view = (UITextField*)lual_checkObjectiveID(L, 1, "MUI_TextField.Create");
    
    BOOL isInput = luaL_checknumber(L, 2);
    
    view.userInteractionEnabled = isInput;
    
    return 0;
}

static int MACGE_GUI_TextField_SetAlignment(lua_State *L)
{
    UITextField *view = (UITextField*)lual_checkObjectiveID(L, 1, "MUI_TextField.Create");
    
    NSString *aligmenStr = NStr(luaL_checkstring(L, 2));
    
    if ([aligmenStr isEqualToString:@"LEFT"])
    {
        view.textAlignment = NSTextAlignmentLeft;
    }
    else if ([aligmenStr isEqualToString:@"RIGHT"])
    {
        view.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        view.textAlignment = NSTextAlignmentCenter;
    }
    
    return 0;
}


static int MACGE_GUI_TextField_AddAnimation(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_TextField.Create");
    
    POID s = lua_touserdata(L, 2);
    
    NSString *anmKey = NStr(luaL_checkstring(L, 3));
    
    CABasicAnimation *layAnimtion = (__bridge CABasicAnimation *)(*s);
    
    [shareScreenView.layer addAnimation:layAnimtion forKey:anmKey];
    
    return 0;
}

static int MACGE_GUI_TextField_RemoveAnimation(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_TextField.Create");
    
    NSString *anmKey = NStr(luaL_checkstring(L, 2));
    
    [shareScreenView.layer removeAnimationForKey:anmKey];
    
    return 0;
}

static int MACGE_GUI_TextField_RemovefromSuperview(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_TextField.Create");
    
    [shareScreenView removeFromSuperview];
    
    return 0;
}

static int MACGE_GUI_TextField_ClearView(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_TextField.Create");
    
    for (UIView *subView in shareScreenView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    return 0;
}


static const struct luaL_Reg MACGE_GUI_TextField_m [] = {
    
    {kMUI_SetFrame,             MACGE_GUI_TextField_SetFrame},
    {kMUI_GetFrame,             MACGE_GUI_TextField_GetFrame},
    {kMUI_AddSubview,           MACGE_GUI_TextField_AddSubView},
    {kMUI_Removeview,           MACGE_GUI_TextField_RemovefromSuperview},
    {KMUI_ClearView,            MACGE_GUI_TextField_ClearView},
    {kMUI_SetBackGoundColor,    MACGE_GUI_TextField_SetBackGoundColor},
    
    {kMUI_AddAnimation,         MACGE_GUI_TextField_AddAnimation},
    {kMUI_RemoveAnimation,      MACGE_GUI_TextField_RemoveAnimation},
    
    {"SetText",                 MACGE_GUI_TextField_SetText},
    {"GetText",                 MACGE_GUI_TextField_GetText},
    {"SetFontSize",             MACGE_GUI_TextField_SetFontSize},
    {"SetTextColor",            MACGE_GUI_TextField_SetTextColor},
    {"SetIsInput",              MACGE_GUI_TextField_SetInput},
    {"SetTextAlignment",        MACGE_GUI_TextField_SetAlignment},
    
    {"__gc",                    MACGE_GUI_TextField_Destory},
    {NULL, NULL}
};

static luaL_Reg MACGE_GUI_TextField[] = {
    
    {"Create",   MACGE_GUI_TextField_Create},
    {NULL, NULL},
};

int private_OPEN_MACGE_GUI_TextField(lua_State* L)
{
    luaL_newmetatable(L, "MUI_TextField.Create");
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaL_setfuncs(L, MACGE_GUI_TextField_m, 0);
    luaL_newlib(L, MACGE_GUI_TextField);
    
    return 1;
}

int MACGE_Open_GUI_TextFieldLib(lua_State* L)
{
    luaL_requiref(L,"MUI_TextField", private_OPEN_MACGE_GUI_TextField,1);
    
    return 1;
}


