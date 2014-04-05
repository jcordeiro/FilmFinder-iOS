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

@synthesize  backdropPath;
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
                   @"%@%@%d%@%@", API_BASE_URL, @"genre/", 28,@"/movies?api_key=",API_KEY];
    
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
    
        NSLog(@"RUNNING! 3");
    
    
    
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:_responseData
                                                            options:0
                                                              error:NULL];
    
    NSString *key;
    for(key in results){
        NSLog(@"Key: %@, Value %@", key, [results objectForKey: key]);
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    NSLog(@"%@", error);
    
}

@end
