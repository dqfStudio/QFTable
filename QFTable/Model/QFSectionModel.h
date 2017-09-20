//
//  QFSectionModel.h
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "QFCellModel.h"

typedef UIView * (^QFViewRenderBlock)(NSInteger section, UITableView *table);
typedef CGFloat (^QFSectionHeightBlock)(NSInteger section, UITableView *table);

/** Table view's section model */
@interface QFSectionModel : NSObject

@property (nonatomic, strong) NSString *headerTitle;  // optional
@property (nonatomic, strong) NSString *footerTitle;  // optional
// if not specified, will use UITableViewAutomaticDimension as default value
@property (nonatomic, assign) CGFloat headerHeight;  // optional
@property (nonatomic, assign) CGFloat footerHeight;  // optional

// view render blocks' priority is higher then view property.
// if headerViewRenderBlock and headerView are both provided, headerViewRenderBlock will be used
@property (nonatomic, copy) QFSectionHeightBlock headerHeightBlock;  // block to header height
@property (nonatomic, copy) QFSectionHeightBlock footerHeightBlock;  // block to footer height
@property (nonatomic, copy) QFViewRenderBlock headerViewRenderBlock;  // block to render header view
@property (nonatomic, copy) QFViewRenderBlock footerViewRenderBlock;  // block to render footer view
@property (nonatomic, strong) UIView *headerView;  // section header view
@property (nonatomic, strong) UIView *footerView;  // section footer view

//向model添加对象数据
- (void)addModel:(QFCellModel *)anObject;

- (QFCellModel *)cellAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfCell:(QFCellModel *)anObject;

- (NSUInteger)cells;

//clear all model
- (void)clearModel;

@end
