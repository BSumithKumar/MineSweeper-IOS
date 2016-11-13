//
//  CollectionViewCell.m
//  Minesweeper
//
//  Created by Sumith Kumar on 11/12/16.
//  Copyright © 2016 codechallenge. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

-(void) awakeFromNib{
    [super awakeFromNib];
    [self addButtonGesture];
    
}

-(void) addButtonGesture{

    [self.collectionButton setEnabled:YES];
    
    [self.collectionButton addTarget:self action:@selector(onCellSelect:) forControlEvents:UIControlEventTouchUpInside];

    UILongPressGestureRecognizer* gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    gesture.minimumPressDuration = 1;
    [self.collectionButton addGestureRecognizer:gesture];
}

-(void)onLongPress:(UILongPressGestureRecognizer *)gestureRecognizer    {

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan://long press start
        {
            NSLog(@"UIGestureRecognizerStateBegan");
            if(self.delegate && [self.delegate respondsToSelector:@selector(onCollectionViewLongPress:Column:)]){
                [self.delegate onCollectionViewLongPress:self.rowNum Column:self.colNum];
            }
        }
            break;
        case UIGestureRecognizerStateEnded://long press end
        {
            NSLog(@"UIGestureRecognizerStateEnded");
       }
            break;
        default:
            break;
    }
    
    
}

- (void)onCellSelect:(id)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(onCollectionViewSelected:Column:)]){
        [self.delegate onCollectionViewSelected:self.rowNum Column:self.colNum];
    }
}

@end
