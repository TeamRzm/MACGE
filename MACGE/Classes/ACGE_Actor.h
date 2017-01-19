//
//  ACGE_Actor.h
//  MACGE
//
//  Created by Martin.Ren on 2016/12/22.
//  Copyright © 2016年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ACGE_Actor : NSObject
@property (nonatomic,nonnull,copy)      NSString    *identifier;
@property (nonatomic,nonnull,copy)      UIImage     *img;
@property (nonatomic,assign)            CGRect      frame;
@property (nonatomic, strong)           UIImageView *displayView;
@end
