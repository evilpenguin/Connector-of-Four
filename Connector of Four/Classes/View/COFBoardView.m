//
//  COFBoardView.m
//  Connector of Four
//
//  Created by James D Emrich on 6/27/14.
//  Copyright (c) 2014 Emrich. All rights reserved.
//

#import "COFBoardView.h"
#import "COFPieceView.h"

@implementation COFBoardView
@synthesize delegate = _delegate;

#pragma mark - == COFBoardView ==

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _delegate = nil;
    }
    
    return self;
}

- (void) drawRect:(CGRect)rect {
    UIImage *boardImage = [UIImage imageNamed:@"board"];
    [boardImage drawInRect:rect];
}

#pragma mark - == Touch Methods ==

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(boardView:didTouchColumn:)]) {
        if (event != nil && event.allTouches != nil) {
            UITouch *touch = [event.allTouches anyObject];
            if (touch != nil) {
                CGPoint location = [touch locationInView:touch.view];
                
                uint8_t x = location.x / GAME_PIECE_SIZE;
                [_delegate boardView:self didTouchColumn:x];
            }
        }
    }
}

#pragma mark - == Memory ==

- (void) dealloc {
    self.delegate = nil;
    [super dealloc];
}

@end
