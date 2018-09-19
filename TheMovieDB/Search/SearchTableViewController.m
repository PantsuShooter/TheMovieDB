//
//  SearchTableViewController.m
//  TheMovieDB
//
//  Created by Цындрин Антон on 17.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import "SearchTableViewController.h"
#import "ServerManager.h"
#import "MovieContentModel.h"
#import "SearchTableViewCell.h"
#import "DetailMovieModel.h"
#import "DetailedTableViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <UIScrollView+SVInfiniteScrolling.h>
#import <SVProgressHUD.h>


#define BASE_IMAGE_URL           @"https://image.tmdb.org/t/p"

@interface SearchTableViewController () <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property(strong,nonatomic)NSMutableArray        *movieListArray;
@property(strong,nonatomic)NSString              *language;
@property(assign,nonatomic)__block NSInteger       page;

@property(strong,nonatomic)DetailMovieModel      *detailMovieModel;

@end

@implementation SearchTableViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataSetup];
    [self infiniteScrollingSetup];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    self.searchBar.hidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    self.searchBar.hidden = YES;
}

#pragma mark - Setup's

- (void)infiniteScrollingSetup {
    
    self.page = 1;
    self.movieListArray = [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"addInfiniteScrollingWithActionHandler");
        weakSelf.page = weakSelf.page + 1;
        [weakSelf movieContentRequest];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }];
}


- (void)dataSetup{
    
    self.language = [NSString stringWithFormat:@"en-US"];
    
    self.searchBar.delegate = self;
    
    CGFloat topOffset = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.searchBar.frame  = CGRectMake(0, topOffset, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
    
    [self.navigationController.view addSubview:self.searchBar];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieContentModel   *selectedMovieContentModel = [self.movieListArray objectAtIndex:indexPath.row];
    NSInteger moveId = selectedMovieContentModel.moveId;
    [self movieDetailsModelRequestedWithId:moveId];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"fromSearchToDetailed"])
    {
        DetailedTableViewController  *dtvc = [segue destinationViewController];
        
        [dtvc configureDetailMovieModel:self.detailMovieModel];
    }
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [SVProgressHUD dismiss];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.movieListArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    MovieContentModel *model = [self.movieListArray objectAtIndex:indexPath.row];
    
    NSString *posterString = [NSString stringWithFormat:@"%@/w500%@",BASE_IMAGE_URL,model.posterPath];
    NSURL * posterURL = [NSURL URLWithString:posterString];
    [cell.posterImageView sd_setImageWithURL:posterURL placeholderImage:[UIImage imageNamed:@"PosterPlaceholder"]];
    
    cell.titleLabel.text = model.title;
    cell.overviewLabel.text = model.overview;
    cell.releaseLabel.text = model.releaseDate;
    
    cell.ratingProgressLable.fillColor      = [UIColor blackColor];
    cell.ratingProgressLable.trackColor     = [UIColor redColor];
    cell.ratingProgressLable.progressColor  = [UIColor greenColor];
    cell.ratingProgressLable.textColor      = [UIColor whiteColor];
    
    NSNumber *ratingProgressNumber = [NSNumber numberWithDouble:model.voteAverage];
    CGFloat ratingProgressFloat = [ratingProgressNumber floatValue];
    NSString *ratingProgressString = [NSString stringWithFormat:@"%.01f",ratingProgressFloat];
    cell.ratingProgressLable.text   = ratingProgressString;
    
    CGFloat ratingProgressFloatProgress = ratingProgressFloat / 10;
    cell.ratingProgressLable.progress = ratingProgressFloatProgress;
    
    return cell;
}

#pragma mark - Action's

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    self.page = 1;
    [searchBar resignFirstResponder];
    [self.movieListArray removeAllObjects];
    [self movieContentRequest];
}

#pragma mark - Request's

- (void)movieContentRequest {

    [[ServerManager sharedManager] getSearchMoviesSortedByLanguage:self.language
                                                             query:self.searchBar.text andPage:self.page onSuccess:^(NSArray *movieList) {
                                                                 
                                                                 [self makeMovieListArrayFrom:movieList];
                                                                 [self.tableView reloadData];
                                                                 
                                                             } onFailure:^(NSError *error, NSInteger statusCode) {
                                                                 
                                                             }];
}

