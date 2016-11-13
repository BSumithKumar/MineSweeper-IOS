//
//  mineSweeperManager.m
//  Minesweeper
//
//  Created by Sumith Kumar on 11/11/16.
//  Copyright © 2016 codechallenge. All rights reserved.
//

#import "mineSweeperManager.h"
#import "MineSweeperBoard.h"

@interface mineSweeperManager ()

@property (nonatomic, strong) MineSweeperBoard* msBoard;

@end


@implementation mineSweeperManager


static mineSweeperManager* instance = nil;

#pragma mark - singleton functions

+(instancetype) getInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[mineSweeperManager alloc] init];
    });
    
    return instance;
}


-(id) init{
    
    self = [super init];
    
    if( self ){
        //self.msBoard = [[MineSweeperBoard alloc] init];
    }
    
    return self;
}



#pragma mark - create/save/reset board
-(void) createNewBoard:(EMineSweeperType) aMSType
withCompletionCallback: (void (^)(Boolean aSuccess, NSArray* aBoardCells)) aCompletionCallback{
    
    if (!self.msBoard) {
        
        NSInteger rows = 0;
        NSInteger cols = 0;
        NSInteger mines = 0;
        if (aMSType == EMineSweeperBig) {
            rows = 15;
            cols = 12;
            mines = 30;
        }else if (aMSType == EMineSweeperMedium){
            rows = 8;
            cols = 9;
            mines = 15;
        }else {
            rows = 5;
            cols = 7;
            mines = 6;
        }
        
        self.msBoard = [[MineSweeperBoard alloc] initWithRows:rows withNumColumns:cols withNumMines:mines];
    }
    

    if (aCompletionCallback) {
        aCompletionCallback(YES, [self.msBoard getBoardCells]);
    }
    
}

-(Boolean) isThereAnySavedBoard{
    return NO;
}

-(void) createBoardFromSaved : (void (^)(Boolean aSuccess, NSArray* aBoardCells)) aCompleteionCallback{
    
}

-(void) resetBoard: (void (^)(Boolean aSuccess)) aCompletionCallback{
    
    self.msBoard = nil;
    
    if (aCompletionCallback) {
        aCompletionCallback(YES);
    }
    
}

-(void) saveBorad: (void (^)(Boolean aSuccess)) aCompleteionCallback{
    
}


#pragma mark functions on board

// verify the cell that is selected
// if the cell has mine, returns error and cellsToOpen contains all cells with mine
// if the cell has none, returns no error and cellsToOpen contains all the neighbouring cells till non zero cells
// if the cell has countOfMines, returns no error and cellsToOpen contains that particular cell only
-(void) verifyCellSelect : (int) aCellRow withCellColumn : (int) aCellColumn
            withCallback : (void (^)(NSError* aError, NSArray* aCellsToOpen)) aCompletionCallback{
    
    if (!aCompletionCallback){
        return;
    }
    
    if(!self.msBoard){
        aCompletionCallback(nil, nil);
        return;
    }
    
    MineSweeperCell* cellVal = [self.msBoard getCellValue:aCellRow Column:aCellColumn];
    if( cellVal.isMine ){
        NSError* lError = [NSError errorWithDomain:@"com.minesweeper" code:1101 userInfo:nil];
        NSArray* cellsWithMines = [self.msBoard getNeighbourCellsToReveal:aCellRow column:aCellColumn];
        aCompletionCallback(lError, cellsWithMines);
        return;
    }
    NSArray* cellsToOpen = [self.msBoard getNeighbourCellsToReveal:aCellRow column:aCellColumn];
    aCompletionCallback(nil, cellsToOpen);
    return;
}

-(void) flagCellWithRow : (NSInteger) aCellRow Column : (NSInteger) aCellCol flagState:(BOOL) aState{
    if (self.msBoard) {
        [self.msBoard flagCellWithRow:aCellRow Column:aCellCol flagState:aState];
    }
}


// get the number of rows
-(NSInteger) getNumberOfRows{
    return [self.msBoard getNumberOfRows];
}

// get the number of columns
-(NSInteger) getNumberOfColumns{
    return [self.msBoard getNumberOfColumns];
}

-(NSInteger) getNumberOfMines{
    return [self.msBoard getNumberOfMines];
}
// returns the number of flags
-(NSInteger) getNumberOfFlagedCells{
    return [self.msBoard getNumberOfFlags];
}


@end
