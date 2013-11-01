//
//  main.m
//  uli
//
//  Created by Yi-Jheng Lin (yzlin) on 10/30/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import "ULIAppDelegate.h"
#import "ULIDrawRect.h"

static void show_help()
{
    static char *help = "\n"
    "uli draws a rect on the screen. Useful for debugging.\n"
    "See https://github.com/yzlin/\n"
    "\n"
    "Usage:\n"
    "uli rect <rect> [label] [colour] [opacity]         - draws a rect with bottom left origin\n"
    "uli flipped_rect <rect> [label] [colour] [opacity] - draws a rect with top left origin\n"
    "uli clear                                          - clears all rects\n"
    "uli quit                                           - quits server\n"
    "uli help                                           - shows this message\n"
    "uli version                                        - shows version number\n"
    "\n";
    fprintf(stderr, "%s", help);
}

int main(int argc, const char * argv[])
{
    if (argc < 2) {
        show_help();
        return EXIT_FAILURE;
    }

    if (!strcasecmp(argv[1], "server")) {
        @autoreleasepool {
            ULIAppDelegate *appDelegate = [ULIAppDelegate new];
            [NSApplication sharedApplication].delegate = appDelegate;
            [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
#if DEBUG
            NSMenu *menuBar = [NSMenu new];
            NSMenuItem *appMenuItem = [NSMenuItem new];
            [menuBar addItem:appMenuItem];
            [NSApp setMainMenu:menuBar];
            NSMenu *appMenu = [NSMenu new];
            NSString *appName = @"ULIServer";
            NSString *quitTitle = [@"Quit" stringByAppendingString:appName];
            NSMenuItem *quitMenuItem = [[NSMenuItem alloc] initWithTitle:quitTitle action:@selector(terminate:) keyEquivalent:@"q"];
            [appMenu addItem:quitMenuItem];
            appMenuItem.submenu = appMenu;
#endif
            [NSApp run];
        }
    } else if (!strcasecmp(argv[1], "help")) {
        show_help();
        return EXIT_SUCCESS;
    }

    @autoreleasepool {
        if (![ULIDrawRect servingProxy]) {
            [NSTask launchedTaskWithLaunchPath:[NSString stringWithUTF8String:argv[0]] arguments:@[ @"server" ]];

            int leftTime = 5000;
            while (![ULIDrawRect servingProxy] && leftTime > 0) {
                usleep(1000000);
                leftTime -= 1000;
            }

            if (![ULIDrawRect servingProxy]) {
                fprintf(stderr, "Couldn't boot server\n");
                exit(EXIT_FAILURE);
            }
        }

        @try {
            NSError *error = [[ULIDrawRect servingProxy] handleCommand:[NSProcessInfo processInfo].arguments];
            if (error) {
                fprintf(stderr, "%s\n", error.localizedDescription.UTF8String);
                show_help();
                return EXIT_FAILURE;
            }
        }
        @catch (NSException *ex) {
        };
    }

    return 0;
}

