//
//  MXAE_Sourcer.m
//  MXAudioEngine
//
//  Created by Martin.Ren on 13-9-26.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "MXAE_Sourcer.h"
#import "MXAE_Define.h"

void* MyGetOpenALAudioData(CFURLRef inFileURL, ALsizei *outDataSize, ALenum *outDataFormat, ALsizei*	outSampleRate);

AudioFileID openAudioFile(NSString* filePath);

UInt32 audioFileSize(AudioFileID fileDescriptor);

ALvoid MXAE_SourceNotification_SourceStateChanged (ALuint sid, ALuint notificationID, ALvoid* userData);
ALvoid MXAE_SourceNotification_SourceLooped       (ALuint sid, ALuint notificationID, ALvoid* userData);

@interface MXAE_Sourcer()
{
    ALvoid              *sourceData;
    ALenum              sourceFormat;
    ALsizei             sourceSize;
    ALsizei             sourceFreq;
    
    ALuint              sourceId;
    ALuint              sourceBuffId;
    
    NSString            *sourcePath;
    NSTimeInterval      sourceDuration;
    
    @private
    
    alSourceAddNotificationProcPtr    alSourceAddNotification;
    alSourceRemoveNotificationProcPtr alSourceRemoveStateNotification;
}
@end



@implementation MXAE_Sourcer

@synthesize Identifier;
@synthesize position;
@synthesize duration;
@synthesize currentSecOffSet;
@synthesize state;

- (MXAE_Sourcer*) initWithSourcePath : (NSString*) _sourcePath
{
    self = [super init];
    if (self)
    {
        [self setPosition:MXAE_PostionMake(0, 0, 0)];
        
        sourcePath = _sourcePath;
        
        NSURL *fileURL = [NSURL fileURLWithPath:sourcePath];
        
        sourceData = MyGetOpenALAudioData((__bridge CFURLRef)(fileURL), &sourceSize, &sourceFormat, &sourceFreq);
        
        AudioFileID fileID = openAudioFile(sourcePath);
        
        UInt32 fileSize = audioFileSize(fileID);
        
        unsigned char * outData = malloc(fileSize);
        
        OSStatus result = noErr;
        
        UInt32 thePropSize = sizeof(UInt64);
        
        Float64 thenDuration = 0.0f;
        
        result = AudioFileReadBytes(fileID, false, 0, &fileSize, outData);
        
        if (result != 0) NSLog(@"cannot load audio: %@", sourcePath);
        
        result = AudioFileGetProperty(fileID, kAudioFilePropertyEstimatedDuration, &thePropSize, &thenDuration);
        
        sourceDuration = thenDuration;
        
        AudioFileClose(fileID);
        
        //create buffers
        alGenBuffers(1, &sourceBuffId);
        
        //此处无法解决立体声混音效果，如果使用 MONO16 可能导致失去立体声的效果。导致音效变差。
        //如果使用 STEREO16 会导致无法使用混音，解决方案是，通过算法取出左右声道，在模拟两个声源。
        
        alBufferData(sourceBuffId, AL_FORMAT_MONO16, sourceData, sourceSize, sourceFreq * 2);
//        alBufferData(sourceBuffId, AL_FORMAT_STEREO16, sourceData, sourceSize, sourceFreq);
        
        //create sourceid
        alGenSources(1, &sourceId);
        alSourcei(sourceId, AL_BUFFER, sourceBuffId);
        
        if (outData)
        {
            free(outData);
            outData = NULL;
        }
        
        //增加通知
        
        ALCcontext *currALCcontext = alcGetCurrentContext();
        ALCdevice  *currDevice     = alcGetContextsDevice(currALCcontext);
        
        NSAssert(currDevice && currALCcontext, @"必须先初始化MXAE_Controller");
        
        if(YES)
        {
            alSourceAddNotification = alcGetProcAddress(alcGetContextsDevice(alcGetCurrentContext()), "alSourceAddNotification");
            alSourceRemoveStateNotification = alcGetProcAddress(alcGetContextsDevice(alcGetCurrentContext()), "alSourceRemoveStateNotification");
            
            alSourceAddNotification(sourceId, AL_SOURCE_STATE, MXAE_SourceNotification_SourceStateChanged, (__bridge ALvoid *)(self));
            alSourceAddNotification(sourceId, AL_QUEUE_HAS_LOOPED, MXAE_SourceNotification_SourceLooped, (__bridge ALvoid *)(self));
        }
    }
    return self;
}

- (void) sourcerPlay
{
    alSourcePlay(sourceId);
}

- (void) sourcerStop
{
    alSourceStop(sourceId);
}

