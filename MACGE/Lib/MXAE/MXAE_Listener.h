//
//  MXAE_Listener.h
//  MXAudioEngine
//
//  Created by Martin.Ren on 13-9-26.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MXAE_Define.h"

@interface MXAE_Listener : NSObject

@property (nonatomic, strong, getter = _positionGet) MXAE_Position *position;
@property (nonatomic, assign, getter = _roomTypeGet) MXAE_RoomType roomType;
@property (nonatomic, assign, getter = _reverbOnGet) BOOL          reverbOn;

- (MXAE_Listener*) initWithDevice : (ALCdevice*) _device;

@end
