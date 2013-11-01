//
//  NSArray+ULIUtils.m
//  uli
//
//  Created by Ethan Lin on 11/1/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import "NSArray+ULIUtils.h"

@implementation NSArray (ULIUtils)

- (id)uli_randomObject
{
    return self.count > 0 ? [self objectAtIndex:arc4random_uniform((UInt32)self.count)] : nil;
}

@end
