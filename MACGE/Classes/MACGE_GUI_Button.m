//
//  MACGE_GUI_Button.m
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

#import <objc/runtime.h>

static char MACGE_BUTTON_TOUCH_UP_IN_SIDE_KEY;

@interface UIButton(MACGE_BlockButton)

@property (nonatomic, strong) MACGE_SIMPLE_BLOCK touchUpInSideBlock;

@end

@implementation UIButton(MACGE_BlockButton)

- (void) setTouchUpInSideBlock:(MACGE_SIMPLE_BLOCK)touchUpInSideBlock
{
    [self willChangeValueForKey:@"MACGE_BLOCKBUTON_TOUCHUO_UP_IN_SIDE_BLOCK_KEY"];
    objc_setAssociatedObject(self, &MACGE_BUTTON_TOUCH_UP_IN_SIDE_KEY,
                             touchUpInSideBlock,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC | OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"MACGE_BLOCKBUTON_TOUCHUO_UP_IN_SIDE_BLOCK_KEY"];
}

- (MACGE_SIMPLE_BLOCK) touchUpInSideBlock
{
    return objc_getAssociatedObject(self, &MACGE_BUTTON_TOUCH_UP_IN_SIDE_KEY);
}

- (void) addTouchUpInSideEventWithBlock : (MACGE_SIMPLE_BLOCK) touchBlock
{
    self.touchUpInSideBlock = touchBlock;
    
    [self addTarget:self action:@selector(buttonHasTouchUpInSide) forControlEvents:UIControlEventTouchUpInside];
    
    return;
}

- (void) buttonHasTouchUpInSide
{
    if (self.touchUpInSideBlock)
    {
        self.touchUpInSideBlock();
    }
}

@end



extern id lual_checkObjectiveID(lua_State *L, int i, const char type[]);

static int MACGE_GUI_Button_Create(lua_State *L)
{
    POID p = (void**)lua_newuserdata(L, sizeof(POID));
    
    UIButton *newOCObject = [UIButton buttonWithType:UIButtonTypeCustom];

    *p = (__bridge void *)(newOCObject);
    
    luaL_getmetatable(L, "MUI_Button.Create");
    
    lua_setmetatable(L, -2);
    
    [[MACGE_GUI shareInstance] savePoid:p];
    
    return 1;
}

static int MACGE_GUI_Button_Destory(lua_State *L)
{
    POID p = (POID)lua_touserdata(L, 1);
    
    [[MACGE_GUI shareInstance] deletePoid:p];
    
    return 0;
}

static int MACGE_GUI_Button_SetFrame(lua_State *L)
{
    UIView *view = (UIView*)lual_checkObjectiveID(L, 1, "MUI_Button.Create");
    
    float x = luaL_checknumber(L, 2);
    float y = luaL_checknumber(L, 3);
    float w = luaL_checknumber(L, 4);
    float h = luaL_checknumber(L, 5);
    
    view.frame = CGRectMake(x, y, w, h);
    
    return 0;
}


