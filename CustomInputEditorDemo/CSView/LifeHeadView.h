//
//  LifeHeadView.h
//  UPOC_Teacher
//
//  Created by a on 2020/1/20.
//  Copyright © 2020 星梦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSTextInputView.h"

@protocol LifeHeadViewDelegate <NSObject>

-(void)didClickActionWithInputType:(InputType)inputType;
-(void)didChangeTextViewHeight:(CGFloat)height keyBoardHeight:(CGFloat)keyBoardHeight;

@end
NS_ASSUME_NONNULL_BEGIN

@interface LifeHeadView : UIView

@property(nonatomic, strong, readonly)NSString *titleString;
@property(nonatomic, strong, readonly)NSString *storyContent;
@property(nonatomic, weak) id<LifeHeadViewDelegate> lifeHeadViewDelegate;
- (void)setTitle:(NSString *)titleString storyContent:(NSString *)storyContent;
@property(nonatomic, assign) BOOL isTitleEditting;

@end

NS_ASSUME_NONNULL_END
