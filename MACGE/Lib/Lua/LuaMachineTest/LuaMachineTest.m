//
//  LuaMachineTest.m
//  LuaMachineTest
//
//  Created by Martin.Ren on 2016/12/16.
//  Copyright © 2016年 Martin.Ren. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LuaMachine.h"


static int objectC_helloWorld(lua_State* L)
{
    double op1 = luaL_checknumber(L,1);
    double op2 = luaL_checknumber(L,2);
    const char *str = luaL_checkstring(L, 3);
    
    NSLog(@"op1:%f,op2:%f,op3:%s", op1, op2, str);
    
    return 1;
}



@interface LuaMachineTest : XCTestCase

@end

@implementation LuaMachineTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [[LuaMachine shareInstance] registerFunctionWithName:@"ObjCFunc" functionAddress:objectC_helloWorld];
    
    [[LuaMachine shareInstance] doScriptPath:@"/Users/martin/Desktop/test.txt"];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
