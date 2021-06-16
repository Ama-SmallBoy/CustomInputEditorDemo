//
//  LifeDataTool.m
//  UPOC_Teacher
//
//  Created by a on 2020/3/2.
//  Copyright © 2020 星梦. All rights reserved.
//

#import "LifeDataTool.h"
#import "RLMLifeImageRecord.h"

@implementation LifeDataTool

#pragma mark============ 数据转换 =======
//将 Images 转换成 Datas
+ (NSArray *)conventImagesToImageDatas:(NSArray *)imageArrays {
    NSMutableArray * imageDatas = [NSMutableArray array];
    for(UIImage * image in imageArrays) {
        NSData * imageData = [LifeDataTool getDataFromImage:image];
        if (imageData) {
            NSDictionary * imageDic = @{
                @"imageData":imageData
            };
            [imageDatas addObject:imageDic];
        }
    }
    return imageDatas.copy;
}

//将UIImage转换为NSData
+ (NSData *)getDataFromImage:(UIImage*)image {
    
    NSData *data;
    
    /*判断图片是不是png格式的文件*/
    
    if(UIImagePNGRepresentation(image)){
        
        data = UIImagePNGRepresentation(image);
    
    /*判断图片是不是jpeg格式的文件*/
    
    }else{
        
        data = UIImageJPEGRepresentation(image,1.0);
    }
    return data;
}
#pragma mark - 存储到本地 编辑的内容
+ (void)writeLifeMessageWithJsonData:(NSDictionary *)jsonData saveComplent:(SaveComplent)saveComplent {
    //获取并封装数据
    RLMLifeMessageRecord * lifeMessageRecord = [[RLMLifeMessageRecord alloc] initWithValue:jsonData];
    //获取Realm
    RLMRealm * realm = [RLMRealm defaultRealm];
    //获取相应的
    //TODO: ---- 临时修改 --
    NSString *whereStr = [NSString stringWithFormat:@"lifeId contains '%@'",@"1233211234567"];
    RLMResults * resultArray = [RLMLifeMessageRecord objectsInRealm:realm where:whereStr];
    if (resultArray.count>0) {
        RLMLifeMessageRecord * realmLifeMessageRecord = (RLMLifeMessageRecord *)resultArray.firstObject;
        [realm transactionWithBlock:^{
            for (RLMLifeImageRecord * lifeImageRecord in realmLifeMessageRecord.imageArrays) {
                [realm deleteObject:lifeImageRecord];
            }
            realmLifeMessageRecord.lifeTitle = lifeMessageRecord.lifeTitle;
            realmLifeMessageRecord.storyContent = lifeMessageRecord.storyContent;
            realmLifeMessageRecord.lifeId = lifeMessageRecord.lifeId;
            realmLifeMessageRecord.imageArrays = lifeMessageRecord.imageArrays;
            if (saveComplent) {
                saveComplent();
            }
        }];
        
    }else{
        [realm transactionWithBlock:^{
            [realm addObject:lifeMessageRecord];
            if (saveComplent) {
                saveComplent();
            }
        }];
    }
}

#pragma mark - 拿到本地数据库
+ (RLMLifeMessageRecord *)fetchRLMLifeMessageByReadLocationLifeData {
    //获取Realm
    RLMRealm * realm = [RLMRealm defaultRealm];
    //获取相应的
    //TODO: ---- 临时修改 --
    NSString *whereStr = [NSString stringWithFormat:@"lifeId contains '%@'",@"1233211234567"];
    RLMLifeMessageRecord * lifeMessageRecord = [RLMLifeMessageRecord objectsInRealm:realm where:whereStr].firstObject;
    
    return lifeMessageRecord;
}

#pragma mark - 读取本地内容
+ (NSDictionary *)readLocationLifeData {
     RLMLifeMessageRecord * lifeMessageRecord = [LifeDataTool fetchRLMLifeMessageByReadLocationLifeData];
    if (!lifeMessageRecord) {
        return @{};
    }
    //读取 标题
    NSMutableDictionary * lifeInfo=[NSMutableDictionary dictionary];
    [lifeInfo setObject:lifeMessageRecord.lifeTitle?lifeMessageRecord.lifeTitle:@"" forKey:@"lifeTitle"];
    
    //读取 图片信息
    NSMutableArray * imageArrays = [NSMutableArray array];
    for (RLMLifeImageRecord * lifeImageRecord  in lifeMessageRecord.imageArrays) {
        UIImage * image = [UIImage imageWithData:lifeImageRecord.imageData];
        if (image) {
            [imageArrays addObject:image];
        }
    }
    [lifeInfo setObject:imageArrays forKey:@"imageArrays"];
    
    //读取 内容信息
    [lifeInfo setObject:lifeMessageRecord.storyContent?lifeMessageRecord.storyContent:@"" forKey:@"storyContent"];
    
    return lifeInfo.copy;
}

#pragma mark - 删除本地数据
+ (void)deleteLifeMessageRecord {
    //获取Realm
    RLMRealm * realm = [RLMRealm defaultRealm];
    //获取相应的
    //TODO: - 临时修改
    NSString *whereStr = [NSString stringWithFormat:@"lifeId contains '%@'",@"1233211234567"];
    RLMLifeMessageRecord * lifeMessageRecord = [RLMLifeMessageRecord objectsInRealm:realm where:whereStr].firstObject;
    if (lifeMessageRecord) {
        [realm transactionWithBlock:^{
            for (RLMLifeImageRecord * lifeImageRecord in lifeMessageRecord.imageArrays) {
                [realm deleteObject:lifeImageRecord];
            }
            [realm deleteObject:lifeMessageRecord];
        }];
    }
}

@end
