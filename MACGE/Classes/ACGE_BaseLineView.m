//
//  ACGE_BaseLineView.m
//  MACGE
//
//  Created by Martin.Ren on 2017/1/9.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//

#import "ACGE_BaseLineView.h"

@implementation ACGE_BaseLineView

+ (instancetype) LineView
{
    ACGE_BaseLineView *lineView = [[ACGE_BaseLineView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    
    return lineView;
}

- (void) displayLineString : (NSString*) lineStr actorName : (NSString*) actorName
{
    return;
}

@end
