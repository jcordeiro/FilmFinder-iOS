//
//  MovieViewController.m
//  FilmFinder
//
//  Created by Jonathan Cordeiro on 2014-04-04.
//  Copyright (c) 2014 Jonathan Cordeiro. All rights reserved.
//

#import "MovieViewController.h"

@interface MovieViewController ()

@end

@implementation MovieViewController

@synthesize movie;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [scroller setScrollEnabled:YES];
  //  [scroller setContentSize:CGSizeMake(320, 900)];
    
  [movieTitle setText:[movie title]];
    
   //  [movieTitle setText:@"The Social Network"];
    
      NSLog(@"mvc movie: %@", movie);
    
    // FIX SCROLL VIEW HEIGHT HERE!
    
//    CGRect contentRect = CGRectZero;
//    for (UIView *view in scroller.subviews) {
//        contentRect = CGRectUnion(contentRect, view.frame);
//    }
//    scroller.contentSize = contentRect.size;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
