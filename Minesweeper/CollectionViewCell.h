//
//  CollectionViewCell.h
//  Minesweeper
//
//  Created by Sumith Kumar on 11/12/16.
//  Copyright © 2016 codechallenge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionViewDelegate <NSObject>

-(void) onCollectionViewSelected:(NSInteger) rowNum Column: (NSInteger) colNum;

@end

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<CollectionViewDelegate> delegate;
@property (nonatomic, assign) NSInteger rowNum;
@property (nonatomic, assign) NSInteger colNum;
@property (nonatomic, weak) IBOutlet UIButton* collectionButton;

@end
