//
//  MovieBrain.m
//  FilmFinder
//
//  Created by Jonathan Cordeiro on 2014-04-04.
//  Copyright (c) 2014 Jonathan Cordeiro. All rights reserved.
//

#import "MovieBrain.h"

@implementation MovieBrain

@synthesize genreDict;
@synthesize genres;
@synthesize genreCodes;

- (void)fillBrain
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Genres" ofType:@"plist"];
    
    // Load the file content and read the data into arrays
    genreDict = [[NSDictionary alloc] initWithContentsOfFile:path];
//    genres = [genreDict allKeys];
    genres = [[genreDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    genreCodes = [genreDict allValues];
 
}

// Takes the name of a genre and returns the int genreCode associated with it
// that's needed for use with themoviedb.org's API
- (int)getGenreCode:(NSString *)genre
{
    return [[genreDict objectForKey:genre] intValue];
}

@end
