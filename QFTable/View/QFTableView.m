//
//  QFTableView.m
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "QFTableView.h"
#import "QFBaseCell.h"
#import "MJRefresh.h"

@interface NSString (util)
- (NSString *(^)(id))append;
- (NSArray<NSString *> *(^)(NSString *))componentsBySetString;
@end

@interface QFTableView ()
@property (nonatomic, weak)   id objc;
@property (nonatomic, strong) QFTableModel *tableModel;
@property (nonatomic, strong) NSMutableArray *sourceArray;
@end

@implementation QFTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tableModel = [[QFTableModel alloc] init];
        self.sourceArray = [NSMutableArray array];
        self.tableFooterView = [UIView new];
        self.delegate = self.tableModel;
        self.dataSource = self.tableModel;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tableModel = [[QFTableModel alloc] init];
        self.sourceArray = [NSMutableArray array];
        self.tableFooterView = [UIView new];
        self.delegate = self.tableModel;
        self.dataSource = self.tableModel;
    }
    return self;
}

//add QFSectionModel
- (void)addModel:(QFSectionModel*)anObject {
    [self.tableModel addModel:anObject];
}

- (QFSectionModel *)sectionAtIndex:(NSUInteger)index {
    return [self.tableModel sectionAtIndex:index];
}

- (NSUInteger)indexOfSection:(QFSectionModel *)anObject {
    return [self.tableModel indexOfSection:anObject];
}

- (QFCellModel *)cellAtIndexPath:(NSIndexPath *)indexPath {
    QFSectionModel *sectionModel = [self sectionAtIndex:indexPath.section];
    return [sectionModel cellAtIndex:indexPath.row];
}

- (void)cellAtIndexPath:(NSIndexPath *)indexPath resetHeight:(NSInteger)height {
    QFCellModel *cellModel = [self cellAtIndexPath:indexPath];;
    cellModel.height = height;
}

- (void)reloadModel {
    NSArray *arr = nil;
    if (self.sourceArray.count > 0) {
        arr = [self.sourceArray mutableCopy];
    }
    [self clearModel];
    [self loadView:self.objc withArr:arr];
}

//clear all model
- (void)clearModel {
    if (self.sourceArray.count > 0) {
        [self.sourceArray removeAllObjects];
    }
    [self.tableModel clearModel];
}

- (void)refreshView:(id)object withJson:(NSData *)json {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:json
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    [self refreshView:object withArr:dict[@"table"]];
}

- (void)refreshView:(id)object withArr:(NSArray *)arr {
    //先清除数据
    [self clearModel];
    [self loadView:object withArr:arr];
}

- (void)loadView:(id)object withJson:(NSData *)json {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:json
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    [self loadView:object withArr:dict[@"table"]];
}

- (void)loadView:(id)object withArr:(NSArray *)arr {
    
    if (self.objc != object) {
        self.objc = object;
    }
    if (arr.count > 0) {
        [self.sourceArray addObjectsFromArray:arr];
    }
    
    for (NSString *url in arr) {
        
        NSArray<NSString *> *tmpArr = url.componentsBySetString(@"<>");
        
        NSString *sectionSelector = tmpArr[0].append(@":");
        NSString *section = tmpArr[1];
        NSString *cellSelector = tmpArr[2].append(@":");
        
        QFSectionModel *sectionModel = [self sectionAtIndex:section.integerValue];
        if (!sectionModel) {
            sectionModel = [QFSectionModel new];
            [self addModel:sectionModel];
        }
        
        QFCellModel *cellModel = [QFCellModel new];
        [sectionModel addModel:cellModel];
        
        if([object respondsToSelector:NSSelectorFromString(sectionSelector)]){
            [object performSelector:NSSelectorFromString(sectionSelector) withObjects:@[sectionModel]];
        }
        
        if([object respondsToSelector:NSSelectorFromString(cellSelector)]){
            [object performSelector:NSSelectorFromString(cellSelector) withObjects:@[cellModel]];
        }else {
            cellModel.renderBlock = [self renderBlock];
            cellModel.selectionBlock = [self selectionBlock];
        }

    }
    
    //刷新列表
    [self reloadData];
    [self endRefresh];
}

- (QFCellRenderBlock)renderBlock {
    return ^UITableViewCell *(NSIndexPath *indexPath, UITableView *table) {
        QFBaseCell *cell = [QFBaseCell registerTable:table];
        return cell;
    };
}

- (QFCellSelectionBlock)selectionBlock {
    return ^(NSIndexPath *indexPath, UITableView *table) {
        [table deselectRowAtIndexPath:indexPath animated:YES];
    };
}

- (void)beginRefresh {
    if (_refreshBlock) {
        [self.mj_header beginRefreshing];
    }
}

//stop refresh
-(void)endRefresh {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)setRefreshBlock:(QFRefreshBlock)refreshBlock {
    _refreshBlock = refreshBlock;
    if (_refreshBlock) {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _refreshBlock();
        }];
    }else {
        self.mj_header = nil;
    }
}

- (void)setLoadMoreBlock:(QFLoadMoreBlock)loadMoreBlock {
    _loadMoreBlock = loadMoreBlock;
    if (_loadMoreBlock) {
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
           _loadMoreBlock();
        }];
    }else {
        self.mj_footer = nil;
    }
}

@end

@implementation NSString (util)
- (NSString *(^)(id))append {
    return ^NSString *(id obj) {
        return [NSString stringWithFormat:@"%@%@", self,obj];
    };
}
- (NSArray<NSString *> *(^)(NSString *))componentsBySetString {
    return ^NSArray<NSString *> *(NSString *separator) {
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:separator];
        NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSArray *arr = [self componentsSeparatedByCharactersInSet:characterSet];
        NSMutableArray *mutablerArr = [NSMutableArray new];
        //过滤掉为空的字符串
        for (int i=0; i<arr.count; i++) {
            NSString *str = arr[i];
            if (str.length > 0) {
                //过滤掉字符串两端为空的字符
                NSString *trimStr = [str stringByTrimmingCharactersInSet:charSet];
                if (trimStr.length > 0) {
                    [mutablerArr addObject:trimStr];
                }
            }
        }
        return mutablerArr;
    };
}
@end
