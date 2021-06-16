//
//  RLMLifeMessageRecord.m
//  UPOC_Teacher
//
//  Created by a on 2020/3/2.
//  Copyright © 2020 星梦. All rights reserved.
//

#import "RLMLifeMessageRecord.h"
@implementation RLMLifeMessageRecord
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *dateId = dic[@"lifeId"];
    if (![dateId isKindOfClass:[NSNumber class]]) return NO;
    _lifeId = [NSString stringWithFormat:@"%@",dateId];
    return YES;
}
@end
