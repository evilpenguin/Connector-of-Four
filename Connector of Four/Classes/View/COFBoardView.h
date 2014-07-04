//
//  COFBoardView.h
//  Connector of Four
//
//  Created by James D Emrich on 6/27/14.
//  Copyright (c) 2014 Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BOARD_WIDTH     595.0f
#define BOARD_HEIGHT    510.0f

@class COFBoardView;
@protocol COFBoardViewDelegate <NSObject>
    - (void) boardView:(COFBoardView *)boardView didTouchColumn:(uint8_t)column;
@end

@interface COFBoardView : UIView {
    
}
@property (nonatomic, assign) id <COFBoardViewDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame;

@end