static int MACGE_GUI_Button_GetFrame(lua_State *L)
{
    UIImageView *view = (UIImageView*)lual_checkObjectiveID(L, 1, "MUI_Button.Create");
    
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

static int MACGE_GUI_Button_AddSubView(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_Button.Create");
    
    POID s = lua_touserdata(L, 2);
    
    UIView *subview = (__bridge UIView *)(*s);
    
    if (shareScreenView && subview)
    {
        [shareScreenView addSubview:subview];
    }
    
    return 0;
}

static int MACGE_GUI_Button_SetBackGoundColor(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_Button.Create");
    
    NSString *hexColor = NStr(luaL_checkstring(L, 2));
    
    float alpha = luaL_checknumber(L, 3);
    
    shareScreenView.backgroundColor = [UIColor colorWithHexString:hexColor alpha:alpha];
    
    return 0;
}

static int MACGE_GUI_Button_SetText(lua_State *L)
{
    UIButton *view = (UIButton*)lual_checkObjectiveID(L, 1, "MUI_Button.Create");
    
    NSString *text = NStr(luaL_checkstring(L, 2));
    
    [view setTitle:text forState:UIControlStateNormal];
    
    return 0;
}

static int MACGE_GUI_Button_GetText(lua_State *L)
{
    UIButton *view = (UIButton*)lual_checkObjectiveID(L, 1, "MUI_Button.Create");
    
    lua_pushstring(L, view.titleLabel.text.UTF8String);
    
    return 1;
}

static int MACGE_GUI_Button_SetFontSize(lua_State *L)
{
    UIButton *view = (UIButton*)lual_checkObjectiveID(L, 1, "MUI_Button.Create");
    
    int fontsize = luaL_checknumber(L, 2);
    
    view.titleLabel.font = [UIFont systemFontOfSize:fontsize];
    
    return 0;
}

static int MACGE_GUI_Button_SetTextColor(lua_State *L)
{
    UIButton *view = (UIButton*)lual_checkObjectiveID(L, 1, "MUI_Button.Create");
    
    NSString *hexColor = NStr(luaL_checkstring(L, 2));
    
    float alpha = luaL_checknumber(L, 3);
    
    [view setTitleColor:[UIColor colorWithHexString:hexColor alpha:alpha] forState:UIControlStateNormal];
    
    return 0;
}

static int MACGE_GUI_Button_SetAlignment(lua_State *L)
{
    UIButton *view = (UIButton*)lual_checkObjectiveID(L, 1, "MUI_Button.Create");
    
    NSString *aligmenStr = NStr(luaL_checkstring(L, 2));
    
    if ([aligmenStr isEqualToString:@"LEFT"])
    {
        view.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    else if ([aligmenStr isEqualToString:@"RIGHT"])
    {
        view.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        view.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return 0;
}

static int MACGE_GUI_Button_SetEvent(lua_State *L)
{
    UIButton *view = (UIButton*)lual_checkObjectiveID(L, 1, "MUI_Button.Create");
    
    NSString *callBackFunc = NStr(luaL_checkstring(L, 2));
    
    [view addTouchUpInSideEventWithBlock:^{
        lua_getglobal(L, callBackFunc.UTF8String);
        lua_pcall(L, 0, 0, 0);
        lua_pop(L, 1);
    }];
    
    return 0;
}

static int MACGE_GUI_Button_AddAnimation(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_Button.Create");
    
    POID s = lua_touserdata(L, 2);
    
    NSString *anmKey = NStr(luaL_checkstring(L, 3));
    
    CABasicAnimation *layAnimtion = (__bridge CABasicAnimation *)(*s);
    
    [shareScreenView.layer addAnimation:layAnimtion forKey:anmKey];
    
    return 0;
}

static int MACGE_GUI_Button_RemoveAnimation(lua_State *L)
{
    UIView *shareScreenView = (UIView*)lual_checkObjectiveID(L, 1, "MUI_Button.Create");
    
    NSString *anmKey = NStr(luaL_checkstring(L, 2));
    
    [shareScreenView.layer removeAnimationForKey:anmKey];
    
    return 0;
}

static const struct luaL_Reg MACGE_GUI_Button_m [] = {
    
    {kMUI_SetFrame,             MACGE_GUI_Button_SetFrame},
    {kMUI_GetFrame,             MACGE_GUI_Button_GetFrame},
    {kMUI_AddSubview,           MACGE_GUI_Button_AddSubView},
    {kMUI_SetBackGoundColor,    MACGE_GUI_Button_SetBackGoundColor},
    
    {kMUI_AddAnimation,         MACGE_GUI_Button_AddAnimation},
    {kMUI_RemoveAnimation,      MACGE_GUI_Button_RemoveAnimation},
    
    {"SetText",                 MACGE_GUI_Button_SetText},
    {"GetText",                 MACGE_GUI_Button_GetText},
    {"SetFontSize",             MACGE_GUI_Button_SetFontSize},
    {"SetTextColor",            MACGE_GUI_Button_SetTextColor},
    {"SetTextAlignment",        MACGE_GUI_Button_SetAlignment},
    {"SetEvent",                MACGE_GUI_Button_SetEvent},
    
    {"__gc",                    MACGE_GUI_Button_Destory},
    {NULL, NULL}
};

static luaL_Reg MACGE_GUI_Button[] = {
    
    {"Create",   MACGE_GUI_Button_Create},
    {NULL, NULL},
};

int private_OPEN_MACGE_GUI_Button(lua_State* L)
{
    luaL_newmetatable(L, "MUI_Button.Create");
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaL_setfuncs(L, MACGE_GUI_Button_m, 0);
    luaL_newlib(L, MACGE_GUI_Button);
    
    return 1;
}

int MACGE_Open_GUI_ButtonLib(lua_State* L)
{
    luaL_requiref(L,"MUI_Button", private_OPEN_MACGE_GUI_Button,1);
    
    return 1;
}


