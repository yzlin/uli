//
//  NSScreen+ULIUtils.m
//  uli
//
//  Created by Yi-Jheng Lin (yzlin) on 10/30/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import "NSScreen+ULIUtils.h"

@implementation NSScreen (ULIUtils)

+ (NSRect)uli_mergedScreenBounds
{
    NSRect rect = CGRectZero;
    for (NSScreen *screen in [NSScreen screens]) {
        rect = NSUnionRect(rect, screen.frame);
    }

    return rect;
}

@end
