//
//  FavoriteCollectionViewController.m
//  TheMovieDB
//
//  Created by Цындрин Антон on 18.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import "FavoriteCollectionViewController.h"
#import "FavoriteManager.h"
#import "PosterCollectionViewCell.h"
#import "MovieContentModel.h"
#import "DetailedTableViewController.h"
#import "DetailMovieModel.h"


#import <SDWebImage/UIImageView+WebCache.h>

#define BASE_IMAGE_URL           @"https://image.tmdb.org/t/p"

@interface FavoriteCollectionViewController ()

@property (strong,nonatomic)NSMutableArray *favoriteCreditsArray;
@property (strong,nonatomic)NSMutableArray *favoriteArray;

@property (strong,nonatomic)DetailMovieModel  *detailMovieModel;
@property (strong,nonatomic)MoveCreditsModel  *moveCreditsModel;

@end

@implementation FavoriteCollectionViewController

static NSString * const reuseIdentifier = @"cell";

#pragma mark - Life cycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.favoriteArray = [[NSMutableArray alloc] init];
    self.favoriteCreditsArray = [[NSMutableArray alloc] init];
    [self.favoriteArray addObjectsFromArray:[[FavoriteManager favoriteManager] getArraryWithFavoriteDetailMovieModel]];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    CGFloat sizeW = self.collectionView.frame.size.width;
//    CGFloat sizeH = self.collectionView.frame.size.height;
//
//    CGFloat cellSizeH = sizeH / 3.65;
//    CGFloat cellSizeW = sizeW / 3;
//    CGFloat inset = 15;
//
//    return CGSizeMake(cellSizeW - inset, cellSizeH - inset);
//}


#pragma mark - Navigation

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.detailMovieModel = [self.favoriteArray objectAtIndex:indexPath.row];
   
    self.moveCreditsModel = [[FavoriteManager favoriteManager] getArraryWithFavoriteMoveCreditsModelUseCreditsId:self.detailMovieModel.moveId];
    
    [self performSegueWithIdentifier:@"fromFavoriteToDetailed" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"fromFavoriteToDetailed"])
    {
        
        DetailedTableViewController  *dtvc = [segue destinationViewController];
        [dtvc configureDetailMovieModel:self.detailMovieModel andMoveCreditsModel:self.moveCreditsModel];
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.favoriteArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PosterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    DetailMovieModel *detailMovieModel = [self.favoriteArray objectAtIndex:indexPath.row];
    
    NSString *posterString = [NSString stringWithFormat:@"%@/w500%@",BASE_IMAGE_URL,detailMovieModel.posterPath];
    NSURL * posterURL = [NSURL URLWithString:posterString];
    
    [cell.PosterImageView sd_setImageWithURL:posterURL];
    
    return cell;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


@end
