//
//  QFTableModel.m
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "QFTableModel.h"

@interface QFTableModel ()
@property (nonatomic) NSMutableArray<QFSectionModel *> *sectionModelArray;
@end

@implementation QFTableModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _sectionModelArray = [NSMutableArray array];
    }
    return self;
}

- (void)addModel:(QFSectionModel *)anObject {
    if ([anObject isKindOfClass:[QFSectionModel class]]) {
        if (![self.sectionModelArray containsObject:anObject]) {
            [self.sectionModelArray addObject:anObject];
        }
    }
}

- (QFSectionModel *)sectionAtIndex:(NSUInteger)index {
    if (index < self.sectionModelArray.count) {
        return self.sectionModelArray[index];
    }
    return nil;
}

- (NSUInteger)indexOfSection:(QFSectionModel *)anObject {
    if ([anObject isKindOfClass:[QFSectionModel class]]) {
        return [self.sectionModelArray indexOfObject:anObject];
    }
    return 0;
}

- (NSUInteger)sections {
    return self.sectionModelArray.count;
}

- (void)clearModel {
    if (self.sectionModelArray.count > 0) {
        [self.sectionModelArray removeAllObjects];
    }
}

- (QFSectionModel*)sectionModelAtSection:(NSInteger)section {
    @try {
        QFSectionModel *sectionModel = self.sectionModelArray[section];
        return sectionModel;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (QFCellModel*)cellModelAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        QFSectionModel *sectionModel = self.sectionModelArray[indexPath.section];
        QFCellModel *cellModel = [sectionModel cellAtIndex:indexPath.row];
        return cellModel;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QFCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    QFCellHeightBlock heightBlock = cellModel.heightBlock;
    if (heightBlock) {
        return heightBlock(indexPath, tableView);
    } else {
        return cellModel.height;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    QFSectionModel *sectionModel = [self sectionModelAtSection:section];
    QFSectionHeightBlock headerHeightBlock = sectionModel.headerHeightBlock;
    if (headerHeightBlock) {
        return headerHeightBlock(section, tableView);
    } else {
        return sectionModel.headerHeight;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    QFSectionModel *sectionModel = [self sectionModelAtSection:section];
    QFSectionHeightBlock footerHeightBlock = sectionModel.footerHeightBlock;
    if (footerHeightBlock) {
        return footerHeightBlock(section, tableView);
    } else {
        return sectionModel.footerHeight;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QFSectionModel *sectionModel = [self sectionModelAtSection:section];
    QFViewRenderBlock headerViewRenderBlock = sectionModel.headerViewRenderBlock;
    if (headerViewRenderBlock) {
        return headerViewRenderBlock(section, tableView);
    } else {
        return sectionModel.headerView;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    QFSectionModel *sectionModel = [self sectionModelAtSection:section];
    QFViewRenderBlock footerViewRenderBlock = sectionModel.footerViewRenderBlock;
    if (footerViewRenderBlock) {
        return footerViewRenderBlock(section, tableView);
    } else {
        return sectionModel.footerView;
    }
}
- (nullable NSIndexPath *)tableView:(UITableView *)tableView
           willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QFCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    QFCellWillSelectBlock willSelectBlock = cellModel.willSelectBlock;
    if (willSelectBlock) {
        return willSelectBlock(indexPath, tableView);
    }
    return indexPath;
}
- (nullable NSIndexPath *)tableView:(UITableView *)tableView
         willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    QFCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    QFCellWillSelectBlock willDeselectBlock = cellModel.willDeselectBlock;
    if (willDeselectBlock) {
        return willDeselectBlock(indexPath, tableView);
    }
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QFCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    QFCellSelectionBlock selectionBlock = cellModel.selectionBlock;
    if (selectionBlock) {
        selectionBlock(indexPath, tableView);
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    QFCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    QFCellSelectionBlock deselectionBlock = cellModel.deselectionBlock;
    if (deselectionBlock) {
        deselectionBlock(indexPath, tableView);
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
     QFCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    return cellModel.deleteConfirmationButtonTitle;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self sections];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QFSectionModel *sectionModel = [self sectionModelAtSection:section];
    return [sectionModel cells];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QFCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    UITableViewCell *cell = nil;
    QFCellRenderBlock renderBlock = cellModel.renderBlock;
    if (renderBlock) {
        cell = renderBlock(indexPath, tableView);
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    QFCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    QFCellWillDisplayBlock willDisplayBlock = cellModel.willDisplayBlock;
    if (willDisplayBlock) {
        willDisplayBlock(cell, indexPath, tableView);
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    QFSectionModel *sectionModel = [self sectionModelAtSection:section];
    return sectionModel.headerTitle;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    QFSectionModel *sectionModel = [self sectionModelAtSection:section];
    return sectionModel.footerTitle;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    QFCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    return cellModel.canEdit;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    QFCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    QFCellCommitEditBlock commitEditBlock = cellModel.commitEditBlock;
    if (commitEditBlock) {
        commitEditBlock(indexPath, tableView, editingStyle);
    }
}

@end
