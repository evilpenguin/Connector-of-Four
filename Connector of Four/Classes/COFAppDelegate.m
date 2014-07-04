//
//  AppDelegate.m
//  Connector of Four
//
//  Created by James D Emrich on 6/27/14.
//  Copyright (c) 2014 Emrich. All rights reserved.
//

#import "COFAppDelegate.h"

@implementation COFAppDelegate
@synthesize window = _window;

#pragma mark - == COFAppDelegate ==

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Create our board engine and view controller :)
    _boardEngine = [[COFBoardEngine alloc] init];
    [_boardEngine printBoard];
    
    _boardViewController = [[COFBoardViewController alloc] init];
    _boardViewController.boardEngine = _boardEngine;
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = _boardViewController; 
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];

    return YES;
}

#pragma mark - == Memory ==

- (void) dealloc {
    [_boardEngine release];
    [_boardViewController release];
    self.window = nil;
    [super dealloc];
}

@end
