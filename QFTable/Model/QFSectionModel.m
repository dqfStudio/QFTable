//
//  QFSectionModel.m
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 dqfStudio. All rights reserved.
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

+ (QFSectionModel *)section {
    return [[self alloc] init];
}

- (void)addObject:(QFCellModel *)anObject {
    if ([anObject isKindOfClass:[QFCellModel class]]) {
        if (![self.cellModelArray containsObject:anObject]) {
            [self.cellModelArray addObject:anObject];
        }
    }
}

- (QFCellModel *)objectAtIndex:(NSUInteger)index {
    if (index < self.cellModelArray.count) {
        return self.cellModelArray[index];
    }
    return nil;
}

- (NSUInteger)indexOfObject:(QFCellModel *)anObject {
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
