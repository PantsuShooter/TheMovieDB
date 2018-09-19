//
//  MovieContentModel.h
//  TheMovieDB
//
//  Created by Цындрин Антон on 14.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MovieContentModel : NSObject

@property(assign,nonatomic)NSInteger   voteCount;
@property(assign,nonatomic)NSInteger   moveId;
@property(assign,nonatomic)BOOL         video;
@property(assign,nonatomic)CGFloat     voteAverage;
@property(strong,nonatomic)NSString*   title;
@property(assign,nonatomic)NSInteger   popularity;
@property(strong,nonatomic)NSString*   posterPath;
@property(strong,nonatomic)NSString*   originalLanguage;
@property(strong,nonatomic)NSString*   originalTitle;
@property(strong,nonatomic)NSArray*    genreIds;
@property(strong,nonatomic)NSString*   backdropPath;
@property(assign,nonatomic)BOOL         adult;
@property(strong,nonatomic)NSString*   overview;
@property(strong,nonatomic)NSString*   releaseDate;


@end
