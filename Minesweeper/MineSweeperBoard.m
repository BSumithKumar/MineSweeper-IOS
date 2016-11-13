//
//  MineSweeperBoard.m
//  Minesweeper
//
//  Created by Sumith Kumar on 11/11/16.
//  Copyright © 2016 codechallenge. All rights reserved.
//

#import "MineSweeperBoard.h"
#include <stdlib.h>
#include "MineSweeperCellImpl.h"

static const NSInteger KDEFAULT_NUM_ROWS = 4;
static const NSInteger KDEFAULT_NUM_COLUMNS = 5;
static const NSInteger KDEFAULT_NUM_MINES = 5;



@interface MineSweeperBoard()

@property(nonatomic, assign) NSInteger numRows;
@property(nonatomic, assign) NSInteger numColumns;
@property(nonatomic, assign) NSInteger numMinesPlaced;
@property(nonatomic, strong) NSArray* cells;
@property(nonatomic, strong) NSArray* cellIndexWithMines;

@end


@implementation MineSweeperBoard



-(id) init{
    self = [super init];
    if( self ){
        self.numRows = KDEFAULT_NUM_ROWS;
        self.numColumns = KDEFAULT_NUM_COLUMNS;
        self.numMinesPlaced = KDEFAULT_NUM_MINES;
        [self createBoard];
    }
    return self;
}


-(void) createBoard {
    
    NSMutableArray* lCells = [[NSMutableArray alloc] init];
    
    NSArray* minesList = [self getListOfMinesIndex];
    
    
    for(int i = 0; i < _numRows; i++){
        
        NSMutableArray* cols = [[NSMutableArray alloc] init];
        [lCells addObject:cols];
        for (int j = 0; j < _numColumns; j++) {
            MineSweeperCellImpl* cell = [[MineSweeperCellImpl alloc] initWithNeighboureMineCount:CELL_WITH_EMPTY];
            [cols addObject:cell];
        }
    }
    
    for (NSNumber* num in minesList) {
        NSInteger cellRow = num.integerValue / _numColumns;
        NSInteger cellCol = num.integerValue % _numColumns;
        
        NSMutableArray* col = [lCells objectAtIndex:cellRow];
        MineSweeperCellImpl* lCell = [[MineSweeperCellImpl alloc] initWithNeighboureMineCount:CELL_WITH_MINE_VAL];
        [col setObject:lCell atIndexedSubscript:cellCol];
        // increase the mine count of neighbouring cells if they are not mine
        
        for(NSInteger i = -1; i < 2; i++){
            NSInteger lNeighCellRow = cellRow + i;
            if( lNeighCellRow < 0 || lNeighCellRow == _numRows ){
                continue;
            }
            NSMutableArray* row = [lCells objectAtIndex:lNeighCellRow];
            for (NSInteger j = -1; j < 2; j++) {
                NSInteger lNeighCellCol = cellCol + j;
                if(lNeighCellCol < 0 || lNeighCellCol == _numColumns){
                    continue;
                }
                if (lNeighCellCol == cellCol && lNeighCellRow == cellRow){
                    continue;
                }
                MineSweeperCellImpl* cell = [row objectAtIndex:lNeighCellCol];
                if (![cell isMine]){
                    MineSweeperCellImpl * nCell = [[MineSweeperCellImpl alloc] initWithNeighboureMineCount:cell.numberOfNeighbouringMines+1];
                    [row setObject:nCell atIndexedSubscript:lNeighCellCol];
                    
                }

            }
        }
        
        
    }
    self.cells = lCells;
    self.cellIndexWithMines = minesList;
}


-(NSInteger) getNumberOfRows{
    return _numRows;
}

-(NSInteger) getNumberOfColumns;{
    return _numColumns;
}

-(NSArray*) getBoardCells{
    return self.cells;
}


-(NSArray*) getListOfMinesIndex{
    
    
    NSMutableDictionary* generatedRandNums = [[NSMutableDictionary alloc] initWithCapacity:_numMinesPlaced];
    NSMutableArray* minesList = [[NSMutableArray alloc] init];
    NSInteger i = 0;
    while (i < _numMinesPlaced) {
        int rand = arc4random_uniform(self.numRows*self.numColumns);
        NSString* randNumS = [NSString stringWithFormat:@"%d",rand];
        if ([generatedRandNums valueForKey:randNumS]){
            continue;
        }
        i ++;
        [minesList addObject:[NSNumber numberWithInt:rand]];
        [generatedRandNums setValue:[[NSObject alloc] init] forKey:randNumS];
    }
    
    return minesList;
    
    
    
}

