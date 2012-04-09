//
//  PlayViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 12-4-6.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import "PlayViewController.h"

#define NUMBER_OF_PAGE_IN_SCROLLVIEW 2

@implementation PlayViewController
@synthesize scrollView_BattleField = _scrollView_BattleField;
@synthesize view_AircraftHolder = _view_AircraftHolder;
@synthesize view_ToolsHolder = _view_ToolsHolder;
@synthesize view_ChatFeild = _view_ChatFeild;
@synthesize view_MyBattleField = _view_MyBattleField;
@synthesize view_EnemyBattleField = _view_EnemyBattleField;
@synthesize imgView_AircraftUp = _imgView_AircraftUp;
@synthesize imgView_AircraftDown = _imgView_AircraftDown;
@synthesize imgView_AircraftLeft = _imgView_AircraftLeft;
@synthesize imgView_AircraftRight = _imgView_AircraftRight;
@synthesize imgView_MyBattleFieldBackground = _imgView_MyBattleFieldBackground;
@synthesize imgView_EnemyBattleFieldBackground = _imgView_EnemyBattleFieldBackground;
@synthesize arryImgView_PlacedAircrafts = _arryImgView_PlacedAircrafts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isAircraftHolderShowing = YES;// AircraftHolder is Showing at the beginning [Yufei Lang 4/5/2012]
        _isPlacingAircraftsReady = NO;
        _iNumberOfAircraftsPlaced = 0;
        _arryImgView_PlacedAircrafts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initAllViews
{
    // set up scroll view [Yufei Lang 4/5/2012]
    _scrollView_BattleField.pagingEnabled = YES; // enable paging [Yufei Lang 4/5/2012]
    _scrollView_BattleField.showsHorizontalScrollIndicator = NO; // disable scroll indicator [Yufei Lang 4/5/2012]
    _scrollView_BattleField.showsVerticalScrollIndicator = NO;
    [_scrollView_BattleField setDelegate:self]; // set delegate to self in order to respond scroll actions [Yufei Lang 4/5/2012]
    _scrollView_BattleField.contentSize = CGSizeMake(_view_MyBattleField.bounds.size.width + _view_EnemyBattleField.bounds.size.width, 1);
    [self loadPage:_view_MyBattleField toScrollView:_scrollView_BattleField]; // load my/enemy field into scroll view [Yufei Lang 4/5/2012]
    [self loadPage:_view_EnemyBattleField toScrollView:_scrollView_BattleField];
    [self.view addSubview:_scrollView_BattleField];
    
    // load images into aircraft holders [Yufei Lang 4/5/2012]
    [_imgView_AircraftUp setImage:[UIImage imageNamed:@"Aircraft.png"]];
    [_imgView_AircraftDown setImage:[UIImage imageNamed:@"Aircraft.png"]];
    [_imgView_AircraftLeft setImage:[UIImage imageNamed:@"Aircraft.png"]];
    [_imgView_AircraftRight setImage:[UIImage imageNamed:@"Aircraft.png"]];
    // rotation [Yufei Lang 4/5/2012]
    _imgView_AircraftRight.transform = CGAffineTransformMakeRotation(M_PI_2);
    _imgView_AircraftDown.transform = CGAffineTransformMakeRotation(M_PI);
    _imgView_AircraftLeft.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    // load image to battle field background [Yufei Lang 4/6/2012]
    [_imgView_MyBattleFieldBackground setImage:[UIImage imageNamed:@"blueSky"]];
    [_imgView_EnemyBattleFieldBackground setImage:[UIImage imageNamed:@"blueSky"]];
    
    // init two battle fields with buttons [Yufei Lang 4/6/2012]
    //[self initGridInBattleFieldView:_view_MyBattleField];
    [self initGridInBattleFieldView:_view_EnemyBattleField];

}

