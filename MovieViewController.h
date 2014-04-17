//
//  MovieViewController.h
//  FilmFinder
//
//  Created by Jonathan Cordeiro on 2014-04-04.
//  Copyright (c) 2014 Jonathan Cordeiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieBrain.h"
#import "Movie.h"

@interface MovieViewController : UIViewController
{    
    IBOutlet UIScrollView *scroller;
    
    IBOutlet UILabel *movieTitle;
    IBOutlet UIImageView *poster;
    IBOutlet UILabel *releaseDate;
    IBOutlet UILabel *runningTime;
    IBOutlet UILabel *imdbScore;
    IBOutlet UIButton *viewTrailerButton;
    IBOutlet UILabel *overview;
}

@property (nonatomic, strong) Movie *movie;

@end
