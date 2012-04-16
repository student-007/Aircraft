//
//  HowToPlay.m
//  Aircraft
//
//  Created by Yufei Lang on 12-4-16.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import "HowToPlay.h"

@implementation HowToPlay

@synthesize step_1 = _step_1;
@synthesize step_2 = _step_2;
@synthesize step_3 = _step_3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    _step_1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:<#(NSString *)#>]];
//    _step_2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:<#(NSString *)#>]];
//    _step_3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:<#(NSString *)#>]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
