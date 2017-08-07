//
//  QFSectionModel.h
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "QFCellModel.h"

typedef UIView * (^QFViewRenderBlock)(NSInteger section, UITableView *table);

/** Table view's section model */
@interface QFSectionModel : NSObject

@property (nonatomic, strong) NSString *headerTitle;  // optional
@property (nonatomic, strong) NSString *footerTitle;  // optional
// if not specified, will use UITableViewAutomaticDimension as default value
@property (nonatomic, assign) CGFloat headerHeight;  // optional
@property (nonatomic, assign) CGFloat footerHeight;  // optional

// view render blocks' priority is higher then view property.
// if headerViewRenderBlock and headerView are both provided, headerViewRenderBlock will be used
@property (nonatomic, copy) QFViewRenderBlock headerViewRenderBlock;  // block to render header view
@property (nonatomic, copy) QFViewRenderBlock footerViewRenderBlock;  // block to render footer view
@property (nonatomic, strong) UIView *headerView;  // section header view
@property (nonatomic, strong) UIView *footerView;  // section footer view

//实例化对象
+ (QFSectionModel *)section;

//向model添加对象数据
- (void)addObject:(QFCellModel *)anObject;

- (QFCellModel *)objectAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfObject:(QFCellModel *)anObject;

- (NSUInteger)cells;

//clear all model
- (void)clearModel;

@end
