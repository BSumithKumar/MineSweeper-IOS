//
//  MineSweeperCell.h
//  Minesweeper
//
//  Created by Sumith Kumar on 11/12/16.
//  Copyright © 2016 codechallenge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineSweeperCell : NSObject


-(BOOL) isOpened;

-(BOOL) isMine;

-(NSInteger) numberOfNeighbouringMines;

-(BOOL) isFlagged;


@end
