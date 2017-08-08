//
//  QFTableView.m
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "QFTableView.h"
#import <MJRefresh.h>

@interface QFTableView ()

@property (nonatomic, strong) QFTableModel *tableModel;

@end

@implementation QFTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableModel = [[QFTableModel alloc] init];
        self.tableFooterView = [UIView new];
        self.delegate = self.tableModel;
        self.dataSource = self.tableModel;
    }
    return self;
}

//add QFSectionModel
- (void)addModel:(QFSectionModel*)anObject {
    [self.tableModel addObject:anObject];
}

- (QFSectionModel *)objectAtIndex:(NSUInteger)index {
    return [self.tableModel objectAtIndex:index];
}

- (NSUInteger)indexOfObject:(QFSectionModel *)anObject {
    return [self.tableModel indexOfObject:anObject];
}

- (void)reloadModel {
    [self reloadData];;
}

//clear all model
- (void)clearModel {
    [self.tableModel clearModel];
}

//stop refresh
-(void)endRefresh {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
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
    
    for (NSString *url in arr) {
        
        NSString *sectionSelector = nil;
        NSString *cellSelector = nil;
        NSString *section = nil;
        
        
        NSRange symbolRange = [url rangeOfString:@"&"];
        NSRange leftRange   = [url rangeOfString:@"<"];
        NSRange rightRange  = [url rangeOfString:@">"];
        
        
        sectionSelector = [url substringToIndex:leftRange.location];
        cellSelector = [url substringFromIndex:symbolRange.location+symbolRange.length];
        
        sectionSelector = [sectionSelector stringByReplacingOccurrencesOfString:@" " withString:@""];
        cellSelector = [cellSelector stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        sectionSelector = [NSString stringWithFormat:@"%@:",sectionSelector];
        cellSelector = [NSString stringWithFormat:@"%@:",cellSelector];
        
        section = [url substringToIndex:rightRange.location];
        section = [section substringFromIndex:leftRange.location+leftRange.length];
        section = [section stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        [object performSelector:NSSelectorFromString(sectionSelector) withObjects:@[section]];
        [object performSelector:NSSelectorFromString(cellSelector) withObjects:@[section]];
        
    }
    
    //刷新列表
    [self reloadModel];
    [self endRefresh];
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

