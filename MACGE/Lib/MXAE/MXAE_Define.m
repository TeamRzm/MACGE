//
//  MXAE_Define.m
//  MXAudioEngine
//
//  Created by Martin.Ren on 13-9-26.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "MXAE_Define.h"

@implementation MXAE_Position

@synthesize x;
@synthesize y;
@synthesize z;

+ (MXAE_Position*) CreateWithX:(ALfloat)_x Y:(ALfloat)_y Z:(ALfloat)_z
{
    MXAE_Position *resutObjc = [[MXAE_Position alloc] init];
    
    [resutObjc setX:_x];
    [resutObjc setY:_y];
    [resutObjc setZ:_z];
    
    return resutObjc;
    
}

@end


@implementation MXAE_Define

@end
