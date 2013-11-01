//
//  ULIAppDelegate.m
//  uli
//
//  Created by Ethan Lin on 10/31/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import "ULIDrawRect.h"

#import "ULIAppDelegate.h"

@interface ULIAppDelegate ()

@property (nonatomic, strong) NSWindow *window;

@end

@implementation ULIAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 200, 200) styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO];
    [_window cascadeTopLeftFromPoint:NSMakePoint(20, 20)];
    _window.title = @"test";
    [_window makeKeyAndOrderFront:nil];

    [[ULIDrawRect defaultInstance] listen];
    NSLog(@"server launched");
}

@end
