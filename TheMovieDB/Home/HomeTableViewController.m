//
//  HomeTableViewController.m
//  TheMovieDB
//
//  Created by Цындрин Антон on 14.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import "HomeTableViewController.h"
#import "ServerManager.h"
#import "MovieContentModel.h"
#import "DetailMovieModel.h"
#import "HomeTableViewCell.h"
#import "DetailedTableViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <UIScrollView+SVInfiniteScrolling.h>
#import <SVProgressHUD.h>

#define BASE_IMAGE_URL           @"https://image.tmdb.org/t/p"

@interface HomeTableViewController ()

typedef enum {
    sortingSegmentedControlSelectedSegmentTopRated,
    sortingSegmentedControlSelectedSegmentPopular,
    sortingSegmentedControlSelectedSegmentUpcoming
} SortingSegmentedControlSelectedSegment;

@property(strong,nonatomic)DetailMovieModel      *detailMovieModel;
@property(strong,nonatomic)MovieContentModel     *movieContentModel;

@property(assign,nonatomic)__block NSInteger       page;
@property(strong,nonatomic)NSMutableArray        *movieListArray;
@property(strong,nonatomic)NSMutableArray        *movieDitailArray;
@property(strong,nonatomic)UISegmentedControl    *sortingSegmentedControl;
@property(assign,nonatomic)CGFloat               sortingSegmentedControlValue;
@property(strong,nonatomic)NSString              *language;
@property(strong,nonatomic)NSMutableDictionary   *cellHeightsDictionary;

@end

@implementation HomeTableViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
     //NSLog(@"HomeTableViewController| viewDidLoad");
    
    [self dataSetup];
    [self UISetup];
    [self infiniteScrollingSetup];
    [self sortingSegmentedControlSetup];
    [self movieContentRequest];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    CGFloat topOffset = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.sortingSegmentedControl.frame = CGRectMake(0, topOffset, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
    self.sortingSegmentedControl.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    self.sortingSegmentedControl.hidden = YES;
}

#pragma mark - Setup's

- (void)sortingSegmentedControlSetup {
    
    self.sortingSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Top rated",@"Popular",@"Upcoming", nil]];
    
    CGFloat topOffset = [UIApplication sharedApplication].statusBarFrame.size.height;

    self.sortingSegmentedControl.frame = CGRectMake(0, topOffset, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
    self.sortingSegmentedControl.selectedSegmentIndex = 0;
    [self.sortingSegmentedControl setTintColor:[UIColor blackColor]];
    NSDictionary *attributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:13],NSFontAttributeName,nil];
    [self.sortingSegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.sortingSegmentedControl addTarget:self action:@selector(sortingSegmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.sortingSegmentedControl.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    
    [self.navigationController.view addSubview:self.sortingSegmentedControl];
}



- (void)dataSetup {
    
    self.language = [NSString stringWithFormat:@"en-US"];
    self.cellHeightsDictionary = @{}.mutableCopy;
}

- (void)UISetup {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
}

- (void)infiniteScrollingSetup {
    
    self.page = 1;
    self.movieListArray = [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
      //  NSLog(@"addInfiniteScrollingWithActionHandler");
        weakSelf.page = weakSelf.page + 1;
        [weakSelf movieContentRequest];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }];
}