- (void) sourcerPause
{
    alSourcePause(sourceId);
}

- (void) sourcerResume
{
    alSourcePlay(sourceId);
}

- (void) setPosition:(MXAE_Position *) _position
{
    position = _position;
    
    ALfloat alPostion[3] = {_position.x, _position.y, _position.z};
    
    alListenerfv(AL_POSITION, alPostion);
    
    return ;
}
- (MXAE_Position*) _positionGet
{
    ALfloat postion[3] = {0};
    
    alGetListenerfv(AL_POSITION, postion);
    
    return MXAE_PostionMake(postion[0], postion[1], postion[2]);
}

- (void) setCurrentSecOffSet:(NSTimeInterval) _currentSecOffSet
{
    currentSecOffSet = _currentSecOffSet;
    
    alSourcef(sourceId, AL_SEC_OFFSET, _currentSecOffSet);
    
    return ;
}

- (NSTimeInterval) _currentSecOffsetGet
{
    ALfloat currOffSetSec = 0.0f;
    
    alGetSourcef(sourceId, AL_SEC_OFFSET, &currOffSetSec);
    
    currentSecOffSet = currOffSetSec;
    
    return currOffSetSec;
}

- (MXAE_SOURCE_STATE) _stateGet
{
    ALint sourceState = -1;
    
    alGetSourcei(sourceId, AL_SOURCE_STATE, &sourceState);
    
    if (sourceState == AL_PLAYING)
    {
        return MXAE_SOURCE_STATE_PLAYING;
    }
    
    if (sourceState == AL_PAUSED)
    {
        return MXAE_SOURCE_STATE_PAUSE;
    }
    
    if (sourceState == AL_STOPPED)
    {
        return MXAE_SOURCE_STATE_STOPED;
    }
    
    if (sourceState == AL_INITIAL)
    {
        return MXAE_SOURCE_STATE_SUCCESS;
    }

    return MXAE_SOURCE_STATE_UNREADY;
}

- (NSTimeInterval) _durationSecGet
{
    return sourceDuration;
}

- (void) setLoopPlay:(BOOL)loopPlay
{
    alSourcei(sourceBuffId, AL_LOOPING, loopPlay ? AL_TRUE : AL_FALSE);
}

- (BOOL) _loopPlayGet
{
    ALint isLoopMode = AL_FALSE;
    alGetSourcei(sourceBuffId, AL_LOOPING, &isLoopMode);
    
    if (isLoopMode == AL_FALSE)
    {
        return NO;
    }
    
    if (isLoopMode == AL_TRUE)
    {
        return YES;
    }
    
    return NO;
}

- (void) dealloc
{
//    alSourceRemoveStateNotification(sourceId, AL_SOURCE_STATE, MXAE_SourceNotification_SourceStateChanged, NULL);
//    alSourceRemoveStateNotification(sourceId, AL_QUEUE_HAS_LOOPED, MXAE_SourceNotification_SourceLooped,NULL);
    
    alDeleteSources(1, &sourceId);
    alDeleteBuffers(1, &sourceBuffId);
}

@end

AudioFileID openAudioFile(NSString* filePath)
{
    AudioFileID outAFID;
    
    NSURL * afUrl = [NSURL fileURLWithPath:filePath];
    
    OSStatus result = AudioFileOpenURL((__bridge CFURLRef)afUrl, kAudioFileReadPermission, 0, &outAFID);
    
    if (result != 0)
    {
        NSLog(@"cannot openf file: %@",filePath);
    }
    return outAFID;
}

UInt32 audioFileSize(AudioFileID fileDescriptor)
{
    UInt64 outDataSize = 0;
    UInt32 thePropSize = sizeof(UInt64);
    OSStatus result = AudioFileGetProperty(fileDescriptor, kAudioFilePropertyAudioDataByteCount, &thePropSize, &outDataSize);
    if(result != 0) NSLog(@"cannot find file size");
    return (UInt32)outDataSize;
}


