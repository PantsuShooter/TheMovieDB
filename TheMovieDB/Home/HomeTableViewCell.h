//
//  HomeTableViewCell.h
//  TheMovieDB
//
//  Created by Цындрин Антон on 14.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressLabel.h"

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;

@property (weak, nonatomic) IBOutlet ProgressLabel *ratingProgressLable;


@end
