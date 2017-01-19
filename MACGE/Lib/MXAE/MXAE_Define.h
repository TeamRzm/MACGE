//
//  MXAE_Define.h
//  MXAudioEngine
//
//  Created by Martin.Ren on 13-9-26.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <OpenAL/oalMacOSX_OALExtensions.h>
#import <OpenAL/oalStaticBufferExtension.h>
#import <AudioToolbox/AudioToolbox.h>

typedef enum
{
    MXAE_RoomType_SmallRoom     = 0,
    MXAE_RoomType_MediumRoom    = 1,
    MXAE_RoomType_LargeRoom     = 2,
    MXAE_RoomType_MediumHall    = 3,
    MXAE_RoomType_LargeHall     = 4,
    MXAE_RoomType_Plate         = 5,
    MXAE_RoomType_MediumChamber = 6,
    MXAE_RoomType_LargeChamber  = 7,
    MXAE_RoomType_Cathedral     = 8,
    MXAE_RoomType_LargeRoom2    = 9,
    MXAE_RoomType_MediumHall2   = 10,
    MXAE_RoomType_MediumHall3   = 11,
    MXAE_RoomType_LargeHall2    = 12,
}MXAE_RoomType;

typedef enum
{
    MXAE_SOURCE_STATE_UNREADY,
    MXAE_SOURCE_STATE_SUCCESS,
    MXAE_SOURCE_STATE_PLAYING,
    MXAE_SOURCE_STATE_STOPED,
    MXAE_SOURCE_STATE_PAUSE,
}MXAE_SOURCE_STATE;

#define MXAE_PostionMake(x,y,z) ([MXAE_Position CreateWithX:x Y:y Z:z])
#define MXAE_ReplayFever -1

@interface MXAE_Position : NSObject
@property (nonatomic, assign) ALfloat x;
@property (nonatomic, assign) ALfloat y;
@property (nonatomic, assign) ALfloat z;
+ (MXAE_Position*) CreateWithX : (ALfloat)_x Y : (ALfloat)_y Z : (ALfloat)_z;
@end


@interface MXAE_Define : NSObject

@end
