//
//  RLMLifeMessageRecord.h
//  UPOC_Teacher
//
//  Created by a on 2020/3/2.
//  Copyright © 2020 北京新东方教育科技(集团)有限公司. All rights reserved.
//

#import "RLMObject.h"
#import <Realm.h>
#import "RLMLifeImageRecord.h"
NS_ASSUME_NONNULL_BEGIN
RLM_ARRAY_TYPE(RLMLifeImageRecord)
@interface RLMLifeMessageRecord : RLMObject
//Life Image
@property RLMArray<RLMLifeImageRecord> *imageArrays;
//Life Title
@property NSString *lifeTitle;
//Story Content
@property NSString *storyContent;
//lifeId  === userId 使用userId 存储键
@property NSString *lifeId;
@end

NS_ASSUME_NONNULL_END
