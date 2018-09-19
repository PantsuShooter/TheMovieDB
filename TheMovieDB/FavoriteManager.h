//
//  FavoriteManager.h
//  TheMovieDB
//
//  Created by Цындрин Антон on 18.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DetailMovieModel;
@class MoveCreditsModel;
@class FavoriteMoveCreditsModel;

@interface FavoriteManager : NSObject


+ (FavoriteManager*) favoriteManager;

- (void)addToFavoriteSelectedModel:(DetailMovieModel *)selectedDetailMovieModel andSelectedMoveCreditsModel:(MoveCreditsModel*)selectedMoveCreditsModel;

- (NSArray*)getArraryWithFavoriteDetailMovieModel;

- (MoveCreditsModel *)getArraryWithFavoriteMoveCreditsModelUseCreditsId:(NSInteger)creditsId;
@end
