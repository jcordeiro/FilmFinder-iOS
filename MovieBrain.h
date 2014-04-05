//
//  MovieBrain.h
//  FilmFinder
//
//  Created by Jonathan Cordeiro on 2014-04-04.
//  Copyright (c) 2014 Jonathan Cordeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieBrain : NSObject

@property (nonatomic, retain) NSDictionary *genreDict;
@property (nonatomic, strong) NSArray *genres;
@property (nonatomic, strong) NSArray *genreCodes;

-(void)fillBrain;
- (int)getGenreCode:(NSString *)genre;

@end
