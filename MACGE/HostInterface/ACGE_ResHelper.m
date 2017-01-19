//
//  ACGE_ResHelper.m
//  MACGE
//
//  Created by Martin.Ren on 2017/1/12.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//

#import "ACGE_ResHelper.h"
#import "ZipArchive.h"

NSString *staticDevPath = @"";

#define MACGE_DEBUG_LOG(X,...) NSLog(X,...)

@interface ACGE_ResHelper()
{
    
}

@property (nonatomic, strong) NSString* currenACGEPackPath;
@property (nonatomic, strong) NSString* ACGEPackName;
@property (nonatomic, strong) NSString* resbasePath;

@end


@implementation ACGE_ResHelper

//设置开发用的文件夹，不从macgp解压直接使用以下路径
+ (void) SetDevlplerModeWithPath : (NSString*) path
{
    staticDevPath = path;
    
    return ;
}

+ (instancetype) CreateResHelperWithACGEPack : (NSString*) acgePackPath
{
    ACGE_ResHelper *resultObject = [[ACGE_ResHelper alloc] init];
    
    resultObject.currenACGEPackPath = acgePackPath;
    
    [resultObject configAndLoadPack];
    
    return resultObject;
}

- (UIImage*) loadImageWithLocalPath : (NSString*) path
{
    NSString *imgPath = [self loadResWithLocalPath:path];
    
    if (imgPath && imgPath.length > 0)
    {
        return [[UIImage alloc] initWithContentsOfFile:imgPath];
    }
    
    return nil;
}

- (NSString*) getStartingGameScription
{
    return [self loadResWithLocalPath:@"Start.lua"];
}

- (NSString*) loadResWithLocalPath : (NSString*) path
{
    NSString *realPath = [NSString stringWithFormat:@"%@/%@",self.resbasePath, path];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if ( ![fileManager fileExistsAtPath:realPath] )
    {
        NSLog(@"Cant find file %@", realPath);
        
        return nil;
    }
    
    return realPath;
}

- (BOOL) configAndLoadPack
{
    if (staticDevPath && staticDevPath.length > 0)
    {
        self.resbasePath = staticDevPath;
        
        return YES;
    }
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if ( ![fileManager fileExistsAtPath:self.currenACGEPackPath] )
    {
        NSLog(@"Cant find file %@", self.currenACGEPackPath);
        return NO;
    }
    
    self.ACGEPackName = [self.currenACGEPackPath componentsSeparatedByString:@"/"].lastObject;
    self.ACGEPackName = [self.ACGEPackName componentsSeparatedByString:@"."].firstObject;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dcoumentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    self.resbasePath = [dcoumentpath stringByAppendingFormat:@"/%@",self.ACGEPackName];
    return [SSZipArchive unzipFileAtPath:self.currenACGEPackPath toDestination: dcoumentpath];
}

@end
