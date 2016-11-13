//
//  MineSweeperCellImpl.m
//  Minesweeper
//
//  Created by Sumith Kumar on 11/12/16.
//  Copyright © 2016 codechallenge. All rights reserved.
//

#import "MineSweeperCellImpl.h"

@implementation MineSweeperCellImpl

-(id) initWithNeighboureMineCount: (NSInteger) aMineCount{
    self = [super init];
    if( self ){
        self.neighbourMinesCount = aMineCount;
        if(aMineCount == -1){
            self.containingMine = YES;
       }
        self.openState = NO;
        self.flagState = NO;
    }
    return self;
}

-(BOOL) isOpened{
    return self.openState;
}

-(BOOL) isMine{
    return self.containingMine;
}

-(NSInteger) numberOfNeighbouringMines{
    return self.neighbourMinesCount;
}

-(BOOL) isFlagged{
    return self.flagState;
}


@end
