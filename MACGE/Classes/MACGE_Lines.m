//
//  MACGE_Lines.m
//  MACGE
//
//  Created by Martin.Ren on 2017/1/9.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//


#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"
#import "ACGEDirector.h"
#import "MACGE.h"
#import "UIColor+HEXString.h"

static int MACGE_Lines_Display(lua_State *L)
{
    const char *name = luaL_checkstring(L, 1);
    const char *line = luaL_checkstring(L, 2);

    [[ACGEDirector shareInstance] displayLineWithStr:NStr(line) actorName:NStr(name)];
    
    return 1;
}

static int MACGE_Lines_Hide(lua_State *L)
{
    [[ACGEDirector shareInstance] hideLineView];
    
    return 1;
}

static int MACGE_Lines_FullLinesWithAllParmas(lua_State *L)
{
    NSString    *contentString = NStr(luaL_checkstring(L, 1));
    CGFloat     lineDuartion = luaL_checknumber(L, 2);
    NSString    *hexColor = NStr(luaL_checkstring(L, 3));
    CGFloat     colorAlpha = luaL_checknumber(L, 4);
    CGFloat     fontSize = luaL_checknumber(L, 5);
    NSString    *textColor = NStr(luaL_checkstring(L, 6));
    CGFloat     textcolorAlpha = luaL_checknumber(L, 7);
    NSString    *imagePath = NStr(luaL_checkstring(L, 8));
    UIImage     *bgImg = [[MACGE shareInstance].resHelper loadImageWithLocalPath:imagePath];
    
    NSString *textAligment = NStr(luaL_checkstring(L, 9));
    
    NSTextAlignment t;
    
    if ([textAligment isEqualToString:@"LEFT"])
    {
        t = NSTextAlignmentLeft;
    }
    else if ([textAligment isEqualToString:@"RIGHT"])
    {
        t = NSTextAlignmentRight;
    }
    else
    {
        t = NSTextAlignmentCenter;
    }
    
    [[ACGEDirector shareInstance] fullLineViewWithContentString:contentString
                                             singleLineduartion:lineDuartion
                                                 backgoundColor:[UIColor colorWithHexString:hexColor
                                                                                      alpha:colorAlpha]
                                                       fontSize:fontSize
                                                      textColor:[UIColor colorWithHexString:textColor
                                                                                      alpha:textcolorAlpha]
                                                          bgimg:bgImg
                                                  textAlignment:t];
    
    return 1;
}

static luaL_Reg MACGE_Line_Lib[] = {
    {"Display",         MACGE_Lines_Display},
    {"Hide",            MACGE_Lines_Hide},
    {"FullLine",        MACGE_Lines_FullLinesWithAllParmas},
    {NULL, NULL},
};


int private_MACGE_OpenLineLib(lua_State* L)
{
    luaL_newlib(L,MACGE_Line_Lib);
    
    return 1; //return one value
}

int MACGE_OpenLineLib(lua_State* L)
{
    luaL_requiref(L,"MACGE_Line", private_MACGE_OpenLineLib,1);
    
    return 1;
}


