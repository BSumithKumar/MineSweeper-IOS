//
//  MineSweeperBoard.h
//  Minesweeper
//
//  Created by Sumith Kumar on 11/11/16.
//  Copyright © 2016 codechallenge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MineSweeperCell.h"

static const NSInteger CELL_WITH_MINE_VAL = -1;
static const NSInteger CELL_WITH_EMPTY = 0;



@interface MineSweeperBoard : NSObject

-(id) initWithRows: (NSInteger) aNoOfRows
    withNumColumns: (NSInteger) aNoofCols
     withNumMines : (NSInteger) aNoOfMines;


-(NSInteger) getNumberOfRows;
-(NSInteger) getNumberOfColumns;

-(NSArray*) getBoardCells;

-(MineSweeperCell*) getCellValue : (NSInteger) aCellRow Column : (NSInteger) aColumn;

-(NSArray*) getNeighbourCellsToReveal : (NSInteger) aCellRow column: (NSInteger) aCellCol;


@end
