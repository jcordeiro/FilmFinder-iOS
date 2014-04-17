//
//  MovieDataConnection.h
//  FilmFinder
//
//  Created by Jonathan Cordeiro on 2014-04-14.
//  Copyright (c) 2014 Jonathan Cordeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieDataConnection : NSURLConnection

@property (nonatomic, copy) NSString *connectionType;

@end
