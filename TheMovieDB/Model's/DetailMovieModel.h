//
//  DetailMovieModel.h
//  TheMovieDB
//
//  Created by Цындрин Антон on 15.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DetailMovieModel : NSObject

@property(assign,nonatomic)BOOL                adult;
@property(strong,nonatomic)NSString           *backdropPath;
@property(strong,nonatomic)NSArray            *belongsToCollection;
@property(assign,nonatomic)NSInteger          budget;
@property(strong,nonatomic)NSArray            *genres;
@property(strong,nonatomic)NSString           *homepage;
@property(assign,nonatomic)NSInteger          moveId;
@property(strong,nonatomic)NSString           *imdbId;
@property(strong,nonatomic)NSString           *originalLanguage;
@property(strong,nonatomic)NSString           *originalTitle;
@property(strong,nonatomic)NSString           *overview;
@property(strong,nonatomic)NSNumber           *popularity;
@property(strong,nonatomic)NSString           *posterPath;
@property(strong,nonatomic)NSArray            *productionCompanies;
@property(strong,nonatomic)NSArray            *productionCountries;
@property(strong,nonatomic)NSString           *releaseDate;
@property(assign,nonatomic)NSInteger          revenue;
@property(assign,nonatomic)NSInteger          runtime;
@property(strong,nonatomic)NSArray            *spokenLanguages;
@property(strong,nonatomic)NSString           *status;
@property(strong,nonatomic)NSString           *tagline;
@property(strong,nonatomic)NSString           *title;
@property(assign,nonatomic)BOOL                video;
@property(assign,nonatomic)CGFloat            voteAverage; 
@property(assign,nonatomic)NSInteger          voteCount;


@end
