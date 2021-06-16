//
//  LifeDataTool.h
//  UPOC_Teacher
//
//  Created by a on 2020/3/2.
//  Copyright © 2020 星梦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMLifeMessageRecord.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SaveComplent)(void);

@interface LifeDataTool : NSObject

///将 Images 转换成 Datas
+ (NSArray *)conventImagesToImageDatas:(NSArray *)imageArrays;
///存储到本地 编辑的内容
+ (void)writeLifeMessageWithJsonData:(NSDictionary *)jsonData saveComplent:(SaveComplent)saveComplent;
///读取本地内容
+ (NSDictionary *)readLocationLifeData;
///删除本地数据
+ (void)deleteLifeMessageRecord;

@end

NS_ASSUME_NONNULL_END
