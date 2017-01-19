//
//  LuaMachine.h
//  Lua
//
//  Created by Martin.Ren on 2016/12/16.
//  Copyright © 2016年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

@interface LuaMachine : NSObject

+ (instancetype) shareInstance;

- (BOOL) doScriptPath : (NSString*) scriptPath;

- (BOOL) doScriptString : (NSString*) luaScriptString;

- (void) registerFunctionWithName : (NSString*) luaFunctionName functionAddress : (void*) faddress;

- (void) registerLabWithOpenFunc : (void*) openCfunc functionArr : (luaL_Reg[]) regArr libName : (NSString*) libname;



@end
