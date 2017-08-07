//
//  QFTableModel.h
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "QFSectionModel.h"

/**
 *  QFTableModel implements some methods in UITableViewDelegate & UITableViewDataSource.
 *  it can be used as the delegate & dataSource of a tableView.
 *  For those methods it doesn't implement, you can implement them in its subclass.
 */
@interface QFTableModel : NSObject <UITableViewDelegate, UITableViewDataSource>

//实例化对象
+ (QFTableModel *)table;

//向model添加对象数据
- (void)addObject:(QFSectionModel *)anObject;

- (QFSectionModel *)objectAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfObject:(QFSectionModel *)anObject;

- (NSUInteger)sections;

//clear all model
- (void)clearModel;

@end
