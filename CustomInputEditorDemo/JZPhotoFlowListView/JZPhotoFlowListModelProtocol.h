//
//  JZPhotoFlowListModelProtocol.h
//  CustomInputEditorDemo
//
//  Created by zhanggaotong on 2021/3/30.
//  Copyright © 2021 Xdf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JZPhotoFlowListModelProtocol <NSObject>

@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, strong) UIImage *photoImage;

@end

NS_ASSUME_NONNULL_END
