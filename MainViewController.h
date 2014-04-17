//
//  ViewController.h
//  FilmFinder
//
//  Created by Jonathan Cordeiro on 2014-04-04.
//  Copyright (c) 2014 Jonathan Cordeiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieBrain.h"
#import "Movie.h"

@interface MainViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UIButton *chooseGenreButton;
    IBOutlet UIButton *randomGenreButton;
    IBOutlet UIButton *viewFavouritesButton;

    MovieBrain *brain;
}

extern NSString * const CHOSEN_GENRE_SEGUE;
extern NSString * const RANDOM_GENRE_SEGUE;

@property (nonatomic, strong) IBOutlet UIPickerView *genrePicker;

// - (Movie *)fetchRandomMovie;

- (IBAction)chooseByGenrePressed:(id)sender;
- (IBAction)chooseByRandomGenrePressed:(id)sender;
- (IBAction)viewFavouritesPressed:(id)sender;

-(void)performsegueNotification:(NSNotification *) notif;





//@property (strong, nonatomic) MovieViewController *movieViewController;
//@property (strong, nonatomic) FavouritesViewController *favouritesViewController;

@end
