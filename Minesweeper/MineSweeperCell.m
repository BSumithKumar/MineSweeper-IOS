//
//  MineSweeperCell.m
//  Minesweeper
//
//  Created by Sumith Kumar on 11/12/16.
//  Copyright © 2016 codechallenge. All rights reserved.
//

#import "MineSweeperCell.h"

@implementation MineSweeperCell
-(id) init{
   // @throw [[NSException alloc] initWithName:@"Not supported" reason:@"Use implementation" userInfo:nil];
    self = [super init];
    return self;
}

-(BOOL) isOpened{
    return NO;
}

-(BOOL) isMine{
    return NO;
}

-(NSInteger) numberOfNeighbouringMines{
    return 0;
}

-(BOOL) isFlagged{
    return NO;
}


@end
