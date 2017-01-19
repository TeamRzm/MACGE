//
//  MXAE_Listener.m
//  MXAudioEngine
//
//  Created by Martin.Ren on 13-9-26.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "MXAE_Listener.h"

@interface MXAE_Listener ()
{
    BOOL                     isSupportEXT_ASA;
    
    alcASAGetSourceProcPtr   alcASAGetSource;
    alcASASetSourceProcPtr   alcASASetSource;
    alcASAGetListenerProcPtr alcASAGetListener;
    alcASASetListenerProcPtr alcASASetListener;
}

@end

@implementation MXAE_Listener

@synthesize position;
@synthesize roomType;
@synthesize reverbOn;

- (MXAE_Listener*) initWithDevice : (ALCdevice*) _device
{
    self = [super init];
    if (self)
    {
        if(alcIsExtensionPresent(alcGetContextsDevice(alcGetCurrentContext()), "ALC_EXT_ASA"))
        {
            isSupportEXT_ASA = YES;
            
            alcASAGetSource = alcGetProcAddress(alcGetContextsDevice(alcGetCurrentContext()), "alcASAGetSource");
            alcASASetSource = alcGetProcAddress(alcGetContextsDevice(alcGetCurrentContext()), "alcASASetSource");
            
            alcASAGetListener = alcGetProcAddress(alcGetContextsDevice(alcGetCurrentContext()), "alcASAGetListener");
            alcASASetListener = alcGetProcAddress(alcGetContextsDevice(alcGetCurrentContext()), "alcASASetListener");
        }
        else
        {
            isSupportEXT_ASA = NO;
            NSLog(@"Error: ALC_EXT_ASA not supported\n");
        }
    }
    return self;
}

- (void) setPosition:(MXAE_Position *) _position
{
    position = _position;
    
    ALfloat alPostion[3] = {_position.x, _position.y, _position.z};
    
    alListenerfv(AL_POSITION, alPostion);
    
    return ;
}

- (void) setRoomType:(MXAE_RoomType)_roomType
{
    if (!isSupportEXT_ASA)
    {
        return ;
    }
    roomType = _roomType;
    
    ALuint alRoomType = _roomType;
    ALuint alRommTypeSize = sizeof(alRoomType);
    
    alcASASetListener(ALC_ASA_REVERB_ROOM_TYPE, &alRoomType, alRommTypeSize);
}

- (void) setReverbOn:(BOOL) _reverbOn
{
    if (!isSupportEXT_ASA)
    {
        return ;
    }
    
    ALuint alReverOn = _reverbOn ? 1 : 0;
    ALuint alReverOnSize = sizeof(ALuint);
    
    alcASASetListener(ALC_ASA_REVERB_ON, &alReverOn, alReverOnSize);
}


- (MXAE_Position*) _positionGet
{
    ALfloat postion[3] = {0};
    
    alGetListenerfv(AL_POSITION, postion);
    
    return MXAE_PostionMake(postion[0], postion[1], postion[2]);
}

- (MXAE_RoomType) _roomTypeGet
{
    if (!isSupportEXT_ASA)
    {
        return MXAE_RoomType_SmallRoom;
    }
    
    ALuint alRoomType = -1;
    ALuint alRoomTypeSize = sizeof(ALuint);
    
    alcASAGetListener(ALC_ASA_REVERB_ROOM_TYPE, &alRoomType, &alRoomTypeSize);
    return alRoomType;
}

- (BOOL) _reverbOnGet
{
    if (!isSupportEXT_ASA)
    {
        return NO;
    }
    
    ALuint reverOn = -1;
    ALuint reverOnSize = sizeof(ALuint);
    alcASAGetListener(ALC_ASA_REVERB_ON, &reverOn, &reverOnSize);
    
    return reverOn == 1 ? YES : NO;
}

@end
