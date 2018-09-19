//
//  FavoriteManager.m
//  TheMovieDB
//
//  Created by Цындрин Антон on 18.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import "FavoriteManager.h"
#import "DetailMovieModel.h"
#import "MoveCreditsModel.h"
#import "RKDropdownAlert.h"

//DetailMovieModel
#import "FavoriteDetailMovieModel+CoreDataClass.h"
#import "FavoriteGenres+CoreDataClass.h"
#import "FavoriteProductionCountries+CoreDataClass.h"

//MoveCreditsModel
#import "FavoriteMoveCreditsModel+CoreDataClass.h"
#import "FavoriteCast+CoreDataClass.h"



#import <MagicalRecord/MagicalRecord.h>

@implementation FavoriteManager

+ (FavoriteManager*) favoriteManager {
    
    static FavoriteManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FavoriteManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (void)addToFavoriteSelectedModel:(DetailMovieModel *)selectedDetailMovieModel andSelectedMoveCreditsModel:(MoveCreditsModel *)selectedMoveCreditsModel{
    
    NSNumber *val = [NSNumber numberWithInteger:selectedDetailMovieModel.moveId];
    
    //DetailMovieModel
    FavoriteDetailMovieModel *favoriteMoveCreditsModel = [FavoriteDetailMovieModel MR_findFirstByAttribute:@"moveId" withValue:val];
    
    if (favoriteMoveCreditsModel) {
        NSLog(@"FavoriteManager.m| object already exist in core data");
        
        NSString *alertString = [NSString stringWithFormat:@"You already added this move to favorites."];
        [self alertWithTitleString:@"Error!" andmassageString:alertString];
        
    }else{
        
        FavoriteDetailMovieModel *favoriteDetailMovieModel = [FavoriteDetailMovieModel MR_createEntity];
        
        [favoriteDetailMovieModel setAddDate:[NSDate date]];
        [favoriteDetailMovieModel setBudget:selectedDetailMovieModel.budget];
        [favoriteDetailMovieModel setMoveId:selectedDetailMovieModel.moveId];
        [favoriteDetailMovieModel setOriginalTitle:selectedDetailMovieModel.originalTitle];
        [favoriteDetailMovieModel setPosterPath:selectedDetailMovieModel.posterPath];
        [favoriteDetailMovieModel setReleaseDate:selectedDetailMovieModel.releaseDate];
        [favoriteDetailMovieModel setRevenue:selectedDetailMovieModel.revenue];
        [favoriteDetailMovieModel setRuntime:selectedDetailMovieModel.runtime];
        [favoriteDetailMovieModel setStatus:selectedDetailMovieModel.status];
        [favoriteDetailMovieModel setTitle:selectedDetailMovieModel.title];
        [favoriteDetailMovieModel setVoteAverage:selectedDetailMovieModel.voteAverage];
        
        for (int i = 0; i < [selectedDetailMovieModel.genres count]; i++) {
            FavoriteGenres *favoriteGenres = [FavoriteGenres MR_createEntity];
            
            [favoriteGenres setId:[[[selectedDetailMovieModel.genres valueForKey:@"id"]objectAtIndex:i]integerValue]];
            [favoriteGenres setName:[[selectedDetailMovieModel.genres valueForKey:@"name"]objectAtIndex:i]];
            
            [favoriteDetailMovieModel addGenresObject:favoriteGenres];
        }
        
        for (int i = 0;i < [selectedDetailMovieModel.productionCountries count]; i++) {
            FavoriteProductionCountries *favoriteProductionCountries = [FavoriteProductionCountries MR_createEntity];
            
            [favoriteProductionCountries setIso_3166_1:[[selectedDetailMovieModel.productionCountries valueForKey:@"iso_3166_1"]objectAtIndex:i]];
            
            [favoriteProductionCountries setName:[[selectedDetailMovieModel.productionCountries valueForKey:@"name"]objectAtIndex:i]];
            
            [favoriteDetailMovieModel addProductionCountriesObject:favoriteProductionCountries];
        }
        
     //MoveCreditsModel
        FavoriteMoveCreditsModel *favoriteMoveCreditsModel = [FavoriteMoveCreditsModel MR_createEntity];
        
        
        [favoriteMoveCreditsModel setCreditsId:selectedMoveCreditsModel.creditsId];
        
        for (int i = 0;i < [selectedMoveCreditsModel.cast count]; i++) {
            FavoriteCast *favoriteCast = [FavoriteCast MR_createEntity];
            
            [favoriteCast setCharacter:[[selectedMoveCreditsModel.cast
                                    valueForKey:@"character"]objectAtIndex:i]];
            [favoriteCast setName:[[selectedMoveCreditsModel.cast valueForKey:@"name"]objectAtIndex:i]];
            
            if (![[[selectedMoveCreditsModel.cast valueForKey:@"profile_path"]objectAtIndex:i] isEqual:[NSNull null]]) {
                [favoriteCast setProfilePath:[[selectedMoveCreditsModel.cast valueForKey:@"profile_path"]objectAtIndex:i]];
            }
            
            [favoriteMoveCreditsModel addCastObject:favoriteCast];
        }
        
        
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (contextDidSave) {
                NSLog(@"FavoriteManager.m| You successfully saved your context.");
                
                NSString *alertString = [NSString stringWithFormat:@"Move has been added to favorites."];
                [self alertWithTitleString:@"Success!" andmassageString:alertString];
                
            } else if (error) {
                NSLog(@"Error saving context: %@", error.description);
            }
        }];
        
    }
}

- (NSArray*)getArraryWithFavoriteDetailMovieModel{
    
    NSArray *favorite = [FavoriteDetailMovieModel MR_findAllSortedBy:@"addDate" ascending:YES];
    
    return favorite;
}

- (MoveCreditsModel *)getArraryWithFavoriteMoveCreditsModelUseCreditsId:(NSInteger)creditsId{
  
    NSNumber *val = [NSNumber numberWithInteger:creditsId];
    
    FavoriteMoveCreditsModel *favoriteMoveCreditsModel = [FavoriteMoveCreditsModel MR_findFirstByAttribute:@"creditsId" withValue:val];
    
    MoveCreditsModel *moveCreditsModel = [[MoveCreditsModel alloc] init];
    
      NSArray *array = [NSArray arrayWithArray:[favoriteMoveCreditsModel.cast allObjects]];
    
      moveCreditsModel.cast = array;
    
    
    return moveCreditsModel;
}

#pragma marlk - alert

- (void)alertWithTitleString:(NSString*)titleString andmassageString:(NSString*)massageString{
    
    [RKDropdownAlert title:titleString message:massageString backgroundColor:[UIColor lightGrayColor] textColor:[UIColor blueColor] time:2.0f delegate:nil];
}


@end
