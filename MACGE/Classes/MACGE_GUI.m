//
//  MACGE_GUI.m
//  MACGE
//
//  Created by Martin.Ren on 2017/1/13.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//

#import "MACGE_GUI.h"

@interface MACGE_GUI()
{
    
}

@property (nonatomic, strong) NSMutableArray<id> *POIDList;

@end

@implementation MACGE_GUI

+ (instancetype) shareInstance
{
    static MACGE_GUI *staticGuiManger = nil;
    
    if (!staticGuiManger)
    {
        staticGuiManger = [[MACGE_GUI alloc] init];
    }
    
    return staticGuiManger;
}

- (void) savePoid : (POID) poidPoint
{
    [self.POIDList addObject:(__bridge id _Nonnull)(*poidPoint)];
    
    return ;
}

- (void) deletePoid : (POID) poidPoint
{
    [self.POIDList removeObject:(__bridge id _Nonnull)(*poidPoint)];
    
    return ;
}

- (void) destoryAll
{
    [self.POIDList removeAllObjects];
    
    return ;
}

- (NSMutableArray<id>*) POIDList
{
    if (!_POIDList)
    {
        _POIDList = [[NSMutableArray alloc] init];
    }
    
    return _POIDList;
}
@end


id lual_checkObjectiveID(lua_State *L, int i, const char type[])
{
    POID s = (POID)luaL_checkudata(L, 1, type);
    
    return (__bridge id)(*s);
}



