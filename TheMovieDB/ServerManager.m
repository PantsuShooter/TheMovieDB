//
//  ServerManager.m
//  TheMovieDB
//
//  Created by Цындрин Антон on 14.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import "ServerManager.h"
#import <AFNetworking.h>

#define REQUEST_BASE_URL  @"https://api.themoviedb.org/3/"
#define API_KEY           @"1619d60fda3b07c32abfce2794f934d6"



@interface ServerManager ()

@property(strong,nonatomic)AFHTTPSessionManager *sessionManager;

@end

@implementation ServerManager

+ (ServerManager*)sharedManager {
    
    static ServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *baseURL = [NSURL URLWithString:REQUEST_BASE_URL];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];

    }
    return self;
}

#pragma mark - Request's

- (void)getTopRatedMoviesSortedByLanguage:(NSString*)language
                                  andPage:(NSInteger)page
                                onSuccess:(void(^)(NSArray* movieList)) success
                                onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                API_KEY,  @"api_key",
                                language, @"language",
                                @(page),  @"page",nil];
    
    [self.sessionManager GET:@"movie/top_rated"
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        NSLog(@"downloadProgress %@",downloadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               // NSLog(@"createSessionOnSuccess| responseObject| %@",responseObject);
                NSArray *movieList = [responseObject objectForKey:@"results"];
                if (success) {
                    success(movieList);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"createSessionOnSuccess| error %@",error);
            }];
};

- (void)getPopularMoviesSortedByLanguage:(NSString*)language
                                 andPage:(NSInteger)page
                               onSuccess:(void(^)(NSArray* movieList)) success
                               onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                API_KEY,  @"api_key",
                                language, @"language",
                                @(page),  @"page",nil];
    
    [self.sessionManager GET:@"movie/popular"
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        NSLog(@"downloadProgress %@",downloadProgress);
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        // NSLog(@"createSessionOnSuccess| responseObject| %@",responseObject);
                        NSArray *movieList = [responseObject objectForKey:@"results"];
                        if (success) {
                            success(movieList);
                        }
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"createSessionOnSuccess| error %@",error);
                    }];
}

- (void)getUpcomingMoviesSortedByLanguage:(NSString*)language
                                 andPage:(NSInteger)page
                               onSuccess:(void(^)(NSArray* movieList)) success
                               onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                API_KEY,  @"api_key",
                                language, @"language",
                                @(page),  @"page",nil];
    
    [self.sessionManager GET:@"movie/upcoming"
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        NSLog(@"downloadProgress %@",downloadProgress);
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        // NSLog(@"createSessionOnSuccess| responseObject| %@",responseObject);
                        NSArray *movieList = [responseObject objectForKey:@"results"];
                        if (success) {
                            success(movieList);
                        }
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"createSessionOnSuccess| error %@",error);
                    }];
}

- (void)getMovieDetailsUsingMovieId:(NSInteger)movieId
                andSortedByLanguage:(NSString*)language
                          onSuccess:(void(^)(NSArray* movieDetails)) success
                          onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                API_KEY,  @"api_key",
                                language, @"language",nil];
    
    NSString *queryString = [NSString stringWithFormat:@"movie/%ld",(long)movieId];
    
    [self.sessionManager GET:queryString
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        NSLog(@"downloadProgress %@",downloadProgress);
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       // NSLog(@"createSessionOnSuccess| responseObject| %@",responseObject);
                        NSArray *movieDetails = responseObject;
                        if (success) {
                            success(movieDetails);
                        }
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"createSessionOnSuccess| error %@",error);
                    }];
}

- (void)getMovieVideosDetailsUsingMovieId:(NSInteger)movieId
                andSortedByLanguage:(NSString*)language
                          onSuccess:(void(^)(NSArray* movieVideosDetails)) success
                          onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                API_KEY,  @"api_key",
                                language, @"language",nil];
    
    NSString *queryString = [NSString stringWithFormat:@"movie/%ld/videos",(long)movieId];
    
    [self.sessionManager GET:queryString
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        NSLog(@"downloadProgress %@",downloadProgress);
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     //    NSLog(@"createSessionOnSuccess| responseObject| %@",responseObject);
                        NSArray *movieVideosDetails = responseObject;
                        if (success) {
                            success(movieVideosDetails);
                        }
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"createSessionOnSuccess| error %@",error);
                    }];
}

- (void)getMovieCreditsDetailsUsingMovieId:(NSInteger)movieId
                                 onSuccess:(void(^)(NSArray* creditsDetails)) success
                                 onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                API_KEY,  @"api_key", nil];
    
    NSString *queryString = [NSString stringWithFormat:@"movie/%ld/credits",(long)movieId];
    
                            [self.sessionManager GET:queryString
                                          parameters:parameters
                                            progress:^(NSProgress * _Nonnull downloadProgress) {
                                                NSLog(@"downloadProgress %@",downloadProgress);
                                            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                 // NSLog(@"createSessionOnSuccess| responseObject| %@",responseObject);
                                                NSArray *creditsDetails = responseObject;
                                                if (success) {
                                                    success(creditsDetails);
                                                }
                                                
                                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                NSLog(@"createSessionOnSuccess| error %@",error);
                                            }];
}

- (void)getSearchMoviesSortedByLanguage:(NSString*)language
                                  query:(NSString*)query
                                andPage:(NSInteger)page
                              onSuccess:(void(^)(NSArray* movieList)) success
                              onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                API_KEY,  @"api_key",
                                language, @"language",
                                query,    @"query",
                                @(page),  @"page",nil];
    
    
    [self.sessionManager GET:@"search/movie"
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        NSLog(@"downloadProgress %@",downloadProgress);
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        //    NSLog(@"createSessionOnSuccess| responseObject| %@",responseObject);
                        NSArray *movieList = [responseObject objectForKey:@"results"];
                        if (success) {
                            success(movieList);
                        }

                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"createSessionOnSuccess| error %@",error);
                    }];
}

@end
