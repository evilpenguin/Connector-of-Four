//
//  AppDelegate.h
//  Connector of Four
//
//  Created by James D Emrich on 6/27/14.
//  Copyright (c) 2014 Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COFBoardViewController.h"
#import "COFBoardEngine.h"

@interface COFAppDelegate : UIResponder <UIApplicationDelegate> {
    @private
    COFBoardViewController  *_boardViewController;
    COFBoardEngine          *_boardEngine;
}
@property (nonatomic, retain) UIWindow *window;

@end
