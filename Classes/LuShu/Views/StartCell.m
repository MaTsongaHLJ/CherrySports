//
//  StartCell.m
//  气泡Demo
//
//  Created by 嘟嘟 on 2017/9/1.
//  Copyright © 2017年 MC. All rights reserved.
//

#import "StartCell.h"

@implementation StartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.startCellLabel.textColor =self.BgColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