- (void)initGridInBattleFieldView:(UIView *)viewBattleField
{
    for (int row = 0; row < 10; row++) 
        for (int col = 0; col < 10; col++) 
        {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(col * 29, row * 29, 29, 29)];
            btn.contentEdgeInsets = UIEdgeInsetsMake(3.5, 1.5, 0.0, 0.0);
            //[btn setTitle:@"\ue21a" forState:UIControlStateNormal];
            //[btn setTitle:[NSString stringWithFormat:@"%i%i", row, col] forState:UIControlStateNormal];
            [btn addTarget:nil action:@selector(btnClicked_OnBattleGrid:) forControlEvents:UIControlEventTouchUpInside];
            [viewBattleField addSubview:btn];
        }
    
}

- (void)loadPage: (UIView *)viewPage toScrollView: (UIScrollView *) scrollView
{
    int iPageCount = scrollView.subviews.count;
    viewPage.frame = CGRectMake(viewPage.bounds.size.width * iPageCount, 0, viewPage.bounds.size.width, viewPage.bounds.size.height);
    [_scrollView_BattleField addSubview:viewPage];
}


#pragma mark TapDetectingImageViewDelegate methods
//#warning useless gesture recognizer
//- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
//    NSLog(@"gesture recognizer worked!");
//}

#pragma touches actions

- (void)delegateTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touched_delegate");
    
    // pass what i selected view to _tempAircraftView in order to move and end touch actions [Yufei Lang 4/6/2012]
    UITouch *touch = [touches anyObject];
    _tempAircraftView = (TapDetectingImageView*)touch.view;
    
    // disable scroll view's scrolling availability [Yufei Lang 4/6/2012]
    _scrollView_BattleField.scrollEnabled = NO;
    
    [self touchesBegan:touches withEvent:event];
}

- (void)delegateTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch moved_delegate");
    [self touchesMoved:touches withEvent:event];
}

