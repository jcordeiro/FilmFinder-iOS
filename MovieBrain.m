//
//  MovieBrain.m
//  FilmFinder
//
//  Created by Jonathan Cordeiro on 2014-04-04.
//  Copyright (c) 2014 Jonathan Cordeiro. All rights reserved.
//

#import "MovieBrain.h"
#import "Movie.h"
#import "MovieDataConnection.h"

@implementation MovieBrain

// variable to hold the random Movie found by the brain
// available in all methods so that it can hold the movie data
// in between connection requests for movie data
Movie *randomMovie;

// Variable to hold whether or not the random movie is finished being fetched
BOOL movieFetched;

// Variable to hold the MainViewController
//UIViewController *mainController;

// Constants for use with themoviedb.org's API
NSString * const API_KEY = @"78ce6d1fe61708beb0815b4772f4be3e";
NSString * const API_BASE_URL = @"https://api.themoviedb.org/3/";
NSString * const POSTER_BASE_PATH = @"http://cf2.imgobject.com/t/p/original";

// Connection type strings for MovieDataConnection
NSString * const NBR_OF_PAGES_REQUEST = @"nbrOfPages";
NSString * const RANDOM_PAGE_REQUEST = @"randomPage";
NSString * const MOVIE_DETAIL_REQUEST = @"movieDetail";

@synthesize genreDict;
@synthesize genres;
@synthesize genreCodes;

- (Movie *)getStaticMovieVariable
{
    return randomMovie;
}

- (BOOL)isFinishedFetchingMovie
{
    return movieFetched;
}

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

// Queries themoviedb's api to find random movies for a specific genre
// and returns the number of result pages there are in the JSON response
- (void)sendRequestForNbrOfPages:(int) genreCode
{
    NSLog(@"sendRequestForNbrOfPages");
    
    NSString *u = [NSString stringWithFormat:
                   @"%@%@%d%@%@", API_BASE_URL, @"genre/", genreCode, @"/movies?api_key=",API_KEY];
    
    NSURL *url = [NSURL URLWithString:u];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    MovieDataConnection *conn = [[MovieDataConnection alloc] initWithRequest:request delegate:self];
    [conn setConnectionType: NBR_OF_PAGES_REQUEST];
    
    // Create url connection and fire request
 //   NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// Parses JSON data returned from themoviedb's api and returns
// the number of pages in the results
- (int)getNbrOfResultPages
{
    NSLog(@"getNbrOfResultPages");
    
    int nbrOfPages;
    
    NSError *error = nil;
    
    NSArray *json = [NSJSONSerialization JSONObjectWithData:_responseData
                                                    options:kNilOptions
                                                      error:&error];
    
    nbrOfPages = [[json valueForKey:@"total_pages"] intValue];
    
    NSLog(@"Pages: %d", nbrOfPages);
    
    return nbrOfPages;
}

// Makes a call to themoviedb's api and returns a single random page
// from the results. This way we only need to parse through one page of results
- (void) sendRequestForRandomPage:(int)totalPages forGenre:(int)genreCode
{
    
    NSLog(@"sendRequestForRandomPage");
    
    // Calculate the number of a random page number
    // between 1 and the total number of pages
    int randomPage = 1 + arc4random() % (totalPages - 1);
    
    
    NSString *u = [NSString stringWithFormat:
                   @"%@%@%d%@%@%@%d", API_BASE_URL, @"genre/", genreCode, @"/movies?api_key=",API_KEY, @"&page=", randomPage];
    
    NSURL *url = [NSURL URLWithString:u];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create url connection and fire request
    MovieDataConnection *conn = [[MovieDataConnection alloc] initWithRequest:request delegate:self];
    [conn setConnectionType:RANDOM_PAGE_REQUEST];
    
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// Parses a page of JSON results and returns a Movie object picked at random
-(Movie *)getRandomMovie
{
    NSLog(@"getRandomMovie");
    
    Movie *movie = [[Movie alloc] init];
//     randomMovie = [[Movie alloc] init];
    
    NSError *error = nil;
    
    NSArray *json = [NSJSONSerialization JSONObjectWithData:_responseData
                                                    options:kNilOptions
                                                      error:&error];
    
    NSArray *results = [json valueForKey:@"results"];
    
    // Pick a random index from the array of results
    int randomIndex = 1 + arc4random() % ([results count] - 1);
    
    //    NSLog(@"Movie: %@", [results objectAtIndex:randomIndex]);
    
    NSDictionary *record = [results objectAtIndex:randomIndex];
    
    //    NSString *key;
    //    for(key in randomResult){
    //        NSLog(@"Key: %@, Value %@", key, [randomResult objectForKey: key]);
    //    }
    
    [movie setBackdropPath:[record valueForKey:@"backdrop_path"]];
    [movie setMovieID:[[record valueForKey:@"id"] integerValue]];
    [movie setOriginalTitle:[record valueForKey:@"original_title"]];
    [movie setReleaseDate:[record valueForKey:@"release_date"]];
    [movie setPosterPath:[record valueForKey:@"poster_path"]];
    
    NSString *fullPosterUrl = [NSString stringWithFormat:@"%@%@", POSTER_BASE_PATH, [randomMovie posterPath]];
    
    NSURL *imageURL = [NSURL URLWithString:fullPosterUrl];
    
    // Get the poster for the movie from the URL
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        [movie setPoster:[UIImage imageWithData:imageData]];
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            // Update the UI
        //            self.imageView.image = [UIImage imageWithData:imageData];
        //        });
    });
    
    [movie setTitle:[record valueForKey:@"title"]];
    [movie setVoteAverage:[[record valueForKey:@"vote_average"] doubleValue]];
    [movie setVoteCount:[[record valueForKey:@"vote_count"] doubleValue]];
    
    //    @synthesize backdropPath;
    //    @synthesize movieID;
    //    @synthesize originalTitle;
    //    @synthesize releaseDate;
    //    @synthesize posterPath;
    //    @synthesize title;
    //    @synthesize poster;
    //    @synthesize voteAverage;
    //    @synthesize voteCount;
    //    @synthesize imdbID;
    //    @synthesize overview;
    //    @synthesize revenue;
    //    @synthesize runtime;
    
    NSLog(@"%@", movie);
    
    return movie;
}

