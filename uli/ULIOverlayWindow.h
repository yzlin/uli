//
//  ULIOverlayWindow.h
//  uli
//
//  Created by Ethan Lin on 11/1/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ULIOverlayWindow : NSWindow

- (void)addLayer:(CALayer *)layer;
- (void)clear;

@end
