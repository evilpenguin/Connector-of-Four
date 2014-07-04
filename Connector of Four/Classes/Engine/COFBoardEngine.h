//
//  COFBoardEngine.h
//  Connector of Four
//
//  Created by James D Emrich on 6/27/14.
//  Copyright (c) 2014 Emrich. All rights reserved.
//

//  .  .  .  .  .  .  .  TOP
//  5 12 19 26 33 40 47
//  4 11 18 25 32 39 46
//  3 10 17 24 31 38 45
//  2  9 16 23 30 37 44
//  1  8 15 22 29 36 43
//  0  7 14 21 28 35 42  BOTTOM

#import <Foundation/Foundation.h>

#define BOARD_VERTICAL_SIZE         6
#define BOARD_HORIZONTAL_SIZE       7
#define BITBOARD_VERTICAL_SIZE      7
#define BITBOARD_SIZE               (BITBOARD_VERTICAL_SIZE * BOARD_HORIZONTAL_SIZE)

typedef enum {
    PlayerNumberOne = 0,
    PlayerNumberTwo = 1
} PlayerNumber;

@interface COFBoardEngine : NSObject {
    @private
    uint64_t         _playerOne;
    uint64_t         _playerTwo;
    NSMutableArray  *_bottomOffsets;
    uint8_t         *_columnCount;
    uint8_t         _printIterationCount;
}
@property (nonatomic, readonly) PlayerNumber currentPlayer;

- (instancetype) init;
- (void) resetBoard;
- (void) updateColumn:(uint8_t)column;
- (void) updateColumn:(uint8_t)column forPlayer:(PlayerNumber)player;
- (BOOL) isGameFinished;
- (BOOL) hasPlayerWon:(PlayerNumber)player;
- (void) printBoard;
- (uint8_t) countForColumn:(uint8_t)column;
- (BOOL) canPlayColumn:(uint8_t)column;

@end
