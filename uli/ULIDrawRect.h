//
//  ULIDrawRect.h
//  uli
//
//  Created by Yi-Jheng Lin (yzlin) on 10/30/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ULIDrawRectServing

- (NSError *)handleCommand:(NSArray *)args;

@end

@interface ULIDrawRect : NSObject <ULIDrawRectServing>

+ (instancetype)defaultInstance;
+ (NSDistantObject<ULIDrawRectServing> *)servingProxy;

- (void)listen;

@end
