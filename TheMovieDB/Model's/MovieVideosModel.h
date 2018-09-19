//
//  MovieVideosModel.h
//  TheMovieDB
//
//  Created by Цындрин Антон on 17.09.2018.
//  Copyright © 2018 Цындрин Антон. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieVideosModel : NSObject

@property(assign,nonatomic)NSInteger    moveId;
@property(strong,nonatomic)NSArray      *results;

@end
