//
//  MACGE.m
//  MACGE
//
//  Created by Martin.Ren on 2016/12/22.
//  Copyright © 2016年 Martin.Ren. All rights reserved.
//

#include    "lua.h"
#include    "lualib.h"
#include    "lauxlib.h"

#import     "MACGE.h"
#import     "MACGE_GUI.h"
#include    "MXAE_Controller.h"

//MACGEngine
extern int MACGE_OpenAudioLib(lua_State *L);
extern int MACGE_OpenSceneLib(lua_State* L);
extern int MACGE_OpenActorLib(lua_State* L);
extern int MACGE_OpenLineLib(lua_State *L);

//GUI
extern int MACGE_Open_GUI_ImageViewLib(lua_State* L);
extern int MACGE_Open_GUI_ScreenLib(lua_State* L);
extern int MACGE_Open_GUI_ViewLib(lua_State* L);
extern int MACGE_Open_GUI_TextFieldLib(lua_State* L);
extern int MACGE_Open_GUI_ViewLib(lua_State* L);
extern int MACGE_Open_GUI_ButtonLib(lua_State* L);

@interface MACGE()
{
    
}

@property (nonnull, nonatomic, assign) lua_State *LMachine;

@end

@implementation MACGE

+ (instancetype) shareInstance
{
    static MACGE *staticLuaMachine;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticLuaMachine = [[MACGE alloc] init];
    });
    
    return staticLuaMachine;
}

- (void) doScriptString : (NSString*) scriptStr
{
    luaL_dostring(self.LMachine, scriptStr.UTF8String);
    
    return;
}

- (BOOL) doScriptFileName : (NSString*) fileName
{
    NSData *fileData = [NSData dataWithContentsOfFile:fileName];
    
    if (fileData)
    {
        NSString *scriptString = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    
        luaL_dostring(self.LMachine, scriptString.UTF8String);
        
        return YES;
    }
    else
    {
        NSLog(@"can't find script file : %@", fileName);
        return NO;
    }
    
    return NO;
}

- (void) beginGameWithScriptName : (NSString*) filename
{
    if ([self doScriptFileName:filename])
    {
        [[MACGE_GUI shareInstance] destoryAll];
        
        lua_getglobal(self.LMachine, "MACGE_SCENE_BEGIN");
        
        lua_pcall(self.LMachine, 0, 0, 0);
    }
}

- (void) beginGameWithPack : (NSString*) packFile
{
    [self reNewLuaMachine];
    
    self.resHelper = [ACGE_ResHelper CreateResHelperWithACGEPack:packFile];
    
    [self beginGameWithScriptName:[self.resHelper getStartingGameScription]];
    
    return ;
}

- (void) reNewLuaMachine
{
    _LMachine = luaL_newstate();
    
    luaL_openlibs(_LMachine);
    
    [self openCustomLibs];
}

- (lua_State*) LMachine {
    
    if ( !_LMachine )
    {
        _LMachine = luaL_newstate();
        
        luaL_openlibs(_LMachine);
        
        [self openCustomLibs];
    }
    
    return _LMachine;
}

- (void) openCustomLibs
{
    //ACGE
    
    //API Header : MACGE_Audio
    MACGE_OpenAudioLib(self.LMachine);
    
    //API Header : MACGE_Scene
    MACGE_OpenSceneLib(self.LMachine);
    
    //API Header : MACGE_Actor
    MACGE_OpenActorLib(self.LMachine);
    
    //API Header : MACGE_Line
    MACGE_OpenLineLib(self.LMachine);
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    //GUI
    MACGE_Open_GUI_ScreenLib(self.LMachine);
    MACGE_Open_GUI_ImageViewLib(self.LMachine);
    MACGE_Open_GUI_ViewLib(self.LMachine);
    MACGE_Open_GUI_TextFieldLib(self.LMachine);
    MACGE_Open_GUI_ViewLib(self.LMachine);
    MACGE_Open_GUI_ButtonLib(self.LMachine);
}


- (void) sendEventToScript : (MACGE_EVENT) event
{
    lua_getglobal(self.LMachine, "MACGE_Event_Handle");
    
    switch (event) {
        case MACGE_EVENT_TOUCH_SCREEN:
        {
            lua_pushstring(self.LMachine, "MACGE_EVENT_TOUCH_SCREEN");
            lua_pushstring(self.LMachine, "MACGE_EVENT_TOUCH_SCREEN");
        }
            break;
            
        default:
            break;
    }
    
    lua_pcall(self.LMachine, 2, 1, 0);
    lua_pop(self.LMachine, 1);
}

@end
