//
//  QFSectionModel.m
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "QFSectionModel.h"

@interface QFSectionModel ()
@property (nonatomic) NSMutableArray<QFCellModel *> *cellModelArray;
@end

@implementation QFSectionModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _headerHeight = UITableViewAutomaticDimension;
        _footerHeight = UITableViewAutomaticDimension;
        _cellModelArray = [NSMutableArray array];
    }
    return self;
}

- (void)addModel:(QFCellModel *)anObject {
    if ([anObject isKindOfClass:[QFCellModel class]]) {
        if (![self.cellModelArray containsObject:anObject]) {
            [self.cellModelArray addObject:anObject];
        }
    }
}

- (QFCellModel *)cellAtIndex:(NSUInteger)index {
    if (index < self.cellModelArray.count) {
        return self.cellModelArray[index];
    }
    return nil;
}

- (NSUInteger)indexOfCell:(QFCellModel *)anObject {
    if ([anObject isKindOfClass:[QFCellModel class]]) {
        return [self.cellModelArray indexOfObject:anObject];
    }
    return 0;
}

- (NSUInteger)cells {
    return self.cellModelArray.count;
}

- (void)clearModel {
    if (self.cellModelArray.count > 0) {
        [self.cellModelArray removeAllObjects];
    }
}

@end