void* MyGetOpenALAudioData(CFURLRef inFileURL, ALsizei *outDataSize, ALenum *outDataFormat, ALsizei*	outSampleRate)
{
	OSStatus						err = noErr;
	SInt64							theFileLengthInFrames = 0;
	AudioStreamBasicDescription		theFileFormat;
	UInt32							thePropertySize = sizeof(theFileFormat);
	ExtAudioFileRef					extRef = NULL;
	void*							theData = NULL;
	AudioStreamBasicDescription		theOutputFormat;
    
	// Open a file with ExtAudioFileOpen()
	err = ExtAudioFileOpenURL(inFileURL, &extRef);
	if(err) { printf("MyGetOpenALAudioData: ExtAudioFileOpenURL FAILED, Error = %d\n", (int)err); goto Exit; }
	
	// Get the audio data format
	err = ExtAudioFileGetProperty(extRef, kExtAudioFileProperty_FileDataFormat, &thePropertySize, &theFileFormat);
	if(err) { printf("MyGetOpenALAudioData: ExtAudioFileGetProperty(kExtAudioFileProperty_FileDataFormat) FAILED, Error = %d\n", err); goto Exit; }
	if (theFileFormat.mChannelsPerFrame > 2)  { printf("MyGetOpenALAudioData - Unsupported Format, channel count is greater than stereo\n"); goto Exit;}
    
	// Set the client format to 16 bit signed integer (native-endian) data
	// Maintain the channel count and sample rate of the original source format
	theOutputFormat.mSampleRate = theFileFormat.mSampleRate;
	theOutputFormat.mChannelsPerFrame = theFileFormat.mChannelsPerFrame;
    
	theOutputFormat.mFormatID = kAudioFormatLinearPCM;
	theOutputFormat.mBytesPerPacket = 2 * theOutputFormat.mChannelsPerFrame;
	theOutputFormat.mFramesPerPacket = 1;
	theOutputFormat.mBytesPerFrame = 2 * theOutputFormat.mChannelsPerFrame;
	theOutputFormat.mBitsPerChannel = 16;
	theOutputFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
	
	// Set the desired client (output) data format
	err = ExtAudioFileSetProperty(extRef, kExtAudioFileProperty_ClientDataFormat, sizeof(theOutputFormat), &theOutputFormat);
	if(err) { printf("MyGetOpenALAudioData: ExtAudioFileSetProperty(kExtAudioFileProperty_ClientDataFormat) FAILED, Error = %d\n", err); goto Exit; }
	
	// Get the total frame count
	thePropertySize = sizeof(theFileLengthInFrames);
	err = ExtAudioFileGetProperty(extRef, kExtAudioFileProperty_FileLengthFrames, &thePropertySize, &theFileLengthInFrames);
	if(err) { printf("MyGetOpenALAudioData: ExtAudioFileGetProperty(kExtAudioFileProperty_FileLengthFrames) FAILED, Error = %d\n", err); goto Exit; }
	
	// Read all the data into memory
	UInt32 theFramesToRead = (UInt32)theFileLengthInFrames;
	UInt32 dataSize = theFramesToRead * theOutputFormat.mBytesPerFrame;;
	theData = malloc(dataSize);
	if (theData)
	{
		AudioBufferList		theDataBuffer;
		theDataBuffer.mNumberBuffers = 1;
		theDataBuffer.mBuffers[0].mDataByteSize = dataSize;
		theDataBuffer.mBuffers[0].mNumberChannels = theOutputFormat.mChannelsPerFrame;
		theDataBuffer.mBuffers[0].mData = theData;
		
		// Read the data into an AudioBufferList
		err = ExtAudioFileRead(extRef, &theFramesToRead, &theDataBuffer);
		if(err == noErr)
		{
			// success
			*outDataSize = (ALsizei)dataSize;
			*outDataFormat = (theOutputFormat.mChannelsPerFrame > 1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
			*outSampleRate = (ALsizei)theOutputFormat.mSampleRate;
		}
		else
		{
			// failure
			free (theData);
			theData = NULL; // make sure to return NULL
			printf("MyGetOpenALAudioData: ExtAudioFileRead FAILED, Error = %d\n", err); goto Exit;
		}
	}
	
Exit:
	// Dispose the ExtAudioFileRef, it is no longer needed
	if (extRef) ExtAudioFileDispose(extRef);
	return theData;
}

ALvoid MXAE_SourceNotification_SourceStateChanged (ALuint sid, ALuint notificationID, ALvoid* userData)
{
    MXAE_Sourcer *source = (__bridge MXAE_Sourcer *)(userData);
    
    if (source.delegate && [source.delegate respondsToSelector:@selector(willSourcer:stateChangedTo:)])
    {
        [source.delegate willSourcer:source stateChangedTo:source.state];
    }
    
    return ;
}

ALvoid MXAE_SourceNotification_SourceLooped       (ALuint sid, ALuint notificationID, ALvoid* userData)
{
    MXAE_Sourcer *source = (__bridge MXAE_Sourcer *)(userData);
    
    if (source.delegate && [source.delegate respondsToSelector:@selector(willSourcerHasBeginLooped:)])
    {
        [source.delegate willSourcerHasBeginLooped:source];
    }
    
    return ;
}
