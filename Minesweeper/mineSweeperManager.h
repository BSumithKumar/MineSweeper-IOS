//
//  mineSweeperManager.h
//  Minesweeper
//
//  Created by Sumith Kumar on 11/11/16.
//  Copyright © 2016 codechallenge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MineSweeperCell.h"

typedef enum : NSUInteger {
    EMineSweeperMedium,
    EMineSweeperSmall,
    EMineSweeperBig,
} EMineSweeperType;



@interface mineSweeperManager : NSObject

// singleton
+(instancetype) getInstance;

#pragma Mark create/save/reset board
// creates new board
-(void) createNewBoard:(EMineSweeperType) aMSType
withCompletionCallback: (void (^)(Boolean aSuccess, NSArray* aBoardCells)) aCompletionCallback;

// check for previous saved board
-(Boolean) isThereAnySavedBoard;

// creates board from previously saved board
-(void) createBoardFromSaved : (void (^)(Boolean aSuccess, NSArray* aBoardCells)) aCompleteionCallback;

// resets current board
-(void) resetBoard: (void (^)(Boolean aSuccess)) aCompletionCallback;

// saves current board
-(void) saveBorad: (void (^)(Boolean aSuccess)) aCompleteionCallback;


#pragma mark functions on board

// verify the cell that is selected
// if the cell has mine, returns error and cellsToOpen contains all cells with mine
// if the cell has none, returns no error and cellsToOpen contains all the neighbouring cells till non zero cells
// if the cell has countOfMines, returns no error and cellsToOpen contains that particular cell only
-(void) verifyCellSelect : (int) aCellRow withCellColumn : (int) aCellColumn
           withCallback : (void (^)(NSError* aError, NSArray* aCellsToOpen)) aCompletionCallback;


-(void) flagCellWithRow : (NSInteger) aCellRow Column : (NSInteger) aCellCol flagState:(BOOL) aState;

// get the number of rows
-(NSInteger) getNumberOfRows;

// get the number of columns
-(NSInteger) getNumberOfColumns;

// returns the number of mines
-(NSInteger) getNumberOfMines;

// returns the number of flags
-(NSInteger) getNumberOfFlagedCells;

@end
