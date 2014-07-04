//
//  COFBoardEngine.m
//  Connector of Four
//
//  Created by James D Emrich on 6/27/14.
//  Copyright (c) 2014 Emrich. All rights reserved.
//

#import "COFBoardEngine.h"

@interface COFBoardEngine()
    - (BOOL) isBoardFull;
    - (BOOL) hasPlayerWonTheGame:(uint64_t)player;
@end

@implementation COFBoardEngine
@synthesize currentPlayer = _currentPlayer;

#pragma mark - == BoardEngine ==

- (instancetype) init {
    if (self = [super init]) {
        _playerOne              = 0x00;
        _playerTwo              = 0x00;
        _currentPlayer          = PlayerNumberOne;
        _printIterationCount    = 0;
        
        _bottomOffsets = [[NSMutableArray alloc] initWithCapacity:BOARD_HORIZONTAL_SIZE];
        for (int i = 0; i < BOARD_HORIZONTAL_SIZE; i++) {
            uint8_t byte = BITBOARD_VERTICAL_SIZE * i;
            [_bottomOffsets addObject:[NSData dataWithBytes:&byte length:sizeof(byte)]];
        }

        _columnCount = malloc(sizeof(uint8_t) * BOARD_HORIZONTAL_SIZE);
        for (uint8_t i = 0; i != BOARD_HORIZONTAL_SIZE; i++) {
            _columnCount[i] = (uint8_t)0x00;
        }
    }
    
    return self;
}

#pragma mark - == Public Methods ==

- (void) resetBoard {
    _playerOne      = 0x00;
    _playerTwo      = 0x00;
    _currentPlayer  = PlayerNumberOne;
    
    for (uint8_t i = 0; i != BOARD_HORIZONTAL_SIZE; i++) {
        _columnCount[i] = (uint8_t)0x00;
    }
}

- (void) updateColumn:(uint8_t)column {
    if ([self canPlayColumn:column]) {
        [self updateColumn:column forPlayer:_currentPlayer & 1];
        _currentPlayer++;
    }
}

- (void) updateColumn:(uint8_t)column forPlayer:(PlayerNumber)player {
    if ([self canPlayColumn:column]) {
        NSData *columnData = [_bottomOffsets objectAtIndex:column];
        uint8_t offset = 0x00;
        [columnData getBytes:&offset];

        switch (player) {
            case PlayerNumberOne:
                _playerOne ^= (uint64_t)1 << (offset++ + _columnCount[column]);
                break;
            case PlayerNumberTwo:
                _playerTwo ^= (uint64_t)1 << (offset++ + _columnCount[column]);
                break;
            default:
                break;
        }
        
        _columnCount[column]++;
    }
}

- (BOOL) isGameFinished {
    return [self hasPlayerWon:PlayerNumberOne] || [self hasPlayerWon:PlayerNumberTwo] || [self isBoardFull];
}

- (BOOL) hasPlayerWon:(PlayerNumber)player {
    switch (player) {
        case PlayerNumberOne:   return [self hasPlayerWonTheGame:_playerOne];
        case PlayerNumberTwo:   return [self hasPlayerWonTheGame:_playerTwo];
    }
    
    return NO;
}

- (void) printBoard {
    NSMutableString *ouput = [NSMutableString string];
    
    if (_printIterationCount > 0) {
        [ouput appendFormat:@"Iteration %i:\n", _printIterationCount];
    }
    
    for (int i = BOARD_VERTICAL_SIZE - 1; i >= 0; i--) {
        for (uint64_t j = i; j < BITBOARD_SIZE; j += BOARD_HORIZONTAL_SIZE) {
            uint64_t mask = (uint64_t)1 << j;

            if ((_playerOne & mask) != 0) {
                [ouput appendFormat:@"|R"];
            }
            else if ((_playerTwo & mask) != 0) {
               [ouput appendFormat:@"|Y"];
            }
            else {
                [ouput appendFormat:@"| "];
            }
        }
        [ouput appendString:@"|\n"];
    }
    
    [ouput appendString:@" _ _ _ _ _ _ _ "];
    
    if ([self hasPlayerWon:PlayerNumberOne]) {
        [ouput appendString:@"\n\nRED PLAYER WINS!"];
    }
    else if ([self hasPlayerWon:PlayerNumberTwo]) {
        [ouput appendString:@"\n\nYELLOW PLAYER WINS!"];
    }
    else if ([self isBoardFull]) {
        [ouput appendString:@"\n\nIt's a tie, muhahahaha!"];
    }
    
    NSLog(@"\n%@", ouput);
    _printIterationCount++;
}

- (uint8_t) countForColumn:(uint8_t)column {
    if (column < BOARD_HORIZONTAL_SIZE) {
        return _columnCount[column];
    }
    
    return 0;
}

- (PlayerNumber) currentPlayer {
    return _currentPlayer & 1;
}

- (BOOL) canPlayColumn:(uint8_t)column {
    if (column < BOARD_HORIZONTAL_SIZE) {
        uint8_t columnCount = _columnCount[column];
        return columnCount < BOARD_VERTICAL_SIZE;
    }
    
    return NO;
}

#pragma mark - == Private Methods ==

- (BOOL) isBoardFull {
    for (uint8_t i = 0; i != BOARD_HORIZONTAL_SIZE; i++) {
        if ([self canPlayColumn:i]) {
            return NO;
        }
    }
    
    return YES;
}
- (BOOL) hasPlayerWonTheGame:(uint64_t)player {
    uint64_t diagonalLeft = player & (player >> (uint64_t)6);
    if ((diagonalLeft & (diagonalLeft >> (uint64_t)12)) != 0) {
        return YES;
    }
    
    uint64_t horizontal = player & (player >> (uint64_t)7);
    if ((horizontal & (horizontal >> (uint64_t)14)) != 0) {
        return YES;
    }
    
    uint64_t diagonalRight = player & (player >> (uint64_t)8);
    if ((diagonalRight & (diagonalRight >> (uint64_t)16)) != 0) {
        return YES;
    }
    
    uint64_t vertical = player & (player >> (uint64_t)1);
    if ((vertical & (vertical >> (uint64_t)2)) != 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - == Memory ==

- (void) dealloc {
    [_bottomOffsets release];
    free(_columnCount);
    [super dealloc];
}

@end
