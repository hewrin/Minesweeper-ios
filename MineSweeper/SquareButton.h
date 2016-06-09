//
//  SquareButton.h
//  MineSweeper
//
//  Created by Faris Roslan on 8/06/2016.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareButton : UIButton
@property int adjacentMines;
@property BOOL haveClicked;
@property BOOL hasMine;
@property struct Points {
int y;
int x;
} point;
@end
