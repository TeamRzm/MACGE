//
//  MXAE_Sourcer.h
//  MXAudioEngine
//
//  Created by Martin.Ren on 13-9-26.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXAE_Define.h"

@class MXAE_Sourcer;

@protocol MXAE_SourcerDelegate <NSObject>

//播放状态改变
- (void) willSourcer : (MXAE_Sourcer*) _source stateChangedTo : (MXAE_SOURCE_STATE) _state;

//开始了一次新得循环播放
- (void) willSourcerHasBeginLooped : (MXAE_Sourcer*) _source;

@end



@interface MXAE_Sourcer : NSObject

//状态监测
@property (nonatomic, assign) id<MXAE_SourcerDelegate> delegate;

//标示符
@property (nonatomic, strong) NSString *Identifier;

//模拟位置
@property (nonatomic, strong, getter = _positionGet)                    MXAE_Position       *position;

//当前时间
@property (nonatomic, assign, getter = _currentSecOffsetGet)            NSTimeInterval      currentSecOffSet;

//持续时间
@property (nonatomic, assign, getter = _durationSecGet)                 NSTimeInterval      duration;

//当前状态
@property (nonatomic, assign, getter = _stateGet, readonly)             MXAE_SOURCE_STATE   state;

//循环播放
@property (nonatomic, assign, getter = _loopPlayGet)                    BOOL                loopPlay;


- (MXAE_Sourcer*) initWithSourcePath : (NSString*) _sourcePath;

//播放
- (void) sourcerPlay;

//停止
- (void) sourcerStop;

//暂停
- (void) sourcerPause;

//恢复
- (void) sourcerResume;

@end
