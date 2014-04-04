//
//  ViewController.h
//  FilmFinder
//
//  Created by Jonathan Cordeiro on 2014-04-04.
//  Copyright (c) 2014 Jonathan Cordeiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieBrain.h"

@interface MainViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UIButton *chooseGenreButton;
    IBOutlet UIButton *randomGenreButton;
    IBOutlet UIButton *viewFavouritesButton;

    MovieBrain *brain;
}

@property (nonatomic, strong) IBOutlet UIPickerView *genrePicker;


//@property (strong, nonatomic) MovieViewController *movieViewController;
//@property (strong, nonatomic) FavouritesViewController *favouritesViewController;

@end
