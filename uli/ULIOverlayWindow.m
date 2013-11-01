//
//  ULIOverlayWindow.m
//  uli
//
//  Created by Yi-Jheng Lin (yzlin) on 10/30/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import "ULIOverlayWindow.h"

@interface ULIOverlayWindow ()

@property (nonatomic, strong) CALayer *rootLayer;

@end

@implementation ULIOverlayWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    if (!(self = [super initWithContentRect:contentRect styleMask:style backing:bufferingType defer:flag]))
        return nil;

    self.opaque = NO;
    self.alphaValue = 1.0;
    self.backgroundColor = [NSColor clearColor];
    self.level = NSScreenSaverWindowLevel + 1;
    self.ignoresMouseEvents = YES;
    NSView *contentView = self.contentView;
    contentView.alphaValue = 0;
    contentView.wantsLayer = YES;
    contentView.needsDisplay = YES;

    _rootLayer = [CALayer layer];
    _rootLayer.delegate = self;
    _rootLayer.bounds = contentView.frame;
    contentView.layer = _rootLayer;

    [self orderFrontRegardless];

    return self;
}

- (void)addLayer:(CALayer *)layer
{
    [_rootLayer addSublayer:layer];
}

- (void)clear
{
    _rootLayer.sublayers = nil;
}

@end
