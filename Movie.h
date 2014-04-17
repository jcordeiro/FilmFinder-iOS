//
//  Movie.h
//  FilmFinder
//
//  Created by Jonathan Cordeiro on 2014-04-05.
//  Copyright (c) 2014 Jonathan Cordeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject <NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
}

//extern NSString * const API_KEY;
//extern NSString * const API_BASE_URL;
//extern NSString * const POSTER_BASE_PATH;


@property (nonatomic, copy) NSString *backdropPath;
@property (nonatomic, assign) int movieID;
@property (nonatomic, copy) NSString *originalTitle;
@property (nonatomic, copy) NSString *releaseDate;
@property (nonatomic, copy) NSString *posterPath;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIImage *poster;
@property (nonatomic, assign) double voteAverage;
@property (nonatomic, assign) int voteCount;
@property (nonatomic, copy) NSString *imdbID;
@property (nonatomic, copy) NSString *overview;
@property (nonatomic, copy) NSString *revenue;
@property (nonatomic, assign) int runtime;


//- (int)getNbrOfResultPages;
//- (void)sendRequestForNbrOfPages:(int) genreCode;
//- (void)sendRequestForRandomPage:(int)totalPages forGenre:(int)genreCode;
//- (Movie *)getRandomMovie;
//- (void) sendRequestForMoreMovieDetails:(Movie *)movie;
//- (Movie *)addExtraMovieDetailsToMovie:(Movie *)movie;

@end


