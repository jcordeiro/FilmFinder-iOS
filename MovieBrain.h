//
//  MovieBrain.h
//  FilmFinder
//
//  Created by Jonathan Cordeiro on 2014-04-04.
//  Copyright (c) 2014 Jonathan Cordeiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import "MovieDataConnection.h"
@class MainViewController;

@interface MovieBrain : NSObject <NSURLConnectionDelegate>
{
   NSMutableData *_responseData;   
}

extern NSString * const API_KEY;
extern NSString * const API_BASE_URL;
extern NSString * const POSTER_BASE_PATH;

extern NSString * const NBR_OF_PAGES_REQUEST;
extern NSString * const RANDOM_PAGE_REQUEST;
extern NSString * const MOVIE_DETAIL_REQUEST;

@property (nonatomic, retain) NSDictionary *genreDict;
@property (nonatomic, strong) NSArray *genres;
@property (nonatomic, strong) NSArray *genreCodes;

- (void)fillBrain;
- (int)getGenreCode:(NSString *)genre;

- (void)startRequestsForMovie:(int)genreCode;

- (int)getNbrOfResultPages;
- (void)sendRequestForNbrOfPages:(int) genreCode;
- (void)sendRequestForRandomPage:(int)totalPages forGenre:(int)genreCode;
- (Movie *)getRandomMovie;
- (void) sendRequestForMoreMovieDetails:(Movie *)movie;
- (void)addExtraMovieDetailsToMovie:(Movie *)movie;

- (Movie *)getStaticMovieVariable;
- (BOOL)isFinishedFetchingMovie;




@end
