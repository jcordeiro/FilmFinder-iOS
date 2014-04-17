//
//  Movie.m
//  FilmFinder
//
//  Created by Jonathan Cordeiro on 2014-04-05.
//  Copyright (c) 2014 Jonathan Cordeiro. All rights reserved.
//

#import "Movie.h"

@implementation Movie

//NSString * const API_KEY = @"78ce6d1fe61708beb0815b4772f4be3e";
//NSString * const API_BASE_URL = @"https://api.themoviedb.org/3/";
//NSString * const POSTER_BASE_PATH = @"http://cf2.imgobject.com/t/p/original";

@synthesize backdropPath;
@synthesize movieID;
@synthesize originalTitle;
@synthesize releaseDate;
@synthesize posterPath;
@synthesize title;
@synthesize poster;
@synthesize voteAverage;
@synthesize voteCount;
@synthesize imdbID;
@synthesize overview;
@synthesize revenue;
@synthesize runtime;

/*

// Queries themoviedb's api to find random movies for a specific genre
// and returns the number of result pages there are in the JSON response
- (void)sendRequestForNbrOfPages:(int) genreCode
{
    NSLog(@"sendRequestForNbrOfPages");
    
    NSString *u = [NSString stringWithFormat:
                   @"%@%@%d%@%@", API_BASE_URL, @"genre/", genreCode, @"/movies?api_key=",API_KEY];
    
    NSURL *url = [NSURL URLWithString:u];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
    
    // USE A MOVIEDATACONNECTION AND SET THE PROPERTY TO
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// Parses a page of JSON results and returns a Movie object picked at random
-(Movie *)getRandomMovie
{
    NSLog(@"getRandomMovie");
    
    Movie *randomMovie = [[Movie alloc] init];
    
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
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// Parses through the JSON data for a movie's extra details and adds them to
// a movie object
- (Movie *)addExtraMovieDetailsToMovie:(Movie *)movie
{
    NSError *error = nil;
    
    NSArray *json = [NSJSONSerialization JSONObjectWithData:_responseData
                                                    options:kNilOptions
                                                      error:&error];
    
    [movie setOverview: [json valueForKey:@"overview"]];
    [movie setImdbID: [json valueForKey:@"imdb_id"]];
    [movie setRuntime: [[json valueForKey:@"runtime"] intValue]];
    
    
    
//    {
//        "adult": false,
//        "backdrop_path": "/4qfXT9BtxeFuamR4F49m2mpKQI1.jpg",
//        "belongs_to_collection": {
//            "backdrop_path": "/5sLmXNMGU8CedByJ7RBwZOy0pXr.jpg",
//            "id": 131295,
//            "name": "Captain America Collection",
//            "poster_path": "/933jisuZBkkIbS9Nrltaqdnc7Cn.jpg"
//        },
//        "budget": 170000000,
//        "genres": [
//                   {
//                       "id": 28,
//                       "name": "Action"
//                   },
//                   {
//                       "id": 12,
//                       "name": "Adventure"
//                   },
//                   {
//                       "id": 878,
//                       "name": "Science Fiction"
//                   }
//                   ],
//        "homepage": "http://www.captainamericathewintersoldiermovie.com",
//        "id": 100402,
//        "imdb_id": "tt1843866",
//        "original_title": "Captain America: The Winter Soldier",
//        "overview": "After the cataclysmic events in New York with The Avengers, Steve Rogers, aka Captain America is living quietly in Washington, D.C. and trying to adjust to the modern world. But when a S.H.I.E.L.D. colleague comes under attack, Steve becomes embroiled in a web of intrigue that threatens to put the world at risk. Joining forces with the Black Widow, Captain America struggles to expose the ever-widening conspiracy while fighting off professional assassins sent to silence him at every turn. When the full scope of the villainous plot is revealed, Captain America and the Black Widow enlist the help of a new ally, the Falcon. However, they soon find themselves up against an unexpected and formidable enemy\u2014the Winter Soldier.",
//        "popularity": 57.1482847536253,
//        "poster_path": "/pH4oeiZAh9a40tly4D0l6aAB3ms.jpg",
//        "production_companies": [
//                                 {
//                                     "id": 420,
//                                     "name": "Marvel Studios"
//                                 },
//                                 {
//                                     "id": 325,
//                                     "name": "Marvel Entertainment, LLC"
//                                 }
//                                 ],
//        "production_countries": [
//                                 {
//                                     "iso_3166_1": "US",
//                                     "name": "United States of America"
//                                 }
//                                 ],
//        "release_date": "2014-04-04",
//        "revenue": 0,
//        "runtime": 128,
//        "spoken_languages": [
//                             {
//                                 "iso_639_1": "en",
//                                 "name": "English"
//                             }
//                             ],
//        "status": "Released",
//        "tagline": "In heroes we trust.",
//        "title": "Captain America: The Winter Soldier",
//        "vote_average": 7.0,
//        "vote_count": 128
//    }
    
    return movie;
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
    //    int totalPages = [[json objectAtIndex:3] intValue];
    //    int randomPage = 1 + arc4random() % (1 - totalPages);
    
    
    
    
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
    int nbrOfPages = [self getNbrOfResultPages];
    
    // Make a reqest to get a random Movie object from a random page
    // of the JSON results
    Movie *random = [self getRandomMovie];
    
//    [self sendRequestForMoreMovieDetails:random];
    
    
    
    // Parse through a pa
//    [self parseJSONMovies:nbrOfPages forGenre:genreCode];
    
    
    
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



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    NSLog(@"%@", error);
    
}
 */

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
    
    return [NSString stringWithFormat:@"%@\n%d\n%@\n%@\n%@\n%@\n%f%d\n%@\n%d",
            self.backdropPath, self.movieID,
            self.originalTitle, self.releaseDate,
            self.posterPath, self.title,
            self.voteAverage, self.voteCount,
            self.overview, self.runtime];
}

@end
