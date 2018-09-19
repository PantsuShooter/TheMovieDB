//
//  DetailedTableViewController.m
//  TheMovieDB
//
//  Created by Цындрин Антон on 15.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import "DetailedTableViewController.h"
#import "ProgressLabel.h"
#import "ServerManager.h"
#import "FavoriteManager.h"
#import "GenresCollectionViewCell.h"
#import "TopBilledCastCollectionViewCell.h"
#import "VideoCollectionViewCell.h"
#import "DetailMovieModel.h"
#import "MovieContentModel.h"


#import "MoveCreditsModel.h"
#import "MovieVideosModel.h"


#import <RMPickerViewController/RMPickerViewController.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <youtube-ios-player-helper/YTPlayerView.h>

#define BASE_IMAGE_URL           @"https://image.tmdb.org/t/p"


@interface DetailedTableViewController () <UICollectionViewDataSource,UICollectionViewDelegate>


@property (strong,nonatomic)MoveCreditsModel        *moveCreditsModel;
@property (strong,nonatomic)DetailMovieModel        *detailMovieModel;
@property (strong,nonatomic)MovieVideosModel        *movieVideosModel;
@property (strong,nonatomic)NSString                 *language;
@property (strong,nonatomic)NSMutableArray          *creditsDetailsArray;

@property (weak, nonatomic) IBOutlet ProgressLabel *ratingProgressLable;

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *runtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *releaseInformationNationalFlagImageView;
@property (weak, nonatomic) IBOutlet UILabel *releaseInformationDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *revenueLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *genresCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *topBilledCastCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *videoCollectionView;



@end

@implementation DetailedTableViewController


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self sutupData];
    [self setupUI];
    [self creditsDetailsRequested];
    [self movieVideosDetailsRequested];
}

#pragma mark - Setup's

- (void)sutupData {
    
    [self favoritesButtonSetup];
    
    self.moveCreditsModel = [[MoveCreditsModel alloc] init];
    self.language = [NSString stringWithFormat:@"en-US"];
    self.genresCollectionView.delegate = self;
    self.genresCollectionView.dataSource = self;
    
    self.topBilledCastCollectionView.delegate = self;
    self.topBilledCastCollectionView.dataSource = self;
    
    self.videoCollectionView.delegate = self;
    self.videoCollectionView.dataSource = self;

    self.tableView.allowsSelection = NO;
}

- (void)favoritesButtonSetup {
    
    UIImage *background = [UIImage imageNamed:@"starBarButton"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(favoritesBarButtonAction) forControlEvents:UIControlEventTouchUpInside]; //adding action
    [button setBackgroundImage:background forState:UIControlStateNormal];
   
    button.frame = CGRectMake(0 ,0,35,35);
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}


