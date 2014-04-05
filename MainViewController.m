//
//  ViewController.m
//  FilmFinder
//
//  Created by Jonathan Cordeiro on 2014-04-04.
//  Copyright (c) 2014 Jonathan Cordeiro. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize genrePicker;

- (MovieBrain *)brain
{
    if (!brain) // ensure that brain doesn't already exist
    {
        // Allocate and initialize the QuizBrain
        brain = [[MovieBrain alloc] init];
        
        // Fill the brain's team genres from the plist
//        [brain fillBrain];
    }
    return brain;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[self brain] fillBrain];
    
    // Have the picker start a few rows in so the values are centered
    [genrePicker selectRow:3 inComponent:0 animated:YES];
    
    movie = [[Movie alloc] init];
    
    [movie getMovieDetails];
    
    
    // Create the Blue View...
//    self.rootViewController = [[BIDBlueViewController alloc]
//                               initWithNibName:@"BlueView" bundle:nil];
//    
//    // and insert it into the view!
//    [self.view insertSubview:self.blueViewController.view atIndex:0];
//    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//START

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
