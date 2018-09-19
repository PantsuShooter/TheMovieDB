//
//  ServerManager.h
//  TheMovieDB
//
//  Created by Цындрин Антон on 14.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject

+ (ServerManager*)sharedManager;

- (void)getTopRatedMoviesSortedByLanguage:(NSString*)language
                                  andPage:(NSInteger)page
                                onSuccess:(void(^)(NSArray* movieList)) success
                                 onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void)getPopularMoviesSortedByLanguage:(NSString*)language
                                  andPage:(NSInteger)page
                                onSuccess:(void(^)(NSArray* movieList)) success
                                onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void)getUpcomingMoviesSortedByLanguage:(NSString*)language
                                 andPage:(NSInteger)page
                               onSuccess:(void(^)(NSArray* movieList)) success
                               onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void)getMovieDetailsUsingMovieId:(NSInteger)movieId
                andSortedByLanguage:(NSString*)language
                          onSuccess:(void(^)(NSArray* movieDetails)) success
                          onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void)getMovieVideosDetailsUsingMovieId:(NSInteger)movieId
                andSortedByLanguage:(NSString*)language
                          onSuccess:(void(^)(NSArray* movieDetails)) success
                          onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void)getMovieCreditsDetailsUsingMovieId:(NSInteger)movieId
                                onSuccess:(void(^)(NSArray* creditsDetails)) success
                                onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void)getSearchMoviesSortedByLanguage:(NSString*)language
                                  query:(NSString*)query
                                  andPage:(NSInteger)page
                                onSuccess:(void(^)(NSArray* movieList)) success
                                onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


@end
