//
//  NSObject+selector.h
//  MGMobileMusic
//
//  Created by dqf on 2017/8/2.
//  Copyright © 2017年 migu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (selector)

- (id)performSelector:(SEL)aSelector withObjects:(NSArray*)objects;

@end
