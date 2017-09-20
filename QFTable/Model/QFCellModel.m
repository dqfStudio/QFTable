//
//  QFCellModel.m
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "QFCellModel.h"

@implementation QFCellModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _height = UITableViewAutomaticDimension;
    }
    return self;
}

@end
