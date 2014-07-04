//
//  COFBoardViewController.h
//  Connector of Four
//
//  Created by James D Emrich on 6/27/14.
//  Copyright (c) 2014 Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COFBoardView.h"
#import "COFBoardEngine.h"
#import "COFPieceView.h"

@interface COFBoardViewController : UIViewController <COFBoardViewDelegate> {
    @private
    UILabel     *_currentPlayer;
    UIButton    *_resetButton;
    BOOL        _addingBoardPiece;
}
@property (nonatomic, readonly) COFBoardView    *boardView;
@property (nonatomic, assign) COFBoardEngine    *boardEngine;

- (instancetype) init;

@end