- (void)delegateTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // able scroll view's scrolling availability [Yufei Lang 4/6/2012]
    _scrollView_BattleField.scrollEnabled = YES;
    NSLog(@"touch ended_delegate");
    [self touchesEnded:touches withEvent:event];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch != NULL && touch.view == _tempAircraftView) 
    {
        // set up a new animation block [Yufei Lang 4/5/2012]
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        
        // adjust views (animation) [Yufei Lang 4/5/2012]
        _tempAircraftView.alpha = 0.7;
        CGPoint currentPoint = [touch locationInView:self.view];
        currentPoint.y -= _tempAircraftView.frame.size.height / 2.0;;
        _tempAircraftView.center = currentPoint;
        
        // end and commit animation [Yufei Lang 4/5/2012]
        [UIView commitAnimations];
    }
    touch = [[event touchesForView:_view_AircraftHolder] anyObject];
    if (touch != NULL && [touch locationInView:touch.view].x < (50 * 4)) // act only when touches aircrafts [Yufei Lang 4/6/2012]
    {
        _tempAircraftView = [[TapDetectingImageView alloc] initWithImage:[UIImage imageNamed:@"Aircraft.png"]];
        int iIndexOfSubview = [touch locationInView:_view_AircraftHolder].x / 50;
        if (iIndexOfSubview >= 4) return; // in case of "done" button disabled tapping done button area will act[Yufei Lang 4/6/2012]
        switch (iIndexOfSubview) {
            case 1:
            {
                CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI);
                _tempAircraftView.transform = rotate;
            }
                break;
            case 2:
            {
                CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI_2);
                _tempAircraftView.transform = rotate;
            }
                break;
            case 3:
            {
                CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI_2);
                _tempAircraftView.transform = rotate;
            }
                break;
            default:
                break;
        }
        UIImageView *imgView = [touch.view.subviews objectAtIndex:iIndexOfSubview];
        [_tempAircraftView setFrame:CGRectMake(imgView.frame.origin.x, 
                                               [touch locationInView:self.view].y, 
                                               imgView.frame.size.width, 
                                               imgView.frame.size.height)];
        _tempAircraftView.alpha = 0; // make it invisible first [Yufei Lang 4/5/2012]
        [self.view addSubview:_tempAircraftView];
        // set up a new animation block [Yufei Lang 4/5/2012]
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        
        // adjust views (animation) [Yufei Lang 4/5/2012]
        _tempAircraftView.alpha = 0.7;
        [_tempAircraftView setFrame:CGRectMake([touch locationInView:self.view].x - 2.9 * imgView.frame.size.width / 2, 
                                               ([touch locationInView:self.view].y - 2.9 * imgView.frame.size.height), 
                                               2.9 * imgView.frame.size.width, 
                                               2.9 * imgView.frame.size.height)];
        
        // end and commit animation [Yufei Lang 4/5/2012]
        [UIView commitAnimations];
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:_view_AircraftHolder] anyObject];
    if (touch != NULL) {
        CGPoint currentPoint = [touch locationInView:self.view];
        currentPoint.y -= _tempAircraftView.frame.size.height / 2.0;;
        _tempAircraftView.center = currentPoint;
    }
    touch = [[event touchesForView:_tempAircraftView] anyObject];
    if (touch != NULL) 
    {
        CGPoint currentPoint = [touch locationInView:self.view];
        currentPoint.y -= _tempAircraftView.frame.size.height / 2.0;;
        _tempAircraftView.center = currentPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // when placing a new aircraft [Yufei Lang 4/6/2012]
    UITouch *touch = [[event touchesForView:_view_AircraftHolder] anyObject];
    if (touch != NULL) 
    {
        CGPoint targetPoint = [touch locationInView:self.view];
        int iX = (targetPoint.x - _tempAircraftView.frame.size.width / 2) / 29;
        int iY = (targetPoint.y - _tempAircraftView.frame.size.height) / 29;
        if ((int)(targetPoint.x - _tempAircraftView.frame.size.width / 2) % 29 >= 29 / 2)
            iX += 1;
        if ((int)(targetPoint.y - _tempAircraftView.frame.size.height) % 29 >= 29 / 2)
            iY += 1;
        [_tempAircraftView removeFromSuperview];
        if (_iNumberOfAircraftsPlaced < 3) // if all the aircrafts have been placed then stopping putting it in my battle view [Yufei Lang 4/6/2012]
        {
//#warning useless gesture recognizer
//            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//            [_tempAircraftView addGestureRecognizer:singleTap];
            _tempAircraftView.delegate = self;
//            [_arryImgView_PlacedAircrafts addObject:_tempAircraftView];
            [_view_MyBattleField addSubview:_tempAircraftView];
            [_tempAircraftView setFrame:CGRectMake(iX * 29, iY * 29, _tempAircraftView.frame.size.width, _tempAircraftView.frame.size.height)];
            _iNumberOfAircraftsPlaced++;
        }
    }
    
    // when adjusting placed aircraft position [Yufei Lang 4/6/2012]
    touch = [[event touchesForView:_tempAircraftView] anyObject];
    if (touch != NULL) 
    {
        CGPoint targetPoint = [touch locationInView:self.view];
        int iX = (targetPoint.x - _tempAircraftView.frame.size.width / 2) / 29;
        int iY = (targetPoint.y - _tempAircraftView.frame.size.height) / 29;
        if ((int)(targetPoint.x - _tempAircraftView.frame.size.width / 2) % 29 >= 29 / 2)
            iX += 1;
        if ((int)(targetPoint.y - _tempAircraftView.frame.size.height) % 29 >= 29 / 2)
            iY += 1;
        [_tempAircraftView setFrame:CGRectMake(iX * 29, iY * 29, _tempAircraftView.frame.size.width, _tempAircraftView.frame.size.height)];
    }
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
    
    [self initAllViews];
//    CSocketConnection *socketConn = [[CSocketConnection alloc] init];
//    [socketConn makeConnection];
    
}

