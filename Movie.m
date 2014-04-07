//
//  Movie.m
//  FilmFinder
//
//  Created by Jonathan Cordeiro on 2014-04-05.
//  Copyright (c) 2014 Jonathan Cordeiro. All rights reserved.
//

#import "Movie.h"

@implementation Movie

NSString * const API_KEY = @"78ce6d1fe61708beb0815b4772f4be3e";
NSString * const API_BASE_URL = @"https://api.themoviedb.org/3/";
NSString * const POSTER_BASE_PATH = @"http://cf2.imgobject.com/t/p/original/";

@synthesize backdropPath;
@synthesize movieID;
@synthesize originalTitle;
@synthesize releaseDate;
@synthesize posterPath;
@synthesize title;
@synthesize voteAverage;
@synthesize voteCount;
@synthesize imdbID;
@synthesize overview;
@synthesize revenue;
@synthesize runtime;


- (Movie *)getMovieDetails
{
    Movie *movie = [[Movie alloc] init];
    
    NSString *u = [NSString stringWithFormat:
                   @"%@%@%d%@%@", API_BASE_URL, @"genre/", 28, @"/movies?api_key=",API_KEY];
    
    NSURL *url = [NSURL URLWithString:u];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
//    // Create the request.
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
//
//    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response,
//                                               NSData *data, NSError *connectionError)
//     {
//         if (data.length > 0 && connectionError == nil)
//         {
//             
//             NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data
//                                                                      options:0
//                                                                        error:NULL];
//             
//             NSString *key;
//             for(key in results){
//                 NSLog(@"Key: %@, Value %@", key, [results objectForKey: key]);
//             }
////             
////             self.greetingId.text = [[greeting objectForKey:@"id"] stringValue];
////             self.greetingContent.text = [greeting objectForKey:@"content"];
//         }
//         else
//         {
//             NSLog(@"%@ \n %@", connectionError, data);
//             
//             
//         }
//     }];
    
    
    
    
    return movie;
}


// Queries themoviedb's api to find random movies for a specific genre
// and returns the number of result pages there are in the JSON response
- (int)getNbrOfResultPages:(int) genreCode
{
    int nbrOfPages = 0;
    
    NSString *u = [NSString stringWithFormat:
                   @"%@%@%d%@%@", API_BASE_URL, @"genre/", genreCode, @"/movies?api_key=",API_KEY];
    
    NSURL *url = [NSURL URLWithString:u];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    return nbrOfPages;
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
        NSLog(@"RUNNING 3");
    
    // Default to 28 for action, but will eventually pull this from spinner
    // or choose a random genere
    int genreCode = 28;
    
    // Make a request to themoviedb for the number of result pages
    int nbrOfPages = [self getNbrOfResultPages:genreCode];
    
    // Parse through a pa
    [self parseJSONMovies:nbrOfPages forGenre:genreCode];
    
    
    
//    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:_responseData
//                                                            options:0
//                                                              error:NULL];
    
//    NSArray *json = [NSJSONSerialization JSONObjectWithData:_responseData
//                                                            options:0
//                                                              error:NULL];
    
    // Print array contents
//    NSLog(@"%@", [json objectAtIndex:2]);
    
    
    
//    NSString *key;
    
//    for (NSString *key in json) {
//        
//        
//        
//        
//    }
    
    
    
//    for(key in results){
//        NSLog(@"Key: %@, Value %@", key, [results objectForKey: key]);
//    }
    
}

// Parses a page of JSON results and returns an NSMutableArray of movie objects
- (NSMutableArray *)parseJSONMovies:(int) nbrOfPages forGenre:(int) genreCode {
    
    NSMutableArray *retval = [[NSMutableArray alloc]init];
    
//    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"capitals"
//                                                         ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    
    NSError *error = nil;
    
    NSArray *json = [NSJSONSerialization JSONObjectWithData:_responseData
                                                    options:kNilOptions
                                                      error:&error];
    
    // Get a random page from the JSON results
    int totalPages = [[json objectAtIndex:3] intValue];
    int randomPage = 1 + arc4random() % (1 - totalPages);
    
    
    NSArray *results = [json valueForKey:@"results"];
    
    for (Movie *record in results) {
        
        Movie *temp = [[Movie alloc] init];
        [temp setBackdropPath:[record valueForKey:@"backdrop_path"]];
        [temp setMovieID:[[record valueForKey:@"id"] integerValue]];
        [temp setOriginalTitle:[record valueForKey:@"original_title"]];
        [temp setReleaseDate:[record valueForKey:@"release_date"]];
        [temp setPosterPath:[record valueForKey:@"poster_path"]];
        [temp setTitle:[record valueForKey:@"title"]];
        [temp setVoteAverage:[[record valueForKey:@"vote_average"] doubleValue]];
        [temp setVoteCount:[[record valueForKey:@"vote_count"] doubleValue]];

        
        [retval addObject:temp];
        
        NSLog(@"%@", temp);
        
    }
    
//    {
//        "backdrop_path": "/6xKCYgH16UuwEGAyroLU6p8HLIn.jpg",
//        "id": 238,
//        "original_title": "The Godfather",
//        "release_date": "1972-03-24",
//        "poster_path": "/d4KNaTrltq6bpkFS01pYtyXa09m.jpg",
//        "title": "The Godfather",
//        "vote_average": 9.1999999999999993,
//        "vote_count": 125
//    },
    
//    @property (nonatomic, copy) NSString *backdropPath;
//    @property (nonatomic, assign) int movieID;
//    @property (nonatomic, copy) NSString *originalTitle;
//    @property (nonatomic, copy) NSString *releaseDate;
//    @property (nonatomic, copy) NSString *posterPath;
//    @property (nonatomic, copy) NSString *title;
//    @property (nonatomic, assign) double voteAverage;
//    @property (nonatomic, assign) int voteCount;
//    @property (nonatomic, copy) NSString *imdbID;
//    @property (nonatomic, copy) NSString *overview;
//    @property (nonatomic, copy) NSString *revenue;
//    @property (nonatomic, assign) int runtime;
    
    
//    for (JFMapAnnotation *record in json) {
//        
//        JFMapAnnotation *temp = [[JFMapAnnotation alloc]init];
//        [temp setTitle:[record valueForKey:@"Capital"]];
//        [temp setSubtitle:[record valueForKey:@"Country"]];
//        [temp setCoordinate:CLLocationCoordinate2DMake([[record valueForKey:@"Latitude"]floatValue], [[record valueForKey:@"Longitude"]floatValue])];
//        [retval addObject:temp];
//        
//    }
    
//    NSLog(@"%@", retval);
    
    
    
    return retval;
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    NSLog(@"%@", error);
    
}

-(NSString *)description
{
//    [temp setBackdropPath:[record valueForKey:@"backdrop_path"]];
//    [temp setMovieID:[[record valueForKey:@"id"] integerValue]];
//    [temp setOriginalTitle:[record valueForKey:@"original_title"]];
//    [temp setReleaseDate:[record valueForKey:@"release_date"]];
//    [temp setPosterPath:[record valueForKey:@"poster_path"]];
//    [temp setTitle:[record valueForKey:@"title"]];
//    [temp setVoteAverage:[[record valueForKey:@"vote_average"] doubleValue]];
//    [temp setVoteCount:[[record valueForKey:@"vote_count"] doubleValue]];
    
    return [NSString stringWithFormat:@"%@\n%d\n%@\n%@\n%@\n%@\n%f%d\n",
            self.backdropPath, self.movieID,
            self.originalTitle, self.releaseDate,
            self.posterPath, self.title,
            self.voteAverage, self.voteCount];
}

@end
