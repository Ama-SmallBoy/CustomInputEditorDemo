//
//  CSToolBarCell.m
//  UPOC_Teacher
//
//  Created by a on 2019/12/11.
//  Copyright © 2019 星梦. All rights reserved.
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
