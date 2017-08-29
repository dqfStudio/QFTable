//
//  QFTableView.m
//  TableModel
//
//  Created by dqf on 2017/7/14.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "QFTableView.h"
#import <MJRefresh.h>

@interface NSString (util)

- (NSString *(^)(id))append;
- (NSString *(^)(NSString *, NSString *))replace;
- (NSArray<NSString *> *(^)(NSString *))componentsBySetString;

@end

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
        
        NSArray<NSString *> *tmpArr = url.componentsBySetString(@"<>&");
        
        NSString *sectionSelector = tmpArr[0].replace(@" ", @"").append(@":");
        NSString *section = tmpArr[1].replace(@" ", @"");
        NSString *cellSelector = tmpArr[2].replace(@" ", @"").append(@":");
        
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

@implementation NSString (util)

- (NSString *(^)(id))append {
    return ^NSString *(id obj) {
        return [NSString stringWithFormat:@"%@%@", self,obj];
    };
}

- (NSString *(^)(NSString *, NSString *))replace {
    return ^NSString *(NSString *org1, NSString *org2) {
        return [self stringByReplacingOccurrencesOfString:org1 withString:org2];
    };
}

- (NSArray<NSString *> *(^)(NSString *))componentsBySetString {
    return ^NSArray<NSString *> *(NSString *separator) {
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:separator];
        NSArray *arr = [self componentsSeparatedByCharactersInSet:characterSet];
        NSMutableArray *mutablerArr = [NSMutableArray new];
        //过滤掉为空的字符串
        for (int i=0; i<arr.count; i++) {
            NSString *str = arr[i];
            if (str.length > 0) {
                [mutablerArr addObject:str];
            }
        }
        return mutablerArr;
    };
}

@end
