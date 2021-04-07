//
//  CSToolBarCell.m
//  UPOC_Teacher
//
//  Created by a on 2019/12/11.
//  Copyright © 2019 北京新东方教育科技(集团)有限公司. All rights reserved.
//

#import "CSToolBarCell.h"
@interface CSToolBarCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation CSToolBarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)bindObject:(NSString  *)imageName {
    self.imgView.image = [UIImage imageNamed:imageName];
}

@end
