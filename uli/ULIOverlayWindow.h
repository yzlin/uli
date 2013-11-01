//
//  ULIOverlayWindow.h
//  uli
//
//  Created by Yi-Jheng Lin (yzlin) on 10/30/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ULIOverlayWindow : NSWindow

- (void)addLayer:(CALayer *)layer;
- (void)clear;

@end
