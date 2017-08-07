//
//  QFCellModel.h
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef UITableViewCell * (^QFCellRenderBlock)(NSIndexPath *indexPath, UITableView *table);
typedef NSIndexPath * (^QFCellWillSelectBlock)(NSIndexPath *indexPath, UITableView *table);
typedef void (^QFCellSelectionBlock)(NSIndexPath *indexPath, UITableView *table);
typedef void (^QFCellWillDisplayBlock)(UITableViewCell *cell, NSIndexPath *indexPath, UITableView *table);
typedef void (^QFCellCommitEditBlock)(NSIndexPath *indexPath, UITableView *table,
UITableViewCellEditingStyle editingStyle);

/** Table view's row model */
@interface QFCellModel : NSObject

@property (nonatomic, copy) QFCellRenderBlock renderBlock;            // required
@property (nonatomic, copy) QFCellWillDisplayBlock willDisplayBlock;  // optional
@property (nonatomic, copy) QFCellWillSelectBlock willSelectBlock;    // optional
@property (nonatomic, copy) QFCellWillSelectBlock willDeselectBlock;  // optional
@property (nonatomic, copy) QFCellSelectionBlock selectionBlock;      // optional
@property (nonatomic, copy) QFCellSelectionBlock deselectionBlock;    // optional
@property (nonatomic, copy) QFCellCommitEditBlock commitEditBlock;    // optional
// if not specified, will use UITableViewAutomaticDimension as default value
@property (nonatomic, assign) CGFloat height;  // optional
@property (nonatomic, assign) BOOL canEdit;    // default NO
//@property (nonatomic, assign) BOOL canMove;   //default NO
@property (nonatomic, assign) UITableViewCellEditingStyle editingStyle;  // cell's editing style
@property (nonatomic, copy) NSString *deleteConfirmationButtonTitle;  // delete confirmation title

//实例化对象
+ (QFCellModel *)cell;

@end
