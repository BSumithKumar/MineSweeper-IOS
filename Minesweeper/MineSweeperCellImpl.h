//
//  MineSweeperCellImpl.h
//  Minesweeper
//
//  Created by Sumith Kumar on 11/12/16.
//  Copyright © 2016 codechallenge. All rights reserved.
//

#import "MineSweeperCell.h"

@interface MineSweeperCellImpl : MineSweeperCell

@property(nonatomic, assign) BOOL openState;
@property(nonatomic, assign) BOOL flagState;
@property(nonatomic, assign) BOOL containingMine;
@property(nonatomic, assign) NSInteger neighbourMinesCount;

-(id) initWithNeighboureMineCount: (NSInteger) aMineCount;

@end
