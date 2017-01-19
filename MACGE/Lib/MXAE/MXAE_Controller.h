//
//  MXAE_Controller.h
//  MXAudioEngine
//
//  Created by Martin.Ren on 13-9-26.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

@import AudioToolbox;
@import OpenAL;

#import <Foundation/Foundation.h>

#import "MXAE_Define.h"
#import "MXAE_Listener.h"
#import "MXAE_Sourcer.h"


#define MXAE_ControllerInstance ([MXAE_Controller shareController])

@interface MXAE_Controller : NSObject

+ (MXAE_Controller*) shareController;

- (void) ConfigController;

- (void) DestroyController;

/*－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 声源操作
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－*/

/*增加一个声源*/
- (BOOL) addSourcerWithPath : (NSString*) _sourceFilePath identifier : (NSString*) _identifier;

- (BOOL) removeSourceWithIdentifier : (NSString*) _identifier;

/*根据声源标示获取声源对象*/
- (MXAE_Sourcer*) findSourcerWithIdentifier : (NSString*) _identifier;


/*获取当前所有声源*/
- (NSArray*) allSourcer;


/*－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 听者操作
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－*/
/*获取当前的听者对象，注意因为听者只有一个，所以不接受声称的听者*/
- (MXAE_Listener*) getInstanceListener;

@end
