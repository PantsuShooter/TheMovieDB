//
//  TopBilledCastCollectionViewCell.h
//  TheMovieDB
//
//  Created by Цындрин Антон on 16.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopBilledCastCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *castPosterImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;

@end
