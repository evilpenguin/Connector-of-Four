//
//  COFPieceView.m
//  Connector of Four
//
//  Created by James D Emrich on 6/27/14.
//  Copyright (c) 2014 Emrich. All rights reserved.
//

#import "COFPieceView.h"

@implementation COFPieceView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    
    return self;
}

#pragma mark - == Public Methods ==

- (void) updateBackgroundColorForPlayer:(PlayerNumber)player {
    switch (player) {
        case PlayerNumberOne:
            self.backgroundColor = [UIColor redColor];
            break;
        case PlayerNumberTwo:
            self.backgroundColor = [UIColor yellowColor];
            break;
        default:
            break;
    }
}

@end
