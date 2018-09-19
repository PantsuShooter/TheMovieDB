//
//  DetailedTableViewController.h
//  TheMovieDB
//
//  Created by Цындрин Антон on 15.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailMovieModel;
@class MoveCreditsModel;

@interface DetailedTableViewController : UITableViewController

- (void)configureDetailMovieModel:(DetailMovieModel *)detailMovieModel;

- (void)configureDetailMovieModel:(DetailMovieModel *)detailMovieModel andMoveCreditsModel:(MoveCreditsModel *)moveCreditsModel;

@end