-(Movie *)fillMovieWithInfo:(Movie *)movie
{
    NSLog(@"getRandomMovie");
    
    //    Movie *randomMovie = [[Movie alloc] init];
    randomMovie = [[Movie alloc] init];
    
    NSError *error = nil;
    
    NSArray *json = [NSJSONSerialization JSONObjectWithData:_responseData
                                                    options:kNilOptions
                                                      error:&error];
    
    NSArray *results = [json valueForKey:@"results"];
    
    // Pick a random index from the array of results
    int randomIndex = 1 + arc4random() % ([results count] - 1);
    
    //    NSLog(@"Movie: %@", [results objectAtIndex:randomIndex]);
    
    NSDictionary *record = [results objectAtIndex:randomIndex];
    
    //    NSString *key;
    //    for(key in randomResult){
    //        NSLog(@"Key: %@, Value %@", key, [randomResult objectForKey: key]);
    //    }
    
    [randomMovie setBackdropPath:[record valueForKey:@"backdrop_path"]];
    [randomMovie setMovieID:[[record valueForKey:@"id"] integerValue]];
    [randomMovie setOriginalTitle:[record valueForKey:@"original_title"]];
    [randomMovie setReleaseDate:[record valueForKey:@"release_date"]];
    [randomMovie setPosterPath:[record valueForKey:@"poster_path"]];
    
    NSString *fullPosterUrl = [NSString stringWithFormat:@"%@%@", POSTER_BASE_PATH, [randomMovie posterPath]];
    
    NSURL *imageURL = [NSURL URLWithString:fullPosterUrl];
    
    // Get the poster for the movie from the URL
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        [randomMovie setPoster:[UIImage imageWithData:imageData]];
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            // Update the UI
        //            self.imageView.image = [UIImage imageWithData:imageData];
        //        });
    });
    
    [randomMovie setTitle:[record valueForKey:@"title"]];
    [randomMovie setVoteAverage:[[record valueForKey:@"vote_average"] doubleValue]];
    [randomMovie setVoteCount:[[record valueForKey:@"vote_count"] doubleValue]];
    
    //    @synthesize backdropPath;
    //    @synthesize movieID;
    //    @synthesize originalTitle;
    //    @synthesize releaseDate;
    //    @synthesize posterPath;
    //    @synthesize title;
    //    @synthesize poster;
    //    @synthesize voteAverage;
    //    @synthesize voteCount;
    //    @synthesize imdbID;
    //    @synthesize overview;
    //    @synthesize revenue;
    //    @synthesize runtime;
    
    NSLog(@"%@", randomMovie);
    
    return randomMovie;
}