- (void)viewDidUnload
{
    [self setScrollView_BattleField:nil];
    [self setView_AircraftHolder:nil];
    [self setView_ToolsHolder:nil];
    [self setView_ChatFeild:nil];
    [self setImgView_AircraftUp:nil];
    [self setImgView_AircraftDown:nil];
    [self setImgView_AircraftLeft:nil];
    [self setImgView_AircraftRight:nil];
    [self setView_MyBattleField:nil];
    [self setView_EnemyBattleField:nil];
    [self setImgView_MyBattleFieldBackground:nil];
    [self setImgView_EnemyBattleFieldBackground:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

// slide in to enemy field [Yufei Lang 4/5/2012]
- (IBAction)btnClicked_GoToEnemyField:(id)sender {
    [_scrollView_BattleField scrollRectToVisible:CGRectMake(_view_MyBattleField.bounds.size.width, 0, 
                                                            _view_EnemyBattleField.bounds.size.width, 
                                                            _view_EnemyBattleField.bounds.size.height) animated:YES];
}

// slide in to my field [Yufei Lang 4/5/2012]
- (IBAction)btnClick_GoToMyField:(id)sender {
    [_scrollView_BattleField scrollRectToVisible:CGRectMake(0, 0, 
                                                            _view_MyBattleField.bounds.size.width, 
                                                            _view_MyBattleField.bounds.size.height) animated:YES];
}

// pop my self, back to master view controller [Yufei Lang 4/5/2012]
- (IBAction)btnClicked_OnExit:(id)sender {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

// hide _view_AircraftHolder and show _view_ToosHolder after placing aircrafts [Yufei Lang 4/5/2012]
- (IBAction)btnClicked_DonePlacingAircraft:(UIButton *)sender 
{   
//    if (sender != nil) {
//            sender.enabled = NO;
#warning make the button looks like disabled here
//        }
    if (_isPlacingAircraftsReady == NO)
    {
        _isPlacingAircraftsReady = YES;
        
        // set up a new animation block [Yufei Lang 4/5/2012]
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        
        // adjust views (animation) [Yufei Lang 4/5/2012]
        //_view_AircraftHolder.alpha = 0;
        [_view_AircraftHolder setFrame:CGRectMake(0, _view_AircraftHolder.frame.origin.y - 50.0, 320, 50)];
        
        //_view_ToolsHolder.alpha = 1.0;
        [_view_ToolsHolder setFrame:CGRectMake(0, _view_ToolsHolder.frame.origin.y - 50.0, 320, 50)];
        
        if (_view_ChatFeild.frame.origin.y != 340)
            [_view_ChatFeild setFrame:CGRectMake(0, _view_ChatFeild.frame.origin.y - 50.0, 320, 50)];
        
        // end and commit animation [Yufei Lang 4/5/2012]
        [UIView commitAnimations];
    }
}

- (IBAction)btnClicked_ShowHideAircraftHolder:(id)sender 
{
    if (_isAircraftHolderShowing) 
    {        
        _isAircraftHolderShowing = NO;
        // set up a new animation block [Yufei Lang 4/5/2012]
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        
        // adjust views (animation) [Yufei Lang 4/5/2012]
        //_view_AircraftHolder.alpha = 1.0;
        [_view_AircraftHolder setFrame:CGRectMake(0, _view_AircraftHolder.frame.origin.y + 50.0, 320, 50)];
        
        //_view_ToolsHolder.alpha = 0;
        [_view_ToolsHolder setFrame:CGRectMake(0, _view_ToolsHolder.frame.origin.y + 50.0, 320, 50)];
        
        [_view_ChatFeild setFrame:CGRectMake(0, _view_ChatFeild.frame.origin.y + 50.0, 320, 50)];
        
        // end and commit animation [Yufei Lang 4/5/2012]
        [UIView commitAnimations];
    } 
    else 
    {
        _isAircraftHolderShowing = YES;
        _isPlacingAircraftsReady = NO; // in order to let method btnClicked_DonePlacingAircraft hide view, set NO [Yufei Lang 4/6/2012]
        [self btnClicked_DonePlacingAircraft:nil];
    }
}

- (IBAction)btnClicked_OnBattleGrid:(UIButton*)sender 
{
    NSLog(@"btnClicked. btn frame: %@", NSStringFromCGRect(sender.frame));
}

@end
