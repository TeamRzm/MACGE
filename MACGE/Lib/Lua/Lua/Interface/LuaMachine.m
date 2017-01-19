//
//  LuaMachine.m
//  Lua
//
//  Created by Martin.Ren on 2016/12/16.
//  Copyright © 2016年 Martin.Ren. All rights reserved.
//

#import "LuaMachine.h"

@interface LuaMachine()
{
    
}

@property (nonatomic, nonnull, assign) lua_State *LMachine;

@end

@implementation LuaMachine

+ (instancetype) shareInstance
{
    static LuaMachine *staticLuaMachine;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticLuaMachine = [[LuaMachine alloc] init];
    });
    
    return staticLuaMachine;
}

- (BOOL) doScriptPath : (NSString*) scriptPath
{
    NSData *fileData = [NSData dataWithContentsOfFile:scriptPath];
    
    NSString *scriptString = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    
    luaL_dostring(self.LMachine, scriptString.UTF8String);
    
    return YES;
}

- (BOOL) doScriptString : (NSString*) luaScriptString
{
    luaL_dostring(self.LMachine, luaScriptString.UTF8String);
    
    return YES;
}

- (void) registerFunctionWithName : (NSString*) luaFunctionName functionAddress : (void*) faddress
{
    lua_register(self.LMachine, luaFunctionName.UTF8String, faddress);
}

- (void) registerLabWithOpenFunc : (void*) openCfunc functionArr : (luaL_Reg[]) regArr libName : (NSString*) libname
{    
    luaL_newlib(self.LMachine, regArr);
}


- (lua_State*) LMachine {
    
    if ( !_LMachine )
    {
        _LMachine = luaL_newstate();
        
        luaL_openlibs(_LMachine);
    }
    
    return _LMachine;
}

@end
