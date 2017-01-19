//
//  ACGE_BaseLineView.h
//  MACGE
//
//  Created by Martin.Ren on 2017/1/9.
//  Copyright © 2017年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACGE_BaseLineView : UIView

+ (instancetype) LineView;

- (void) displayLineString : (NSString*) lineStr actorName : (NSString*) actorName;

@end
