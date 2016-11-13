//
//  MinesweeperTests.m
//  MinesweeperTests
//
//  Created by Sumith Kumar on 11/11/16.
//  Copyright © 2016 codechallenge. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MineSweeperBoard.h"

@interface MinesweeperTests : XCTestCase

@end

@implementation MinesweeperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

-(void)testMineSweeperBoard {
    
    MineSweeperBoard* board = [[MineSweeperBoard alloc] initWithRows:4 withNumColumns:3 withNumMines:4];
    
    NSArray* lBoardCells = [board getBoardCells];
    
    for(int i = 0; i < board.getNumberOfRows; i++){
        NSArray* lRow = [lBoardCells objectAtIndex:i];
        for (int j = 0 ; j < board.getNumberOfColumns; j++) {
            NSNumber* lNum = [lRow objectAtIndex:j];
            NSLog(@"Number at Pos %d % d - %d", i, j, lNum.intValue );
        }
        NSLog(@"\n");
    }
    
    NSArray* inds = [board getNeighbourCellsToReveal:3 column:0];
    
    for (int i = 0; i < inds.count; i++) {
        NSNumber* num = [inds objectAtIndex:i];
        NSLog(@"index - %d", num.intValue);
        NSInteger row = num.intValue / board.getNumberOfColumns;
        NSInteger col = num.intValue % board.getNumberOfColumns;
        NSLog(@"row - %d  col - %d", row, col);
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
