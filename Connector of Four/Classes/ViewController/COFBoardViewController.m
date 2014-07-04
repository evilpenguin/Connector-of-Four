//
//  COFBoardViewController.m
//  Connector of Four
//
//  Created by James D Emrich on 6/27/14.
//  Copyright (c) 2014 Emrich. All rights reserved.
//

#import "COFBoardViewController.h"

@interface COFBoardViewController()
    - (void) addPieceToColumn:(uint8_t)column;
    - (void) resetBoard:(UIButton *)sender;
@end

@implementation COFBoardViewController
@synthesize boardView = _boardView;
@synthesize boardEngine = _boardEngine;

#pragma mark - == COFBoardViewController ==

- (instancetype) init {
    if (self = [super init]) {
        _boardView          = nil;
        _boardEngine        = nil;
        _addingBoardPiece   = NO;
    }

    return self;
}

- (void) viewDidLoad {
    _boardView = [[COFBoardView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - BOARD_WIDTH) / 2.0f,
                                                                (self.view.frame.size.height - BOARD_HEIGHT) / 2.0f,
                                                                BOARD_WIDTH,
                                                                BOARD_HEIGHT)];
    _boardView.delegate = self;
    [self.view addSubview:_boardView];
    
    _currentPlayer = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150.0f) / 2.0f, _boardView.frame.origin.y - 120.0f, 140.0f, 20.0f)];
    _currentPlayer.backgroundColor = [UIColor clearColor];
    _currentPlayer.font = [UIFont systemFontOfSize:17.0f];
    _currentPlayer.textColor = [UIColor purpleColor];
    _currentPlayer.text = @"Player Ones Turn";
    _currentPlayer.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_currentPlayer];

    _resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _resetButton.alpha = 0.0f;
    _resetButton.frame = (CGRect){(self.view.frame.size.width - 100.0f) / 2.0f, (_boardView.frame.origin.y + _boardView.frame.size.height) + 20.0f, 100.0f, 40.0f};
    _resetButton.backgroundColor = [UIColor clearColor];
    [_resetButton.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [_resetButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [_resetButton setTitle:@"Reset Board" forState:UIControlStateNormal];
    [_resetButton addTarget:self action:@selector(resetBoard:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetButton];

    [super viewDidLoad];
}

#pragma mark - == COFBoardViewDelegate ==

- (void) boardView:(COFBoardView *)boardView didTouchColumn:(uint8_t)column {
    if (_boardEngine != nil) {
        [self addPieceToColumn:column];
    }
}

#pragma mark - == Private Methods ==

- (void) addPieceToColumn:(uint8_t)column {
    if (!_addingBoardPiece && [_boardEngine canPlayColumn:column]) {
        _addingBoardPiece = YES;
        
        // Add the game peice
        CGFloat pieceXOffset = ((column + 1.0f) * GAME_PIECE_SIZE) + 3.0f;
        COFPieceView *piece = [[COFPieceView alloc] initWithFrame:CGRectMake(pieceXOffset, (_boardView.frame.origin.y - GAME_PIECE_SIZE), GAME_PIECE_SIZE - 2.0f, GAME_PIECE_SIZE - 1.0f)];
        [piece updateBackgroundColorForPlayer:_boardEngine.currentPlayer];
        [self.view insertSubview:piece belowSubview:_boardView];
        [piece release];

        // Animate the piece down
        [UIView animateWithDuration:0.4f
                              delay:0.3f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^ (void) {
                             uint8_t count = [_boardEngine countForColumn:column];
                             CGFloat yOffset = (_boardView.frame.origin.y + _boardView.frame.size.height) - ((count + 1.0f) * GAME_PIECE_SIZE);
                             
                             piece.frame = (CGRect){piece.frame.origin.x, yOffset, piece.frame.size.width, piece.frame.size.height};
                         }
                         completion:^ (BOOL finished) {
                             // Update the board
                             [_boardEngine updateColumn:column];
                             [_boardEngine performSelectorInBackground:@selector(printBoard) withObject:nil];
                             
                             // Update player label
                             _currentPlayer.text = [self playerLabelTextForPlayer:_boardEngine.currentPlayer];
                             
                             // Check if we are finished
                             if ([_boardEngine isGameFinished]) {
                                 _boardView.userInteractionEnabled = NO;

                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game Over!"
                                                                                     message:@"The game has ended"
                                                                                    delegate:nil
                                                                           cancelButtonTitle:nil
                                                                           otherButtonTitles:@"OK", nil];
                                 [alertView show];
                                 [alertView release];
                                 
                                 [UIView animateWithDuration:0.5f
                                                  animations:^ (void) {
                                                      _resetButton.alpha = 1.0f;
                                                  }];
                             }
                             
                             _addingBoardPiece = NO;
                         }];
    }
}

- (void) resetBoard:(UIButton *)sender {
    _boardView.userInteractionEnabled = YES;
    _currentPlayer.text = @"Player Ones Turn";
    
    [_boardEngine resetBoard];
    
    NSArray *tempSubViews = [NSArray arrayWithArray:self.view.subviews];
    for (UIView *view in tempSubViews) {
        if (![view isKindOfClass:COFBoardView.class] && ![view isKindOfClass:UILabel.class]) {
            [UIView animateWithDuration:0.6f
                             animations:^ (void) {
                                 view.alpha = 0.0f;
                             }
                             completion:^ (BOOL finished) {
                                 if (![view isKindOfClass:UIButton.class]) {
                                     [view removeFromSuperview];
                                 }
                             }];
        }
    }
}

- (NSString *) playerLabelTextForPlayer:(PlayerNumber)player {
    return (player == PlayerNumberOne ? @"Player Ones Turn" : @"Player Twos Turn");
}

#pragma mark - == Memory ==

- (void) dealloc {
    _boardView.delegate = nil;
    [_boardView release];
    [_currentPlayer release];
    [_resetButton release];
    
    [super dealloc];
}

@end