- (void)setupUI{
    
// Poster
    NSString *posterString = [NSString stringWithFormat:@"%@/w500%@",BASE_IMAGE_URL,self.detailMovieModel.posterPath];
    NSURL * posterURL = [NSURL URLWithString:posterString];
    [self.posterImageView sd_setImageWithURL:posterURL placeholderImage:[UIImage imageNamed:@"PosterPlaceholder"]];
    
// Title
    self.titleLabel.text = self.detailMovieModel.title;
    
// Rating
    self.ratingProgressLable.fillColor      = [UIColor blackColor];
    self.ratingProgressLable.trackColor     = [UIColor redColor];
    self.ratingProgressLable.progressColor  = [UIColor greenColor];
    self.ratingProgressLable.textColor      = [UIColor whiteColor];
        
    CGFloat ratingFlot = self.detailMovieModel.voteAverage;
    NSString *ratingProgressString = [NSString stringWithFormat:@"%.1f",ratingFlot];
    self.ratingProgressLable.text = ratingProgressString;
    
    CGFloat ratingProgressFloatProgress = ratingFlot / 10;
    self.ratingProgressLable.progress = ratingProgressFloatProgress;
    
// Status
    self.statusLabel.text = self.detailMovieModel.status;
    
// Runtime
    int minutes = (self.detailMovieModel.runtime % 60);
    int hours = (self.detailMovieModel.runtime % 3600) / 60;
    self.runtimeLabel.text = [NSString stringWithFormat:@"%dh %dm",hours,minutes];
    
// OriginalTitle
    self.originalTitleLabel.text = self.detailMovieModel.originalTitle;
    
// Budget
    self.budgetLabel.text = [NSString stringWithFormat:@"$%ld",(long)self.detailMovieModel.budget];
    
// Revenue
    self.revenueLabel.text = [NSString stringWithFormat:@"$%ld",(long)self.detailMovieModel.revenue];
    
//ReleaseInformationData
    self.releaseInformationDataLabel.text = self.detailMovieModel.releaseDate;
    
//ReleaseInformationNationalFlag
    NSString *flagISO = [NSString stringWithFormat:@"%@",[self.detailMovieModel.productionCountries valueForKey:@"iso_3166_1"]];
    
    NSString *CS = [[flagISO componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet letterCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];
    NSString *CSLowercase = [CS lowercaseString];
    self.releaseInformationNationalFlagImageView.image = [UIImage imageNamed:CSLowercase];
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

#pragma mark - Action's

- (void)favoritesBarButtonAction {
    
    NSLog(@"favoritesBarButtonAction");
    
    [[FavoriteManager favoriteManager] addToFavoriteSelectedModel:self.detailMovieModel andSelectedMoveCreditsModel:self.moveCreditsModel];
}

#pragma mark - Configure Model's

- (void)configureDetailMovieModel:(DetailMovieModel *)detailMovieModel{
    
    self.detailMovieModel = detailMovieModel;
}

- (void)configureDetailMovieModel:(DetailMovieModel *)detailMovieModel andMoveCreditsModel:(MoveCreditsModel *)moveCreditsModel{
    
    self.detailMovieModel = detailMovieModel;
    self.moveCreditsModel = moveCreditsModel;
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if ([collectionView isEqual:self.genresCollectionView]) {
        GenresCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"genresCell" forIndexPath:indexPath];
        
        NSArray *array  =  [[self.detailMovieModel.genres valueForKey:@"name"] allObjects];
        
        NSString *genres = [array objectAtIndex:indexPath.row];

        cell.genresLabel.text = genres;
        
        return cell;
        
    }else if ([collectionView isEqual:self.topBilledCastCollectionView]){
        
        TopBilledCastCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topBilledCell" forIndexPath:indexPath];
        
        
        NSString *name = [[self.moveCreditsModel.cast valueForKey:@"name"] objectAtIndex:indexPath.row];
        
        cell.nameLabel.text = name;
        
        NSString *character = [[self.moveCreditsModel.cast valueForKey:@"character"] objectAtIndex:indexPath.row];

        cell.characterLabel.text = character;
        
        NSString *profilePath = [[self.moveCreditsModel.cast valueForKey:@"profile_path"] objectAtIndex:indexPath.row];
        
        if (![profilePath isEqual:[NSNull null]]) {
            NSString *posterString = [NSString stringWithFormat:@"%@/w276_and_h350_face%@",BASE_IMAGE_URL,profilePath];
            NSURL * posterURL = [NSURL URLWithString:posterString];
            [cell.castPosterImageView sd_setImageWithURL:posterURL placeholderImage:[UIImage imageNamed:@"PosterPlaceholder"]];
        }else
        
            cell.castPosterImageView.image = [UIImage imageNamed:@"noimage"];
        
        return cell;
        
    }else if ([collectionView isEqual:self.videoCollectionView]){
        
        VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
        
        NSString *key = [[self.movieVideosModel.results objectAtIndex:indexPath.row] valueForKey:@"key"];
        
        [cell.videoView loadWithVideoId:key];
        
        return cell;

    }
    
    return nil;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([collectionView isEqual:self.genresCollectionView]) {
        
        
        return [self.detailMovieModel.genres count];
        
    } else if ([collectionView isEqual:self.topBilledCastCollectionView]) {
        
    
        return [self.moveCreditsModel.cast count];
    }else if ([collectionView isEqual:self.videoCollectionView]){
        
        
        
        return [self.movieVideosModel.results count];
    }
    
    return 0;
}

#pragma mark - Request's

- (void)movieVideosDetailsRequested {
    
    [[ServerManager sharedManager] getMovieVideosDetailsUsingMovieId:self.detailMovieModel.moveId
                                                 andSortedByLanguage:self.language onSuccess:^(NSArray *movieDetails) {
                                                     
                                                     [self makeMovieVideosDetailsArrayFrom:movieDetails];
                                                     
                                                     
                                                 } onFailure:^(NSError *error, NSInteger statusCode) {
                                                 }];
}



- (void)makeMovieVideosDetailsArrayFrom:(NSArray*)arrivingArray{
    
        self.movieVideosModel = [[MovieVideosModel alloc] init];
        
        self.movieVideosModel.moveId =  [[arrivingArray valueForKey:@"id"] integerValue];
        self.movieVideosModel.results= [NSArray arrayWithArray:[arrivingArray valueForKey:@"results"]];
        [self.videoCollectionView reloadData];
}


- (void)creditsDetailsRequested {
    
    [[ServerManager sharedManager] getMovieCreditsDetailsUsingMovieId:self.detailMovieModel.moveId
                                                            onSuccess:^(NSArray *creditsDetails) {
                                                                
                                                                [self makeCreditsDetailsArrayFrom:creditsDetails];
                                                                
                                                            } onFailure:^(NSError *error, NSInteger statusCode) {
                                                                
                                                            }];
}

- (void)makeCreditsDetailsArrayFrom:(NSArray*)arrivingArray{
    
    self.moveCreditsModel.creditsId = [[arrivingArray valueForKey:@"id"] integerValue];
    self.moveCreditsModel.cast = [arrivingArray valueForKey:@"cast"];
    self.moveCreditsModel.crew = [arrivingArray valueForKey:@"crew"];
    
    [self.topBilledCastCollectionView reloadData];
}



@end
