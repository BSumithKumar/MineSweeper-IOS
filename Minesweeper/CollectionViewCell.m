//
//  CollectionViewCell.m
//  Minesweeper
//
//  Created by Sumith Kumar on 11/12/16.
//  Copyright © 2016 codechallenge. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
- (IBAction)onCellSelect:(id)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(onCollectionViewSelected:Column:)]){
        [self.delegate onCollectionViewSelected:self.rowNum Column:self.colNum];
    }
}

@end