// Calls themoviedb's api to get more details for the random movie that was chosen
- (void) sendRequestForMoreMovieDetails:(Movie *)movie
{
    NSLog(@"sendRequestForMoreMovieDetails");
    
    NSString *u = [NSString stringWithFormat:
                   @"%@%@%d%@%@", API_BASE_URL, @"movie/", [movie movieID], @"?api_key=",API_KEY];
    
    NSURL *url = [NSURL URLWithString:u];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create url connection and fire request
    MovieDataConnection *conn = [[MovieDataConnection alloc] initWithRequest:request delegate:self];
    [conn setConnectionType: MOVIE_DETAIL_REQUEST];
    
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// Parses through the JSON data for a movie's extra details and adds them to
// a movie object
- (void)addExtraMovieDetailsToMovie:(Movie *)movie
{
    NSLog(@"addExtraMovieDetails");
    
    NSError *error = nil;
    
    NSArray *json = [NSJSONSerialization JSONObjectWithData:_responseData
                                                    options:kNilOptions
                                                      error:&error];
    
    [movie setOverview: [json valueForKey:@"overview"]];
    [movie setImdbID: [json valueForKey:@"imdb_id"]];
    [movie setRuntime: [[json valueForKey:@"runtime"] intValue]];
    
    NSLog(@"%@", movie);
    
//    return movie;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    
    NSLog(@"RUNNING! 1");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    
    NSLog(@"RUNNING! 2");
    return nil;
}

// Sends the first of 3 requests needed to get all the data for a
// complete movie object. The connectionDidFinishLoading callback
// method calls the remaining requests and returns the filled movie object
- (void)startRequestsForMovie:(int)genreCode
{
    [self sendRequestForNbrOfPages:genreCode];
}

- (void)connectionDidFinishLoading:(MovieDataConnection *)connection
{
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    NSLog(@"RUNNING! 3");
    
    // Default to 28 for action, but will eventually pull this from spinner
    // or choose a random genere
    int genreCode = 28;
    
//    Movie *random;
    int nbrOfPages;
    
    // Determine which request was sent so we can call the appropriate
    // method to parse the returned data
    if ([[connection connectionType] isEqualToString:NBR_OF_PAGES_REQUEST]) {
        
        // Parse the result from themoviedb for the number of result pages
        nbrOfPages = [self getNbrOfResultPages];
        
        [self sendRequestForRandomPage:nbrOfPages forGenre:genreCode];
        
    }
    else if ([[connection connectionType] isEqualToString:RANDOM_PAGE_REQUEST]) {
        // Make a reqest to get a random Movie object from a random page
        // of the JSON results
        randomMovie = [self getRandomMovie];
        
        [self sendRequestForMoreMovieDetails:randomMovie];
    }
    else if ([[connection connectionType] isEqualToString:MOVIE_DETAIL_REQUEST]) {
        
        [self addExtraMovieDetailsToMovie:randomMovie];
        
        
        // This is the last in the sequence of requests
        // so we'll return set isFinishedFetchingMovie to YES
//        isFinishedFetchingMovie = YES;
        movieFetched = YES;
        
        // Perform the segue to the movie view controller
      //  [mainController performSegueWithIdentifier:@"chosenGenreSegue" sender: self];
        
        //
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"movie fetched" object:self];
    }
    else {
        
        // If we've reached here there's been some sort of error!
        NSLog(@"Where did this connection come from?!");
    }
    
    
  //  return nil;
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    NSLog(@"%@", error);
    
}

@end
