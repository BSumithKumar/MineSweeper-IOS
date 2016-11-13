//
//  ViewController.m
//  Minesweeper
//
//  Created by Sumith Kumar on 11/11/16.
//  Copyright © 2016 codechallenge. All rights reserved.
//

#import "ViewController.h"
#import "mineSweeperManager.h"
#import "CollectionViewCell.h"
#import "MineSweeperCellImpl.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) mineSweeperManager* sweeperManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property(nonatomic, weak) NSArray* sweeperCells;

@property(nonatomic, assign) CGFloat cellWidth;
@property(nonatomic, assign) CGFloat cellHeight;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UILabel *minesCount;

@property(nonatomic, strong) UIImage* mineImage;
@property(nonatomic, strong) UIImage* flagImage;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    _sweeperManager = [mineSweeperManager getInstance];
    
    [_sweeperManager createNewBoard:EMineSweeperMedium withCompletionCallback:^(Boolean aSuccess, NSArray *aBoardCells) {
        self.sweeperCells = aBoardCells;
        
        NSInteger numColumns = self.sweeperManager.getNumberOfColumns;
        
        _cellWidth = 30;
        _collectionViewWidthConstraint.constant  = _cellWidth * numColumns ;
        
        _cellHeight = 30;
        _collectionViewHeightConstraint.constant = _cellHeight* self.sweeperManager.getNumberOfRows;
        
        [self.minesCount setText:[NSString stringWithFormat:@"%02d",(_sweeperManager.getNumberOfMines - _sweeperManager.getNumberOfFlagedCells)]];
    }];
    
    [self.segmentControl setSelectedSegmentIndex:1];
    [self.segmentControl addTarget:self action:@selector(onClickSegmentControl:) forControlEvents:UIControlEventValueChanged];
    
    self.flagImage = [UIImage imageNamed:@"flag"];
    
    
    
}

- (IBAction)onClickSegmentControl:(id)sender {
    
    UISegmentedControl* sgControl = (UISegmentedControl*) sender;
    
    NSInteger sgInd = [sgControl selectedSegmentIndex];
    
    
    EMineSweeperType mineType;
    if( sgInd == 0){
        mineType = EMineSweeperSmall;
    }else if (sgInd == 1){
        mineType = EMineSweeperMedium;
    }else{
        mineType = EMineSweeperBig;
    }
    
    [_sweeperManager resetBoard:^(Boolean aSuccess) {
        [_sweeperManager createNewBoard:mineType withCompletionCallback:^(Boolean aSuccess, NSArray *aBoardCells) {
            self.sweeperCells = aBoardCells;
            
            NSInteger numColumns = self.sweeperManager.getNumberOfColumns;
            
            _cellWidth = 30;
            _collectionViewWidthConstraint.constant  = _cellWidth * numColumns ;
            
            _cellHeight = 30;
            _collectionViewHeightConstraint.constant = _cellHeight* self.sweeperManager.getNumberOfRows;
            [self.minesCount setText:[NSString stringWithFormat:@"%2d",[_sweeperManager getNumberOfMines]]];

            [_collectionView reloadData];
        }];
        
    }];
    

    
}



