//
//  MoveCreditsModel.h
//  TheMovieDB
//
//  Created by Цындрин Антон on 16.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoveCreditsModel : NSObject

@property(assign,nonatomic)NSInteger  creditsId;
@property(strong,nonatomic)NSArray    *cast;
@property(strong,nonatomic)NSArray    *crew;

@end
