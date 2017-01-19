//
//  MACGE_Audio.m
//  MACGE
//
//  Created by Martin.Ren on 2016/12/22.
//  Copyright © 2016年 Martin.Ren. All rights reserved.
//

#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"
#import "MXAE_Controller.h"
#import "MACGE.h"

static int MACGE_Audio_Init (lua_State *L)
{
    [MXAE_ControllerInstance ConfigController];
    [[MXAE_ControllerInstance getInstanceListener] setReverbOn:YES];
    
    return 1;
}

static int MACGE_Audio_Load (lua_State *L)
{
    //音频文件路径
    const char *audio_file_path = luaL_checkstring(L, 1);
    
    //音频标识符
    const char *audio_identifier = luaL_checkstring(L, 2);
    
    NSString *path = [[MACGE shareInstance].resHelper loadResWithLocalPath:NStr(audio_file_path)];
    
    BOOL loadResut = [MXAE_ControllerInstance addSourcerWithPath:path
                                                      identifier:NStr(audio_identifier)];
    
    lua_pushboolean(L, loadResut);
    
    return 1;
}

static int MACGE_Audio_Play (lua_State *L)
{
    //音频标识符
    const char *audio_identifier = luaL_checkstring(L, 1);
    
    //是否循环播放
    unsigned int audio_play_loop_count = luaL_checknumber(L, 2);
    
    MXAE_Sourcer *audioSource = [MXAE_ControllerInstance findSourcerWithIdentifier:NStr(audio_identifier)];
    
    if ( !audioSource )
    {
        lua_pushboolean(L, false);
    }
    else
    {
        audioSource.loopPlay = audio_play_loop_count > 0 ? YES : NO;
        [audioSource sourcerPlay];
        lua_pushboolean(L, true);
    }
    
    return 1;
}

static int MACGE_Audio_Pause (lua_State *L)
{
    //音频标识符
    const char *audio_identifier = luaL_checkstring(L, 1);
    
    MXAE_Sourcer *audioSource = [MXAE_ControllerInstance findSourcerWithIdentifier:NStr(audio_identifier)];
    
    if ( !audioSource )
    {
        lua_pushboolean(L, false);
    }
    else
    {
        [audioSource sourcerPause];
        lua_pushboolean(L, true);
    }
    
    return 1;
}

static int MACGE_Audio_Stop (lua_State *L)
{
    //音频标识符
    const char *audio_identifier = luaL_checkstring(L, 1);
    
    MXAE_Sourcer *audioSource = [MXAE_ControllerInstance findSourcerWithIdentifier:NStr(audio_identifier)];
    
    if ( !audioSource )
    {
        lua_pushboolean(L, false);
    }
    else
    {
        [audioSource sourcerStop];
        lua_pushboolean(L, true);
    }
    
    return 0;
}

static int MACGE_Audio_Resume (lua_State *L)
{
    //音频标识符
    const char *audio_identifier = luaL_checkstring(L, 1);
    
    MXAE_Sourcer *audioSource = [MXAE_ControllerInstance findSourcerWithIdentifier:NStr(audio_identifier)];
    
    if ( !audioSource )
    {
        lua_pushboolean(L, false);
    }
    else
    {
        [audioSource sourcerResume];
        lua_pushboolean(L, true);
    }
    
    return 0;
}

static int MACGE_Audio_Destroy (lua_State *L)
{
    //音频标识符
    const char *audio_identifier = luaL_checkstring(L, 1);
    
    [MXAE_ControllerInstance removeSourceWithIdentifier:NStr(audio_identifier)];
    
    return 0;
}

static int MACGE_Audio_SetPosition (lua_State *L)
{
    //音频标识符
    const char *audio_identifier = luaL_checkstring(L, 1);
    
    //x
    int x = luaL_checknumber(L, 2);
    int y = luaL_checknumber(L, 3);
    int z = luaL_checknumber(L, 4);
    
    MXAE_Sourcer *audioSource = [MXAE_ControllerInstance findSourcerWithIdentifier:NStr(audio_identifier)];
    
    if ( audioSource )
    {
        audioSource.position = MXAE_PostionMake(x, y, z);
        
        return 1;
    }
    
    return 0;
}

static int MACGE_Audio_SetRoomType (lua_State *L)
{
    MXAE_RoomType roomType = (MXAE_RoomType)( ((int)luaL_checknumber(L, 1)) % 13 );
    
    [[MXAE_ControllerInstance getInstanceListener] setRoomType:roomType];
    
    return 1;
}

static luaL_Reg MACGE_Audio_Lib[] = {
    {"Init",        MACGE_Audio_Init},
    {"Load",        MACGE_Audio_Load},
    {"Play",        MACGE_Audio_Play},
    {"Pause",       MACGE_Audio_Pause},
    {"Resume",      MACGE_Audio_Resume},
    {"Stop",        MACGE_Audio_Stop},
    {"Destroy",     MACGE_Audio_Destroy},
    {"SetPos",      MACGE_Audio_SetPosition},
    {"SetRoomType", MACGE_Audio_SetRoomType},
    {NULL, NULL},
};


int private_MACGE_OpenAudioLib(lua_State* L)
{
    luaL_newlib(L,MACGE_Audio_Lib);
    
    return 1; //return one value
}

int MACGE_OpenAudioLib(lua_State* L)
{
    luaL_requiref(L,"MACGE_Audio", private_MACGE_OpenAudioLib,1);
    
    return 1;
}