-(void)viewDidLayoutSubviews{
    NSInteger numColumns = self.sweeperManager.getNumberOfColumns;
    
    
    _cellWidth = 30;
    _collectionViewWidthConstraint.constant  = _cellWidth * numColumns ;
    
    _cellHeight = 30;
    _collectionViewHeightConstraint.constant = _cellHeight* self.sweeperManager.getNumberOfRows;
    
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    //NSLog(@"%d", indexPath.row);
    
    NSInteger rowNum = indexPath.section;
    
    NSMutableArray* row = [self.sweeperCells objectAtIndex:rowNum];
    
    NSInteger colNum = indexPath.row;
    
    MineSweeperCell* cellVal = [row objectAtIndex:colNum];
    
    CollectionViewCell* cell =(CollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    cell.rowNum = rowNum;
    cell.colNum = colNum;
    cell.delegate = self;
    [cell.collectionButton setTitle:@"" forState:UIControlStateNormal];
    [cell.collectionButton setImage:nil forState:UIControlStateNormal];
    if (!cellVal.isOpened) {
        if (cellVal.isFlagged) {
            [cell.collectionButton setBackgroundImage:self.flagImage forState:UIControlStateNormal];
        }
        [cell.collectionButton setBackgroundColor:[UIColor grayColor]];
        [cell.collectionButton setEnabled:YES];
    }else{
        if (cellVal.isMine) {
            UIImage* mineImage = [UIImage imageNamed:@"mineImage"];
            [cell.collectionButton setImage:mineImage forState:UIControlStateNormal];
            [cell.collectionButton setBackgroundColor:[UIColor redColor]];
        }else{
            if( cellVal.numberOfNeighbouringMines == 0 ){
                [cell.collectionButton setTitle:@"" forState:UIControlStateNormal];
                
            }else{
                NSString* text = [NSString stringWithFormat:@"%d",[cellVal numberOfNeighbouringMines] ];
                [cell.collectionButton setTitle:text forState:UIControlStateNormal];
                UIColor* textCol;
                switch (cellVal.numberOfNeighbouringMines) {
                    case 1:
                        textCol = [UIColor blueColor];
                        break;
                    case 2:
                        textCol = [UIColor greenColor];
                        break;
                    case 3:
                        textCol = [UIColor redColor];
                        break;
                    default:
                        textCol = [UIColor blackColor];
                        break;
                }
                
                [cell.collectionButton setTitleColor:textCol forState:UIControlStateNormal];
            }
            [cell.collectionButton setBackgroundColor:[UIColor lightGrayColor]];
            
        }
        [cell.collectionButton setEnabled:NO];
        
    }
    //cell.backgroundColor = [UIColor colorWithRed:10 green:255 blue:10 alpha:1.0];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (!self.sweeperCells) {
        return 1;
    }
    return self.sweeperManager.getNumberOfRows;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!self.sweeperCells) {
        return 0;
    }
    
    return self.sweeperManager.getNumberOfColumns;
}

-(void)onCollectionViewLongPress:(NSInteger)rowNum Column:(NSInteger)colNum{
    
    NSArray* row = [_sweeperCells objectAtIndex:rowNum];
    
    MineSweeperCell* cellValue = [row objectAtIndex:colNum];
    
    
    [self.sweeperManager flagCellWithRow:rowNum Column:colNum flagState:!cellValue.isFlagged];
    [self.minesCount setText:[NSString stringWithFormat:@"%02d",(_sweeperManager.getNumberOfMines - _sweeperManager.getNumberOfFlagedCells)]];
    
    NSIndexPath* indPath = [NSIndexPath indexPathForRow:colNum inSection:rowNum];
    
    [self.collectionView reloadItemsAtIndexPaths:@[indPath]];

}

-(void) onCollectionViewSelected:(NSInteger)rowNum Column:(NSInteger)colNum{
    
    [self.sweeperManager verifyCellSelect:rowNum withCellColumn:colNum withCallback:^(NSError *aError, NSArray *aCellsToOpen) {
        if( aError ){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Game Over" message:@"Mine clicked.\n You lost!!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self changeTheCellsOpenState:aCellsToOpen];
                //[self.collectionView reloadData];
            }];
            [alert addAction:action];
            [self showViewController:alert sender:self];
            
            
        }else{
            [self changeTheCellsOpenState:aCellsToOpen];
            //[self.collectionView reloadData];
        }
    }];
    
}


-(void) changeTheCellsOpenState : (NSArray*) aCellsToOpen{
    NSMutableArray* indArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < aCellsToOpen.count; i++) {
        NSNumber* num = [aCellsToOpen objectAtIndex:i];
        
        NSInteger rowNum = num.integerValue / self.sweeperManager.getNumberOfColumns;
        NSInteger colNum = num.integerValue % self.sweeperManager.getNumberOfColumns;
        
        NSArray* row = [self.sweeperCells objectAtIndex:rowNum];
        MineSweeperCellImpl* cellVal = [row objectAtIndex:colNum];
        if (!cellVal.isOpened) {
            [cellVal setOpenState:YES];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:colNum inSection:rowNum];
            [indArr addObject:indexPath];
        }
        
    }
    //[self.collectionView reloadData];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadItemsAtIndexPaths:indArr];
    } completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.section;
    NSInteger col = indexPath.row;
    
//    [self.sweeperManager verifyCellSelect:row withCellColumn:col withCallback:^(NSError *aError, NSArray *aCellsToOpen) {
//        if( aError ){
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Lost!" message:@"Mine clicked" preferredStyle:UIAlertControllerStyleAlert];
//            [self showViewController:alert sender:self];
//        }
//    }];
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(_cellWidth, _cellHeight);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
