//
//  MXAE_Controller.m
//  MXAudioEngine
//
//  Created by Martin.Ren on 13-9-26.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "MXAE_Controller.h"
#import "MXAE_Listener.h"
#import "MXAE_Sourcer.h"

@interface MXAE_Controller()
{
    ALCdevice           *alDevice;
    ALCcontext          *alContext;
    
    MXAE_Listener       *instanceListener;
    
    NSMutableArray      *sourcerArr;
}

@end

@implementation MXAE_Controller

- (void) ConfigController
{
    //init OpenAl and Device
    alDevice = alcOpenDevice(NULL);
    
    assert(alDevice);
    
    alContext = alcCreateContext(alDevice, NULL);
    alcMakeContextCurrent(alContext);
    alDistanceModel(AL_DISTANCE_MODEL);
    
    //config Listner
    instanceListener = [[MXAE_Listener alloc] initWithDevice:alDevice];
    
    NSLog(@"ConfigController success!");
}

- (void) DestroyController
{
    for (MXAE_Sourcer *subSource in sourcerArr)
    {
        [subSource sourcerStop];
    }
    
    ALCcontext	*context = NULL;
    ALCdevice	*device = NULL;
		
	//Get active context (there can only be one)
    context = alcGetCurrentContext();
    //Get device for active context
    device = alcGetContextsDevice(context);
    //Release context
    alcDestroyContext(context);
    //Close device
    alcCloseDevice(device);
    
    [sourcerArr removeAllObjects];
}

+ (MXAE_Controller*) shareController
{
    static MXAE_Controller *mxae_controller_instance;
    
    if (!mxae_controller_instance)
    {
        mxae_controller_instance = [[MXAE_Controller alloc] init];
    }
    return mxae_controller_instance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        //other config
        sourcerArr = [[NSMutableArray alloc] init];
    }
    return self;
}

/*－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 声源操作
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－*/


/*增加一个声源*/
- (BOOL) addSourcerWithPath : (NSString*) _sourceFilePath identifier : (NSString*) _identifier
{
    MXAE_Sourcer *newSource = [[MXAE_Sourcer alloc] initWithSourcePath:_sourceFilePath];
    
    if (newSource)
    {
        [newSource setIdentifier:_identifier];
        
        [sourcerArr addObject:newSource];
        
        return YES;
    }
    else
    {
        return NO;
    }
}


- (BOOL) removeSourceWithIdentifier : (NSString*) _identifier
{
    for (MXAE_Sourcer *subSource in sourcerArr)
    {
        if ([subSource.Identifier isEqualToString:_identifier])
        {
            [subSource sourcerStop];
            
            [sourcerArr removeObject:subSource];
            
            return YES;
        }
    }
    return NO;
}

/*根据声源标示获取声源对象*/
- (MXAE_Sourcer*) findSourcerWithIdentifier : (NSString*) _identifier
{
    for (MXAE_Sourcer *subSource in sourcerArr)
    {
        if ([subSource.Identifier isEqualToString:_identifier])
        {
            return subSource;
        }
    }
    
    return NULL;
}

/*获取当前所有声源*/
- (NSArray*) allSourcer
{
    return sourcerArr;
}


/*－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 听者操作
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－*/
/*获取当前的听者对象，注意因为听者只有一个，所以不接受声称的听者*/
- (MXAE_Listener*) getInstanceListener
{
    return instanceListener;
}

@end