- (void)makeMovieListArrayFrom:(NSArray*)arrivingArray{
    
    for (int i = 0; i < [arrivingArray count]; i++) {
        
        NSArray *array = [arrivingArray objectAtIndex:i];
        MovieContentModel *model = [[MovieContentModel alloc] init];
        
        NSNumber *voteCountNumber  = [array valueForKey:@"vote_count"];
        model.voteCount = [voteCountNumber doubleValue];
        
        NSNumber *idNumber = [array valueForKey:@"id"];
        model.moveId = [idNumber doubleValue];
        
        NSNumber *voteAverageNumber = [array valueForKey:@"vote_average"];
        model.voteAverage = [voteAverageNumber doubleValue];
        
        NSNumber *popularityNumber = [array valueForKey:@"popularity"];
        model.popularity = [popularityNumber doubleValue];
        
        model.title = [array valueForKey:@"title"];
        model.video = [[array valueForKey:@"video"] boolValue];
        model.posterPath = [array valueForKey:@"poster_path"];
        model.originalLanguage = [array valueForKey:@"original_language"];
        model.originalTitle = [array valueForKey:@"original_title"];
        model.genreIds     =  [array valueForKey:@"genre_ids"];
        model.backdropPath =  [array valueForKey:@"backdrop_path"];
        model.adult        =  [[array valueForKey:@"adult"]boolValue];
        model.overview     =  [array valueForKey:@"overview"];
        model.releaseDate  =  [array valueForKey:@"release_date"];
        
        [self.movieListArray addObject:model];
    }
}


- (void)movieDetailsModelRequestedWithId:(NSInteger)id{
    
    [[ServerManager sharedManager] getMovieDetailsUsingMovieId:id
                                           andSortedByLanguage:self.language
                                                     onSuccess:^(NSArray *movieDetails) {
                                                         
                                                         [self makeMovieDitailArrayFrom:movieDetails];
                                                         
                                                     } onFailure:^(NSError *error, NSInteger statusCode) {
                                                         
                                                         
                                                     }];
}



- (void)makeMovieDitailArrayFrom:(NSArray*)arrivingArray{
    
    self.detailMovieModel = [[DetailMovieModel alloc] init];
    
    self.detailMovieModel.adult = [[arrivingArray valueForKey:@"adult"]boolValue ];
    self.detailMovieModel.backdropPath = [arrivingArray valueForKey:@"backdrop_path"];
    self.detailMovieModel.belongsToCollection = [arrivingArray valueForKey:@"belongs_to_collection"];
    self.detailMovieModel.budget = [[arrivingArray valueForKey:@"budget"] integerValue];
    self.detailMovieModel.genres = [arrivingArray valueForKey:@"genres"];
    self.detailMovieModel.homepage = [arrivingArray valueForKey:@"homepage"];
    self.detailMovieModel.moveId = [[arrivingArray valueForKey:@"id"] integerValue];
    self.detailMovieModel.imdbId = [arrivingArray valueForKey:@"imdb_id"];
    self.detailMovieModel.originalLanguage = [arrivingArray valueForKey:@"original_language"];
    self.detailMovieModel.originalTitle = [arrivingArray valueForKey:@"original_title"];
    self.detailMovieModel.overview = [arrivingArray valueForKey:@"overview"];
    self.detailMovieModel.popularity = [arrivingArray valueForKey:@"popularity"];
    self.detailMovieModel.posterPath = [arrivingArray valueForKey:@"poster_path"];
    self.detailMovieModel.productionCompanies = [arrivingArray valueForKey:@"production_companies"];
    self.detailMovieModel.productionCountries = [arrivingArray valueForKey:@"production_countries"];
    self.detailMovieModel.releaseDate = [arrivingArray valueForKey:@"release_date"];
    self.detailMovieModel.revenue = [[arrivingArray valueForKey:@"revenue"] integerValue];
    self.detailMovieModel.runtime = [[arrivingArray valueForKey:@"runtime"] integerValue];
    self.detailMovieModel.spokenLanguages = [arrivingArray valueForKey:@"spoken_languages"];
    self.detailMovieModel.status = [arrivingArray valueForKey:@"status"];
    self.detailMovieModel.tagline = [arrivingArray valueForKey:@"tagline"];
    self.detailMovieModel.title = [arrivingArray valueForKey:@"title"];
    self.detailMovieModel.video = [[arrivingArray valueForKey:@"video"] boolValue];
    self.detailMovieModel.voteAverage = [[arrivingArray valueForKey:@"vote_average"]floatValue];
    self.detailMovieModel.voteCount = [[arrivingArray valueForKey:@"vote_count"] integerValue];
    
    [self performSegueWithIdentifier:@"fromSearchToDetailed" sender:self];
}



@end
