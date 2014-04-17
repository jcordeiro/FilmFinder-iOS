//
//  ViewController.m
//  FilmFinder
//
//  Created by Jonathan Cordeiro on 2014-04-04.
//  Copyright (c) 2014 Jonathan Cordeiro. All rights reserved.
//

#import "MainViewController.h"
#import "MovieViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController


// Constants for segue identifiers
NSString * const CHOSEN_GENRE_SEGUE = @"chosenGenreSegue";
NSString * const RANDOM_GENRE_SEGUE = @"randomGenreSegue";

@synthesize genrePicker;

- (MovieBrain *)brain
{
    if (!brain) // ensure that brain doesn't already exist
    {
        // Allocate and initialize the MovieBrain
        brain = [[MovieBrain alloc] init];
    }
    return brain;
}

-(void)performsegueNotification:(NSNotification *) notif
{
    
    //[self performSegueWithIdentifier:CHOSEN_GENRE_SEGUE sender:self];
    
//    MovieViewController *viewController = [[MovieViewController alloc] init];
    
//    MovieViewController *viewController = [[MovieViewController alloc] initWithNibName:@"MovieViewController" bundle:nil];
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    
    MovieViewController* viewController = [sb instantiateViewControllerWithIdentifier:@"MovieViewController"];
//    
    // Give the MovieViewController the random movie stored in the MovieBrain
    [viewController setMovie:[[self brain] getStaticMovieVariable]];
    
    // Push it onto the navigation controller stack
    [self.navigationController
    pushViewController:viewController animated:YES];
    
    
}

//- (Movie *)fetchRandomMovie
//{
//    Movie *movie = [[Movie alloc] init];
//    
//     int genreCode = 28;
//    
//    [[self brain] sendRequestForNbrOfPages:genreCode];
//    
// //   [[self brain] sendRequestForRandomPage:2 forGenre:genreCode];
//    
// //   [[self brain] sendRequestForMoreMovieDetails:movie];
//    
//    NSLog(@"MainViewController Movie: \n%@", movie);
//    
//    return movie;
//}

- (IBAction)chooseByGenrePressed:(id)sender
{
    
    int genreCode = 28;
    
    

    [[self brain] startRequestsForMovie:28];
    
    
//    [self performSegueWithIdentifier:CHOSEN_GENRE_SEGUE sender:self];
    
//    [[self brain] sendRequestForNbrOfPages:genreCode];
    
//    NSLog(@"Random: \n%@", random);
    
    
//    UIViewController *viewController = ...;
    
//      MovieViewController *movieViewController = [MovieViewController ]
    
//    [self.navigationController
//    pushViewController:viewController animated:YES];
    
}

- (IBAction)chooseByRandomGenrePressed:(id)sender
{
    
    
}

- (IBAction)viewFavouritesPressed:(id)sender
{
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Fill the brain with genre information from the plist file
    [[self brain] fillBrain];
    
    // Have the picker start a few rows in so the values are centered
    [genrePicker selectRow:3 inComponent:0 animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performsegueNotification:)
                                                 name:@"movie fetched"
                                               object:nil];
    
    
    
    
//    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    
//    activityView.center=self.view.center;
//    
//    [activityView startAnimating];
//    
//    [self.view addSubview:activityView];
//    
//    [activityIndicator release];
    
  
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:CHOSEN_GENRE_SEGUE]) {
        
        MovieViewController *destViewController = segue.destinationViewController;
        
        
        
        // Run a loop here to wait and keep checking if MovieBrain
        // has finished fetching the movie details and stored them in
        // its static movie variable
        if (![[self brain] isFinishedFetchingMovie]) {
            
            // Check if it's finished
      //      if ([[self brain] isFinishedFetchingMovie]) {
                // pass the MovieBrain's randomMovie to the MovieViewController
                destViewController.movie = [[self brain] getStaticMovieVariable];
            
                [destViewController setMovie:[[self brain] getStaticMovieVariable]];

        //    }
            
        }
        
       
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//START picker methods

// returns the # of rows in each component..
-(NSInteger) pickerView: (UIPickerView*) pickerView
numberOfRowsInComponent: (NSInteger) component {
    return [[brain genres] count];
}

// returns the number of 'columns' to display.
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
 return (NSString*) [[brain genres] objectAtIndex: row];
}

// Runs when picker item is selected
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    NSLog(@"You selected %@", [[[self brain] genres] objectAtIndex:row]);
}
//END

@end
