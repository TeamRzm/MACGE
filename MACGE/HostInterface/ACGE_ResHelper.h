//
//  ACGE_ResHelper.h
//  MACGE
//
//  Created by Martin.Ren on 2017/1/12.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ACGE_ResHelper : NSObject

+ (instancetype) CreateResHelperWithACGEPack : (NSString*) acgePackPath;

+ (void) SetDevlplerModeWithPath : (NSString*) path;

- (NSString*) loadResWithLocalPath : (NSString*) path;

- (UIImage*) loadImageWithLocalPath : (NSString*) path;

- (NSString*) getStartingGameScription;


@end