-(id) initWithRows: (NSInteger) aNoOfRows
         withNumColumns: (NSInteger) aNoofCols
          withNumMines : (NSInteger) aNoOfMines{
    self = [super init];
    if( self ){
        self.numColumns = aNoofCols;
        self.numRows = aNoOfRows;
        self.numMinesPlaced = aNoOfMines;
        [self createBoard];
    }
    return self;
}


-(MineSweeperCell*) getCellValue : (NSInteger) aCellRow Column : (NSInteger) aColumn{
    if( aCellRow < 0 || aCellRow > _numRows
       || aColumn < 0 || aColumn > _numColumns){
        @throw [NSException exceptionWithName:@"Invalid Argument" reason:@"Not valid argument" userInfo:nil];
    }
    
    NSMutableArray* row = [self.cells objectAtIndex:aCellRow];
    
    MineSweeperCellImpl* cellVal = [row objectAtIndex:aColumn];
    
    return cellVal;
    
}

-(NSArray*) getNeighbourCellsToReveal : (NSInteger) aCellRow column: (NSInteger) aCellCol{
    
    if( aCellRow < 0 || aCellRow > _numRows
       || aCellCol < 0 || aCellCol > _numColumns){
        @throw [NSException exceptionWithName:@"Invalid Argument" reason:@"Not valid argument" userInfo:nil];
    }

    
    
    // check the number of mines
    MineSweeperCellImpl* cellVal = [self getCellValue:aCellRow Column:aCellCol];
    
    if( cellVal.isMine ){
        return self.cellIndexWithMines;
    }
    
    NSMutableArray* cellsToReveal = [[NSMutableArray alloc] init];
    if( cellVal.neighbourMinesCount == CELL_WITH_EMPTY && !cellVal.isOpened){
        NSInteger ind = aCellRow * _numColumns + aCellCol;

        [cellsToReveal addObject:[NSNumber numberWithInteger:ind]];
        
        NSMutableDictionary* cellMap = [[NSMutableDictionary alloc] init];
        [self cellsToRevealWithRow:aCellRow
                            Column:aCellCol
               withArrayToBeFilled: cellsToReveal
         withCellMapRevealed:cellMap];
        [cellMap removeAllObjects];
        return cellsToReveal;
    }

    [cellsToReveal addObject: [NSNumber numberWithInt:aCellRow*_numColumns + aCellCol]];
    return cellsToReveal;
    
}

-(void) cellsToRevealWithRow : (NSInteger) aRowInd Column : (NSInteger) aColInd
          withArrayToBeFilled: (NSMutableArray*) aArray
          withCellMapRevealed: (NSMutableDictionary*) aMap{
    
    
    for(NSInteger i = -1; i < 2; i++){
        NSInteger lNeighCellRow = aRowInd + i;
        if( lNeighCellRow < 0 || lNeighCellRow == _numRows ){
            continue;
        }
        NSMutableArray* row = [self.cells objectAtIndex:lNeighCellRow];
        for (NSInteger j = -1; j < 2; j++) {
            NSInteger lNeighCellCol = aColInd + j;
            if(lNeighCellCol < 0 || lNeighCellCol == _numColumns){
                continue;
            }
            if (lNeighCellCol == aColInd && lNeighCellRow == aRowInd){
                continue;
            }
            MineSweeperCellImpl* num = [row objectAtIndex:lNeighCellCol];
            if (num.isMine){
                continue;
                
            }
            
            NSInteger ind = lNeighCellRow * _numColumns + lNeighCellCol;
            NSString* lIndStr = [NSString stringWithFormat:@"%d", ind];
            if ([aMap objectForKey:lIndStr]){
                continue;
            }
            
            [aArray addObject:[NSNumber numberWithInt:ind]];
            [aMap setObject:[NSObject new] forKey:lIndStr];
            
            if (num.neighbourMinesCount == CELL_WITH_EMPTY && !num.isOpened){
                
                [self cellsToRevealWithRow:lNeighCellRow Column:lNeighCellCol withArrayToBeFilled:aArray withCellMapRevealed:aMap];
            }
            
        }
    }

    
}

@end
