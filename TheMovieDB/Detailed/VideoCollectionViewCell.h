//
//  VideoCollectionViewCell.h
//  TheMovieDB
//
//  Created by Цындрин Антон on 17.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <youtube-ios-player-helper/YTPlayerView.h>

@interface VideoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet YTPlayerView *videoView;


@end
