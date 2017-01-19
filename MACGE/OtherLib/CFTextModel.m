//
//  CFTextModel.m
//  11 - 动态表情
//
//  Created by 于传峰 on 15/12/29.
//  Copyright © 2015年 于传峰. All rights reserved.
//

#import "CFTextModel.h"
#import <UIKit/UIKit.h>
#import "CFTextAttachment.h"

@implementation CFTextModel

+ (NSMutableAttributedString*) CreateGIFAttributedStringWithContentStr : (NSAttributedString*) contentAtt
{
    NSString* pattern = @"#[0-9]{1,4}";
    NSRegularExpression* regx = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"EmotionGifList" ofType:@"plist"];
    NSDictionary* emotionDic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableDictionary* gifEomtionDict = [[NSMutableDictionary alloc] init];
    
    [regx enumerateMatchesInString:contentAtt.string options:NSMatchingReportProgress range:NSMakeRange(0, contentAtt.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString* resultString = [contentAtt.string substringWithRange:result.range];
        NSString* gifName = emotionDic[resultString];
        
        for (int i = 0; resultString.length > 2 && !gifName; i++) {
            resultString = [resultString substringWithRange:NSMakeRange(0, resultString.length - 1)];
            gifName = emotionDic[resultString];
        }
        
        if (gifName) {
            gifEomtionDict[NSStringFromRange(NSMakeRange(result.range.location, resultString.length))] = gifName;
        }
    }];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:contentAtt];
    
    NSMutableArray* ranges = [gifEomtionDict.allKeys mutableCopy];
    
    [ranges sortUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        NSRange range1 = NSRangeFromString(obj1);
        NSRange range2 = NSRangeFromString(obj2);
        
        if (range1.location < range2.location) {
            return NSOrderedDescending;
        }
        
        return NSOrderedAscending;
    }];
    
    for (NSString* rangeString in ranges)
    {
        UIImage *gifImg = [UIImage imageNamed:[gifEomtionDict[rangeString] stringByAppendingString:@".gif"]];
        
        CFTextAttachment* attachment = [[CFTextAttachment alloc] init];
        attachment.bounds = CGRectMake(2, -6, gifImg.size.width * .8f + 2, gifImg.size.height * .8f);
        attachment.gifName = gifEomtionDict[rangeString];
        NSAttributedString* attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        [attributedString replaceCharactersInRange:NSRangeFromString(rangeString) withAttributedString:attachmentString];
    }
    
    return attributedString;
}

@end
