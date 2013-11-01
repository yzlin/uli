//
//  ULIAppDelegate.m
//  uli
//
//  Created by Yi-Jheng Lin (yzlin) on 10/30/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import "ULIDrawRect.h"

#import "ULIAppDelegate.h"

@implementation ULIAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[ULIDrawRect defaultInstance] listen];
    NSLog(@"server launched");
}

@end
