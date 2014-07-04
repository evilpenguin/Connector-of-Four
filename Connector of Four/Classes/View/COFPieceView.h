//
//  COFPieceView.h
//  Connector of Four
//
//  Created by James D Emrich on 6/27/14.
//  Copyright (c) 2014 Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COFBoardEngine.h"

#define GAME_PIECE_SIZE     85.0f

@interface COFPieceView : UIView {
    
}

- (instancetype) initWithFrame:(CGRect)frame;
- (void) updateBackgroundColorForPlayer:(PlayerNumber)player;

@end
