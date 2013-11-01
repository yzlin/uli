//
//  ULIDrawRect.m
//  uli
//
//  Created by Yi-Jheng Lin (yzlin) on 10/30/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "NSArray+ULIUtils.h"
#import "NSScreen+ULIUtils.h"
#import "ULIOverlayWindow.h"

#import "ULIDrawRect.h"

#define uli_safe(OBJ) ((NSNull *)(OBJ) == [NSNull null] ? nil : (OBJ))

static NSString * const kULIErrorDomain = @"ULIErrorDomain";

static const NSUInteger kULIAutoShutdownDelay = 3600; // 1 hr
static NSString * const kULIServerID = @"org.yzlin.uli.server";

static CGRect ULICGRectFlip(NSRect rect)
{
    float screenHeight = NSMaxY(((NSScreen *)[NSScreen screens].firstObject).frame);
    return CGRectMake(rect.origin.x, screenHeight - NSMaxY(rect), rect.size.width, rect.size.height);
}

@interface ULIDrawRect ()

@property (nonatomic, strong) NSConnection *connection;

@property (nonatomic, strong) ULIOverlayWindow *overlayWindow;

@end

@implementation ULIDrawRect

+ (instancetype)defaultInstance
{
    static ULIDrawRect *_sharedObj = nil;
    static dispatch_once_t _once;
    dispatch_once(&_once, ^{
        _sharedObj = [ULIDrawRect new];
    });

    return _sharedObj;
}

+ (NSDistantObject<ULIDrawRectServing> *)servingProxy
{
    static NSDistantObject<ULIDrawRectServing> *proxy = nil;
    if (!proxy) {
        proxy = (NSDistantObject<ULIDrawRectServing> *)[NSConnection rootProxyForConnectionWithRegisteredName:kULIServerID host:nil];
        if (proxy)
            NSLog(@"connected to server");
    }
    return proxy;
}

#pragma mark - Properties

- (NSWindow *)overlayWindow
{
    if (!_overlayWindow) {
        _overlayWindow = [[ULIOverlayWindow alloc] initWithContentRect:[NSScreen uli_mergedScreenBounds]
                                                             styleMask:NSBorderlessWindowMask
                                                               backing:NSBackingStoreBuffered
                                                                 defer:YES];
        NSLog(@"overlayWindow: %lf, %lf, %lf, %lf", NSMinX(_overlayWindow.frame), NSMinY(_overlayWindow.frame), NSWidth(_overlayWindow.frame), NSHeight(_overlayWindow.frame));
    }

    return _overlayWindow;
}

#pragma mark - Main functionality

- (void)addRect:(NSRect)rect withLabel:(NSString *)label color:(NSColor *)color
{
    CALayer *layer = [CALayer layer];
    layer.bounds = rect;
    layer.backgroundColor = color.CGColor;
    layer.position = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    layer.opacity = 1.0;
    layer.layoutManager = [CAConstraintLayoutManager layoutManager];

    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = label ?: NSStringFromRect(rect);
    textLayer.font = (__bridge CFTypeRef)([NSFont fontWithName:@"HelveticaNeue-Bold" size:14.0]);
    textLayer.fontSize = 14.0;
    [textLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                        relativeTo:@"superlayer"
                                                         attribute:kCAConstraintMidY]];
    [textLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX
                                                        relativeTo:@"superlayer"
                                                         attribute:kCAConstraintMidX]];
    CGColorRef cgcolor = CGColorCreateGenericGray(0, 1);
    textLayer.foregroundColor = cgcolor;
    CGColorRelease(cgcolor);
    textLayer.frame = layer.frame;

    [layer addSublayer:textLayer];
    [self.overlayWindow addLayer:layer];
}

- (void)listen
{
    self.connection = [NSConnection new];
    _connection.rootObject = self;

    if (![_connection registerName:kULIServerID]) {
        exit(EXIT_FAILURE);
    }

    [self resetAutoQuit];
}

- (void)resetAutoQuit
{
    [self.class cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(quit) withObject:nil afterDelay:kULIAutoShutdownDelay];
}

- (void)quit
{
    [[NSApplication sharedApplication] terminate:nil];
}

#pragma mark - ULIDrawRectServing

- (NSError *)handleCommand:(NSArray *)args
{
    if (args.count < 2) {
        return [NSError errorWithDomain:kULIErrorDomain
                                   code:1
                               userInfo:@{ NSLocalizedDescriptionKey: @"Invalid command" }];
    }

    NSString *command = args[1];
    NSArray *parameters = [args subarrayWithRange:NSMakeRange(2, args.count - 2)];
    if ([command isEqualToString:@"rect"] || [command isEqualToString:@"flipped_rect"]) {
        NSRect rect = NSRectFromString(parameters[0]);
        if ([command isEqualToString:@"flipped_rect"])
            rect = ULICGRectFlip(rect);
        NSString *label = nil;
        if (parameters.count > 1)
            label = uli_safe(parameters[1]);
        NSArray *colorList = @[ @"113F8C",
                                @"01A4A4",
                                @"00A1CB",
                                @"61AE24",
                                @"D0D102",
                                @"32742C",
                                @"D70060",
                                @"E54028",
                                @"F18D05",
                                @"616161" ];
        NSString *hexColor = colorList.uli_randomObject;
        if (parameters.count > 2)
            hexColor = uli_safe(parameters[2]) ?: hexColor;
        float opacity = 0.7;
        if (parameters.count > 3)
            opacity = [uli_safe(parameters[3]) floatValue] ?: opacity;
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexColor];
        [scanner scanHexInt:&rgbValue];
        NSColor *color = [NSColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                                         green:((rgbValue & 0xFF00) >> 8)/255.0
                                          blue:(rgbValue & 0xFF)/255.0
                                         alpha:opacity];
        if (CGRectIsEmpty(rect)) {
            return [NSError errorWithDomain:kULIErrorDomain
                                       code:1
                                   userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Couldn't parse a rect from '%@'", parameters[0]] }];
        }

        [self addRect:rect withLabel:label color:color];
        [self resetAutoQuit];
    } else if ([command isEqualToString:@"clear"]) {
        [self.overlayWindow clear];
        [self resetAutoQuit];
    } else if ([command isEqualToString:@"quit"]) {
        [self quit];
    } else {
        return [NSError errorWithDomain:kULIErrorDomain
                                   code:1
                               userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Invalid command: %@", command] }];
    }

    return nil;
}

@end
