//
//  MACGE_Scene.m
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
#import "MXAE_Controller.h"

//章节切换
static int MACGE_Scene_Changed (lua_State *L)
{
    //标题
    const char *title = luaL_checkstring(L, 1);
    
    //子标题
    const char *subtitle = luaL_checkstring(L, 2);
    
    //背景图片路径
    const char *imagePath = luaL_checkstring(L, 3);
    
    UIImage *bgImg = [[MACGE shareInstance].resHelper loadImageWithLocalPath:NStr(imagePath)];
    
    [[ACGEDirector shareInstance] screenChangedWithTitle:NStr(title) subTitle:NStr(subtitle) backgound:bgImg];
    
    return 0;
}

//带Alph动画的场景切换
static int MACGE_Scene_ChangedWithMask (lua_State *L)
{
    //标题
    const char *title = luaL_checkstring(L, 1);
    
    //子标题
    const char *subtitle = luaL_checkstring(L, 2);
    
    //场景切换使用的图片
    const char *changedImgPath = luaL_checkstring(L, 3);
    
    //背景图片路径
    const char *imagePath = luaL_checkstring(L, 4);
    
    //Alpha动画遮罩图片
    const char *alphaMaskImgPath = luaL_checkstring(L, 5);
    
    //动画类型
    int maskType = luaL_checknumber(L, 6);
    

    UIImage *maskBgImg = [[MACGE shareInstance].resHelper loadImageWithLocalPath:NStr(alphaMaskImgPath)];
    UIImage *changedbg = [[MACGE shareInstance].resHelper loadImageWithLocalPath:NStr(changedImgPath)];
    UIImage *bgimage = [[MACGE shareInstance].resHelper loadImageWithLocalPath:NStr(imagePath)];
    
    [[ACGEDirector shareInstance] screenChangedWithTitle:NStr(title)
                                                subTitle:NStr(subtitle)
                                      maskBacnGoundBgImg:changedbg
                                          sceneBackgound:bgimage
                                             alphaAnmImg:maskBgImg
                                                 anmType:(MACGE_SCENE_CHANGED_ALPHIM_ANM)(maskType)];
    return 0;
}

static int MACGE_Scene_ChangScript (lua_State *L)
{
    const char *newScriptionPath = luaL_checkstring(L, 1);
    
    NSString *scriptPath = [[MACGE shareInstance].resHelper loadResWithLocalPath:NStr(newScriptionPath)];

    [[MACGE shareInstance] beginGameWithScriptName:scriptPath];
    
    return 0;
}

static int MACGE_Scene_Over (lua_State *L)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MACGE_Scene_Over" object:nil];
    
    [[MXAE_Controller shareController] DestroyController];
    
    return 0;
}

static luaL_Reg MACGE_Scene_Lib[] = {
    {"ChangScript",    MACGE_Scene_ChangScript},
    {"Changed",        MACGE_Scene_Changed},
    {"ChangedWithMask",MACGE_Scene_ChangedWithMask},
    {"Over",           MACGE_Scene_Over},
    {NULL, NULL},
};


int private_MACGE_OpenSceneLib(lua_State* L)
{
    luaL_newlib(L,MACGE_Scene_Lib);
    
    return 1; //return one value
}

int MACGE_OpenSceneLib(lua_State* L)
{
    luaL_requiref(L,"MACGE_Scene", private_MACGE_OpenSceneLib,1);
    
    return 1;
}


