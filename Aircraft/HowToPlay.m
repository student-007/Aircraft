//
//  HowToPlay.m
//  Aircraft
//
//  Created by Yufei Lang on 12-4-16.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import "HowToPlay.h"

@interface HowToPlay()



@end

@implementation HowToPlay

@synthesize step_1 = _step_1;
@synthesize step_2 = _step_2;
@synthesize step_3 = _step_3;
@synthesize scrollView_HowToPlay = _scrollView_HowToPlay;
@synthesize pageControl = _pageControl;

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
    
    _step_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 336)];
    [_step_1 setImage:[UIImage imageNamed:@"step_1.png"]];
    _step_2 = [[UIImageView alloc]initWithFrame:CGRectMake(280, 0, 280, 336)];
    [_step_2 setImage:[UIImage imageNamed:@"step_2.png"]];
    _step_3 = [[UIImageView alloc]initWithFrame:CGRectMake(560, 0, 280, 336)];
    [_step_3 setImage:[UIImage imageNamed:@"step_3.png"]];    
    
    
    // set up scroll view [Yufei Lang 4/5/2012]
    _scrollView_HowToPlay.pagingEnabled = YES; // enable paging [Yufei Lang 4/5/2012]
    _scrollView_HowToPlay.showsHorizontalScrollIndicator = NO; // disable scroll indicator [Yufei Lang 4/5/2012]
    _scrollView_HowToPlay.showsVerticalScrollIndicator = NO;
    [_scrollView_HowToPlay setDelegate:self]; // set delegate to self in order to respond scroll actions [Yufei Lang 4/5/2012]
    _scrollView_HowToPlay.contentSize = CGSizeMake(_step_1.bounds.size.width * 3, 1);
    
    [_scrollView_HowToPlay addSubview:_step_1];    
    [_scrollView_HowToPlay addSubview:_step_2];
    [_scrollView_HowToPlay addSubview:_step_3];

    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // the following is to display those dots in the pageControl in a right place [Yufei Lang]
	CGFloat pageWidth = scrollView.frame.size.width;
    
    // when a page past half of it, it will be considered as next page (dot) [Yufei Lang]
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

- (void)changePage:(UIPageControl *)sender
{
	int page = sender.currentPage;
	
	// update the scroll view to the appropriate page, when user touch the pageController [Yufei Lang]
    CGRect rectFrame = _scrollView_HowToPlay.frame;
    rectFrame.origin.x = rectFrame.size.width * page;
    rectFrame.origin.y = 0;
    [_scrollView_HowToPlay scrollRectToVisible:rectFrame animated:YES];
}

- (void)viewDidUnload
{
    [self setScrollView_HowToPlay:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnClicked_GoBack:(UIButton *)sender 
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
