//
//  ULIDrawRect.h
//  uli
//
//  Created by Ethan Lin on 10/31/13.
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
