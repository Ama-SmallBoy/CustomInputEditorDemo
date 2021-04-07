//
//  LifeTitleView.h
//  UPOC_Teacher
//
//  Created by a on 2020/1/20.
//  Copyright © 2020 北京新东方教育科技(集团)有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LifeTitleViewDelegate <NSObject>
-(void)textFieldDidChangeWithText:(NSString*_Nonnull)text;
@end
NS_ASSUME_NONNULL_BEGIN
@interface LifeTitleView : UIView
@property(nonatomic,assign) NSInteger wordCount;
@property(nonatomic,weak) id<LifeTitleViewDelegate>lifeTitleViewDelegate;
-(void)setTextForDefault:(NSString *)defaultText;
@property(nonatomic,assign) BOOL isTitleEditting;
@end

NS_ASSUME_NONNULL_END
