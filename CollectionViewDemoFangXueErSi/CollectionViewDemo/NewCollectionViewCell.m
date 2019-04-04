//
//  NewCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by maqianli on 2019/4/4.
//  Copyright © 2019 onesmart. All rights reserved.
//

#import "NewCollectionViewCell.h"

@interface NewCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation NewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.label.text = title;
}

@end