- (void)sortingSegmentedControlValueChangedSetup:(UISegmentedControl *)SControl {
    
    self.sortingSegmentedControlValue = SControl.selectedSegmentIndex;
    [self.movieListArray removeAllObjects];
    self.page = 1;
    [self movieContentRequest];
    
    
    [self.tableView reloadData];
    NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
    [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
   // NSLog(@"HomeTableViewController| SortingSegmentedControlValueChanged to %ld",(long)SControl.selectedSegmentIndex);
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         CGFloat topOffset = [UIApplication sharedApplication].statusBarFrame.size.height;
         
         self.sortingSegmentedControl.frame = CGRectMake(0, topOffset, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Action's

-(IBAction)sortingSegmentedControlValueChanged:(UISegmentedControl *)SControl
{
    
    if (SControl.selectedSegmentIndex == sortingSegmentedControlSelectedSegmentTopRated)
    {
        [self sortingSegmentedControlValueChangedSetup:SControl];
    }
    else if (SControl.selectedSegmentIndex == sortingSegmentedControlSelectedSegmentPopular)
    {
        [self sortingSegmentedControlValueChangedSetup:SControl];
    }
    else if (SControl.selectedSegmentIndex == sortingSegmentedControlSelectedSegmentUpcoming)
    {
        [self sortingSegmentedControlValueChangedSetup:SControl];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.movieListArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.movieContentModel  = [self.movieListArray objectAtIndex:indexPath.row];
    NSInteger moveId = self.movieContentModel.moveId;
    [self movieDetailsModelRequestedWithId:moveId];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.cellHeightsDictionary setObject:@(cell.frame.size.height) forKey:indexPath];
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *height = [self.cellHeightsDictionary objectForKey:indexPath];
    if (height) return height.doubleValue;
    return UITableViewAutomaticDimension;
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"fromHomeToDetailed"])
    {
        
       DetailedTableViewController  *dtvc = [segue destinationViewController];
        
        [dtvc configureDetailMovieModel:self.detailMovieModel];
    }
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [SVProgressHUD dismiss];
    self.sortingSegmentedControl.hidden = YES;
}

#pragma mark - Request's

- (void)movieContentRequest {
    
    if (self.sortingSegmentedControlValue == sortingSegmentedControlSelectedSegmentTopRated) {
        
        [[ServerManager sharedManager] getTopRatedMoviesSortedByLanguage:self.language
                                                                 andPage:self.page
                                                               onSuccess:^(NSArray *movieList) {
                                                                   //NSLog(@"%lu",(unsigned long)[movieList count]);
                                                                   [self makeMovieListArrayFrom:movieList];
                                                                  //NSLog(@"%lu",(unsigned long)[self.movieListArray count]);
                                                                   [self.tableView reloadData];
                                                                   
                                                               } onFailure:^(NSError *error, NSInteger statusCode) {
                                                               }];
        
    }else if (self.sortingSegmentedControlValue == sortingSegmentedControlSelectedSegmentPopular) {
        
        [[ServerManager sharedManager] getPopularMoviesSortedByLanguage:self.language
                                                                andPage:self.page
                                                              onSuccess:^(NSArray *movieList) {
                                                                  //NSLog(@"%lu",(unsigned long)[movieList count]);
                                                                  [self makeMovieListArrayFrom:movieList];
                                                                  //NSLog(@"%lu",(unsigned long)[self.movieListArray count]);
                                                                  [self.tableView reloadData];
                                                                
                                                              } onFailure:^(NSError *error, NSInteger statusCode) {
                                                              }];
        
    }else if (self.sortingSegmentedControlValue == sortingSegmentedControlSelectedSegmentUpcoming) {
        
        [[ServerManager sharedManager] getUpcomingMoviesSortedByLanguage:self.language
                                                                          andPage:self.page
                                                                       onSuccess:^(NSArray *movieList) {
                                                                           //NSLog(@"%lu",(unsigned long)[movieList count]);
                                                                   [self makeMovieListArrayFrom:movieList];
                                                                           //NSLog(@"%lu",(unsigned long)[self.movieListArray count]);
                                                                   [self.tableView reloadData];
                                                                   
                                                               } onFailure:^(NSError *error, NSInteger statusCode) {
                                                               }];
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
        
    self.detailMovieModel.adult = [[arrivingArray valueForKey:@"adult"] boolValue];
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
    self.detailMovieModel.voteAverage = [[arrivingArray valueForKey:@"vote_average"] floatValue];
    self.detailMovieModel.voteCount = [[arrivingArray valueForKey:@"vote_count"] integerValue];
    
    [self performSegueWithIdentifier:@"fromHomeToDetailed" sender:self];
}


- (void)makeMovieListArrayFrom:(NSArray*)arrivingArray{
    
    for (int i = 0; i < [arrivingArray count]; i++) {
        
        NSArray *array = [arrivingArray objectAtIndex:i];
        MovieContentModel *model = [[MovieContentModel alloc] init];
        
        NSNumber *voteCountNumber  = [array valueForKey:@"vote_count"];
        model.voteCount = [voteCountNumber doubleValue];
        
        NSNumber *idNumber = [array valueForKey:@"id"];
        model.moveId = [idNumber doubleValue];
        
        NSNumber *popularityNumber = [array valueForKey:@"popularity"];
        model.popularity = [popularityNumber doubleValue];
        
        model.voteAverage = [[array valueForKey:@"vote_average"] floatValue];
        model.title = [array valueForKey:@"title"];
        model.video = [[array valueForKey:@"video"] boolValue];
        model.posterPath = [array valueForKey:@"poster_path"];
        model.originalLanguage = [array valueForKey:@"original_language"];
        model.originalTitle = [array valueForKey:@"original_title"];
        model.genreIds     =  [array valueForKey:@"genre_ids"];
        model.backdropPath =  [array valueForKey:@"backdrop_path"];
        model.adult        =  [[array valueForKey:@"adult"] boolValue];
        model.overview     =  [array valueForKey:@"overview"];
        model.releaseDate  =  [array valueForKey:@"release_date"];
        
        [self.movieListArray addObject:model];
    }
}

@end
