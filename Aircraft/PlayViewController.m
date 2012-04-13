//
//  PlayViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 12-4-6.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import "PlayViewController.h"

#define NUMBER_OF_PAGE_IN_SCROLLVIEW    2

#define MSG_FLAG_STATUS                 @"status"
#define MSG_FLAG_CHAT                   @"chat"
#define MSG_FLAG_END_GAME               @"endGame"
#define MSG_FLAG_ATTACK                 @"attack"
#define MSG_FLAG_ATTACK_RESULT          @"attackResult"

#define MSG_FLAG_STATUS_WAITING         @"waiting for competitor"
#define MSG_FLAG_STATUS_PAIRED          @"found your competitor"
#define MSG_FLAG_STATUS_COMPTOR_READY   @"your competitor is ready"

#define MSG_ATTACK_DETAIL_MISS          @"miss"
#define MSG_ATTACK_DETAIL_HIT           @"hit"
#define MSG_ATTACK_DETAIL_DIE           @"die"

#define ATTACK_MISS                     @"\ue049" // cloud, means nothing there [Yufei Lang 4/12/2012]
#define ATTACK_HIT                      @"\ue332" // empty circle, means hit but not hit the head which is still alive [Yufei Lang 4/12/2012]
#define ATTACK_DIE                      @"\ue219" // solid circle, means dead [Yufei Lang 4/12/2012]

#define MSG_END_GAME_YOU_WON            @"you won"
#define MSG_END_GAME_YOU_LOST           @"you lost"

@interface PlayViewController()
- (void)sendTextView: (UITextView *)textView Message: (NSString *)strMessage AsCharacter: (NSString *)character;
- (void)initGridInBattleFieldView:(UIView *)viewBattleField WithButtonsWillBeStoredInArray: (NSMutableArray *) arry2D_Buttons;
- (void)initGridInBattleFieldView:(UIView *)viewBattleField WithLabelsWillBeStoredInArray: (NSMutableArray *) arry2D_Buttons;
@end

@implementation PlayViewController
@synthesize arryCharacterString = _arryCharacterString;
@synthesize arryMyBattleFieldLabels = _arryMyBattleFieldLabels;
@synthesize arryEmenyBattleFieldButtons = _arryEmenyBattleFieldButtons;
@synthesize textView_InfoView = _textView_InfoView;
@synthesize txtField_ChatTextBox = _txtField_ChatTextBox;
@synthesize scrollView_BattleField = _scrollView_BattleField;
@synthesize socketConn = _socketConn;
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
@synthesize progressHud = _progressHud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isAircraftHolderShowing = YES;// AircraftHolder is Showing at the beginning [Yufei Lang 4/5/2012]
        _isPlacingAircraftsReady = NO;
        _isCompetitorReady = NO;
        _isGettingPaired = NO;
        _iNumberOfAircraftsPlaced = 0;
        _arryMyBattleFieldLabels = [[NSMutableArray alloc] init];
        _arryEmenyBattleFieldButtons = [[NSMutableArray alloc] init];
        _arryCharacterString = [[NSArray alloc] initWithObjects:@"Adjutant", @"Me", @"Competitor", nil];
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
    // rotation & set 2d int array within the image view [Yufei Lang 4/5/2012]
    [_imgView_AircraftUp setAircraftWithDirection:Up];
    [_imgView_AircraftDown setAircraftWithDirection:Down];
    [_imgView_AircraftRight setAircraftWithDirection:Right];
    [_imgView_AircraftLeft setAircraftWithDirection:Left];
    // release CGMutablePathRef in the images [Yufei Lang 4/10/2012]
    [_imgView_AircraftUp aircraftPlaced];
    [_imgView_AircraftDown aircraftPlaced];
    [_imgView_AircraftLeft aircraftPlaced];
    [_imgView_AircraftRight aircraftPlaced];
    
    // load image to battle field background [Yufei Lang 4/6/2012]
    [_imgView_MyBattleFieldBackground setImage:[UIImage imageNamed:@"blueSky"]];
    [_imgView_EnemyBattleFieldBackground setImage:[UIImage imageNamed:@"blueSky"]];
    
    // init two battle fields with buttons [Yufei Lang 4/6/2012]
    [self initGridInBattleFieldView:_view_MyBattleField WithLabelsWillBeStoredInArray:_arryMyBattleFieldLabels];
    [self initGridInBattleFieldView:_view_EnemyBattleField WithButtonsWillBeStoredInArray:_arryEmenyBattleFieldButtons];

}

- (void)initGridInBattleFieldView:(UIView *)viewBattleField WithButtonsWillBeStoredInArray: (NSMutableArray *) arry2D_Buttons
{
    // these loops will create 100 buttons fill the battle field [Yufei Lang 3/12/2012]
    // it will also create a 2D array which is a member of self called _arry??BattleFieldButtons[Yufei Lang 3/12/2012]
    // so when recv the attack msg, we can update the text lable within the buttons [Yufei Lang 3/12/2012]
    for (int row = 0; row < 10; row++) 
    {
        NSMutableArray *arryButtonsInRow = [[NSMutableArray alloc] init];
        for (int col = 0; col < 10; col++) 
        {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(col * 29, row * 29, 29, 29)];
            // this will make sure emoji icon apears in the centre of the buttons [Yufei Lang 4/12/2012]
            btn.contentEdgeInsets = UIEdgeInsetsMake(3.5, 1.5, 0.0, 0.0);
            [btn addTarget:nil action:@selector(btnClicked_OnBattleGrid:) forControlEvents:UIControlEventTouchUpInside];
            [arryButtonsInRow addObject:btn];
            [viewBattleField addSubview:btn];
        }
        [arry2D_Buttons addObject:arryButtonsInRow];
    }
}

- (void)initGridInBattleFieldView:(UIView *)viewBattleField WithLabelsWillBeStoredInArray: (NSMutableArray *) arry2D_Lables
{
    // these loops will create 100 labels fill the battle field [Yufei Lang 3/12/2012]
    // it will also create a 2D array which is a member of self called _arry??BattleFieldButtons[Yufei Lang 3/12/2012]
    // so when recv the attack msg, we can update the text lable within the labels [Yufei Lang 3/12/2012]
    for (int row = 0; row < 10; row++) 
    {
        NSMutableArray *arryLabelsInRow = [[NSMutableArray alloc] init];
        for (int col = 0; col < 10; col++) 
        {
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(col * 29, row * 29, 29, 29)];
            lbl.textAlignment = UITextAlignmentCenter;
            lbl.backgroundColor = [UIColor clearColor];
            [arryLabelsInRow addObject:lbl];
            [viewBattleField addSubview:lbl];
        }
        [arry2D_Lables addObject:arryLabelsInRow];
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
    // if all set which mean the "done" button has been clicked, then do not allow adjust aircraft's position [Yufei Lang 4/10/2012]
    if (!_isPlacingAircraftsReady)
    {
        NSLog(@"touched_delegate");
        // pass what i selected view to _tempAircraftView in order to move and end touch actions [Yufei Lang 4/6/2012]
        UITouch *touch = [touches anyObject];
        _tempAircraftView = (TapDetectingImageView*)touch.view;
        
        // disable scroll view's scrolling availability [Yufei Lang 4/6/2012]
        _scrollView_BattleField.scrollEnabled = NO;
        
        [self touchesBegan:touches withEvent:event];
    }
}

- (void)delegateTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // if all set which mean the "done" button has been clicked, then do not allow adjust aircraft's position [Yufei Lang 4/10/2012]
    if (!_isPlacingAircraftsReady)
    {
        [self touchesMoved:touches withEvent:event];
        NSLog(@"touch moved_delegate");
    }
}

- (void)delegateTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // if all set which mean the "done" button has been clicked, then do not allow adjust aircraft's position [Yufei Lang 4/10/2012]
    if (!_isPlacingAircraftsReady)
    {
        // able scroll view's scrolling availability [Yufei Lang 4/6/2012]
        _scrollView_BattleField.scrollEnabled = YES;
        NSLog(@"touch ended_delegate");
        [self touchesEnded:touches withEvent:event];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // hide keyboard [Yufei Lang 4/10/2012]
    [_txtField_ChatTextBox resignFirstResponder];
    
    // when replacing an aircraft [Yufei Lang 4/10/2012]
    UITouch *touch = [touches anyObject];
    if (touch != NULL && touch.view == _tempAircraftView) 
    {
        // record the original frame [Yufei Lang 4/10/2012]
        _tempFrame = _tempAircraftView.frame;
        
        // remove any grid (numbers) that aircraft used to hold [Yufei Lang 4/10/2012]
        [self removeAircraft:_tempAircraftView withOldFrame:_tempFrame fromGrid:_myGrid];
        
        // set up a new animation block [Yufei Lang 4/5/2012]
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        
        // adjust views (animation) [Yufei Lang 4/5/2012]
        _tempAircraftView.alpha = 0.7;
        CGPoint currentPoint = [touch locationInView:self.view];
        //currentPoint.y -= _tempAircraftView.frame.size.height / 2.0;;
        _tempAircraftView.center = currentPoint;
        
        // end and commit animation [Yufei Lang 4/5/2012]
        [UIView commitAnimations];
    }
    
    // when add new aircraft [Yufei Lang 4/10/2012]
    touch = [[event touchesForView:_view_AircraftHolder] anyObject];
    if (touch != NULL && [touch locationInView:touch.view].x < (50 * 4)) // act only when touches aircrafts [Yufei Lang 4/6/2012]
    {
        _tempAircraftView = [[TapDetectingImageView alloc] initWithImage:[UIImage imageNamed:@"Aircraft.png"]];
        int iIndexOfSubview = [touch locationInView:_view_AircraftHolder].x / 50;
        if (iIndexOfSubview >= 4) return; // in case of "done" button disabled tapping done button area will act[Yufei Lang 4/6/2012]
        switch (iIndexOfSubview) {
            case 0:
            {
                [_tempAircraftView setAircraftWithDirection:Up];
            }
                break;
            case 1:
            {
                [_tempAircraftView setAircraftWithDirection:Down];
            }
                break;
            case 2:
            {
                [_tempAircraftView setAircraftWithDirection:Left];
            }
                break;
            case 3:
            {
                [_tempAircraftView setAircraftWithDirection:Right];
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
        // record the original frame [Yufei Lang 4/10/2012]
        _tempFrame = _tempAircraftView.frame;
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
    // when draging an aircraft from aircraft holder into battle field [Yufei Lang 4/5/2012]
    UITouch *touch = [[event touchesForView:_view_AircraftHolder] anyObject];
    if (touch != NULL) {
        CGPoint currentPoint = [touch locationInView:self.view];
        currentPoint.y -= _tempAircraftView.frame.size.height / 2.0;
        _tempAircraftView.center = currentPoint;
    }
    
    // when replacing an aircraft already in battle field [Yufei Lang 4/10/2012]
    touch = [[event touchesForView:_tempAircraftView] anyObject];
    if (touch != NULL) 
    {
        CGPoint currentPoint = [touch locationInView:self.view];
        //currentPoint.y -= _tempAircraftView.frame.size.height / 2.0; // in case moving down [Yufei Lang 4/9/2012]
        _tempAircraftView.center = currentPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // when placing a new aircraft [Yufei Lang 4/6/2012]
    UITouch *touch = [[event touchesForView:_view_AircraftHolder] anyObject];
    
    if (touch != NULL) 
    {
        if (_tempAircraftView.frame.origin.x >= -5 && _tempAircraftView.frame.origin.y >= -5 && 
            _tempAircraftView.frame.origin.x + _tempAircraftView.frame.size.width <= 295 &&
            _tempAircraftView.frame.origin.y + _tempAircraftView.frame.size.height <= 295)
        {
            CGPoint targetPoint = [touch locationInView:self.view];
            int iX = (targetPoint.x - _tempAircraftView.frame.size.width / 2) / 29;
            int iY = (targetPoint.y - _tempAircraftView.frame.size.height) / 29;
            if ((int)(targetPoint.x - _tempAircraftView.frame.size.width / 2) % 29 >= 29 / 2)
                iX += 1;
            if ((int)(targetPoint.y - _tempAircraftView.frame.size.height) % 29 >= 29 / 2)
                iY += 1;
            [_tempAircraftView removeFromSuperview];
            // if all the aircrafts have been placed then stopping putting it in my battle view [Yufei Lang 4/6/2012]
            // and if an aircraft can be put here [Yufei Lang 4/10/2012]
            if (_iNumberOfAircraftsPlaced < 3 && [self checkAircraft:_tempAircraftView canFitGrid:_myGrid]) 
            {
                _tempAircraftView.delegate = self;
                [_view_MyBattleField addSubview:_tempAircraftView];
                [_tempAircraftView setFrame:CGRectMake(iX * 29, iY * 29, _tempAircraftView.frame.size.width, _tempAircraftView.frame.size.height)];
                _iNumberOfAircraftsPlaced++;
                [self fillBattleFieldGrid:_myGrid withAircraft:_tempAircraftView];
            }
        }
        else
            [_tempAircraftView removeFromSuperview];
    }
    
    // when adjusting placed aircraft position [Yufei Lang 4/6/2012]
    touch = [[event touchesForView:_tempAircraftView] anyObject];
    if (touch != NULL) 
    {
        if (_tempAircraftView.frame.origin.x >= -5 && _tempAircraftView.frame.origin.y >= -5 && 
            _tempAircraftView.frame.origin.x + _tempAircraftView.frame.size.width <= 295 &&
            _tempAircraftView.frame.origin.y + _tempAircraftView.frame.size.height <= 295)
        {
            CGPoint targetPoint = [touch locationInView:self.view];
            int iX = (targetPoint.x - _tempAircraftView.frame.size.width / 2) / 29;
            int iY = (targetPoint.y - _tempAircraftView.frame.size.height / 2) / 29;
            if ((int)(targetPoint.x - _tempAircraftView.frame.size.width / 2) % 29 >= 29 / 2)
                iX += 1;
            if ((int)(targetPoint.y - _tempAircraftView.frame.size.height / 2) % 29 >= 29 / 2)
                iY += 1;
            CGRect newFrame = CGRectMake(iX * 29, iY * 29, _tempAircraftView.frame.size.width, _tempAircraftView.frame.size.height);
            if ([self checkAircraft:_tempAircraftView inNewFrame:newFrame canFitGrid:_myGrid])
            {
                [_tempAircraftView setFrame:newFrame];
                [self removeAircraft:_tempAircraftView withOldFrame:_tempFrame fromGrid:_myGrid];
                [self fillBattleFieldGrid:_myGrid withAircraft:_tempAircraftView];
            }
            else
                [_tempAircraftView setFrame:_tempFrame];
        }
        else
            [_tempAircraftView setFrame:_tempFrame];
    }
    
}

- (BOOL)checkAircraft:(TapDetectingImageView *)aircraftView canFitGrid: (int [10][10])grid 
{
    int X = aircraftView.frame.origin.x / 29;
    int Y = aircraftView.frame.origin.y / 29;
    for (int row = 0; row < 5; row ++) 
        for (int col = 0; col < 5; col ++) 
            if ([aircraftView int2D_aircraft:row :col] != 0) 
                if (_myGrid[Y+row][X+col] != 0) 
                    return NO;
    return YES;        
}

- (BOOL)checkAircraft:(TapDetectingImageView *)aircraftView inNewFrame:(CGRect)frame canFitGrid: (int [10][10])grid 
{
    int X = frame.origin.x / 29;
    int Y = frame.origin.y / 29;
    for (int row = 0; row < 5; row ++) 
        for (int col = 0; col < 5; col ++) 
            if ([aircraftView int2D_aircraft:row :col] != 0) 
                if (_myGrid[Y+row][X+col] != 0) 
                    return NO;
    return YES;        
}

- (void)removeAircraft:(TapDetectingImageView *)aircraftView withOldFrame:(CGRect)frame fromGrid:(int [10][10])grid 
{
    int X = frame.origin.x / 29;
    int Y = frame.origin.y / 29;
    for (int row = 0; row < 5; row ++) 
        for (int col = 0; col < 5; col ++)
            if ([aircraftView int2D_aircraft:row :col] != 0)
                grid[Y+row][X+col] = 0;
}

- (void)fillBattleFieldGrid: (int [10][10])grid withAircraft:(TapDetectingImageView *)aircraftView
{
    int X = aircraftView.frame.origin.x / 29;
    int Y = aircraftView.frame.origin.y / 29;
    for (int row = 0; row < 5; row ++) 
        for (int col = 0; col < 5; col ++) 
            if ([aircraftView int2D_aircraft:row :col] != 0) 
                grid[Y+row][X+col] = [aircraftView int2D_aircraft:row :col];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // bring the chatting field to front [Yufei Lang 4/10/2012]
    [self.view bringSubviewToFront:_view_ChatFeild];
    // save the original msg [Yufei Lang 4/10/2012]
    _tempChattingString = textField.text;
    
    textField.text = @"";    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:0.3f];
    
    CGRect rect = _view_ChatFeild.frame;
    rect.origin.y -= 216; // keyboard 216 tall [Yufei Lang 4/10/2012]
    [_view_ChatFeild setFrame:rect];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        textField.text = _tempChattingString;
    }
    
    [UIView beginAnimations:@"ResizeForKeyboard"context:nil];
    [UIView setAnimationDuration:0.3f];
    
    CGRect rect = _view_ChatFeild.frame;
    rect.origin.y += 216; // keyboard 216 tall [Yufei Lang 4/10/2012]
    [_view_ChatFeild setFrame:rect];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        return YES;
    }
    if (_isGettingPaired) 
    {
        CTransmissionStructure *tempStr = [[CTransmissionStructure alloc] initWithFlag:@"chat" andDetail:textField.text andNumberRow:0 andNumberCol:0];
        if([_socketConn sendMsgAsTransStructure:tempStr])
        {
            [self sendTextView:_textView_InfoView Message:textField.text AsCharacter:[_arryCharacterString objectAtIndex:CharacterMe]];
            textField.text = @"";
        }
        else {
            [self sendTextView:_textView_InfoView Message:@"Sorry commander, there is a problem while sending your message." 
                   AsCharacter:[_arryCharacterString objectAtIndex:CharacterAdjutant]];
        }
    } 
    else 
    {
        [self sendTextView:_textView_InfoView Message:@"Sorry commander, you can't send msg to nobody, I am still looking for your competitor." 
               AsCharacter:[_arryCharacterString objectAtIndex:CharacterAdjutant]];
    }
    return YES;
}

#pragma mark - hide keyboard when tapping battle field view

- (void) resignFirstResponsWhenTouching
{
    [_txtField_ChatTextBox resignFirstResponder];
}

#pragma mark - own function - send text view msg

- (void)sendTextView: (UITextView *)textView Message: (NSString *)strMessage AsCharacter: (NSString *)character
{
    if (textView == nil) {
        textView = _textView_InfoView;
    }
    NSString *strNewString = [textView.text stringByAppendingFormat:@"[%@]: %@\n", character, strMessage];
    textView.text = strNewString;
    [textView scrollRangeToVisible:NSMakeRange([strNewString length], 0)];
}

// execute when received a END GAME message from socket connection [Yufei Lang 3/12/2012]
- (void)recvEndGameMessage: (CTransmissionStructure *)transStr
{
    NSString *strCharacter = [_arryCharacterString objectAtIndex:CharacterAdjutant];
    
    if ([transStr.strDetail isEqualToString:MSG_END_GAME_YOU_WON])
    {
        if ([NSThread isMainThread])
        {
            [self sendTextView:_textView_InfoView Message:@"Congratulations! You won!" 
                   AsCharacter:strCharacter];
        }
        else
        {// if not main thread, get main thread in order to update UI elements
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sendTextView:_textView_InfoView Message:@"Congratulations! You won!" 
                       AsCharacter:strCharacter];
            });
        }
        [_socketConn closeConnection];
    }
    
    if ([transStr.strDetail isEqualToString:MSG_END_GAME_YOU_LOST])
    {
        if ([NSThread isMainThread])
        {
            [self sendTextView:_textView_InfoView Message:@"I'am so sorry, You lost." 
                   AsCharacter:strCharacter];
        }
        else
        {// if not main thread, get main thread in order to update UI elements
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sendTextView:_textView_InfoView Message:@"I'am so sorry, You lost." 
                       AsCharacter:strCharacter];
            });
        }
        [_socketConn closeConnection];
    }
}

// execute when received a STATUS message from socket connection [Yufei Lang 3/12/2012]
- (void)recvStatusMessage: (CTransmissionStructure *)transStr
{
    // since it is a status message, we use "adjutant" as the speaking character
    NSString *strCharacter = [_arryCharacterString objectAtIndex:CharacterAdjutant];
    
    if ([transStr.strDetail isEqualToString:MSG_FLAG_STATUS_PAIRED])
    {
        _isGettingPaired = YES;
        
        // if already is main thread, execute normally
        if ([NSThread isMainThread])
        {
            [self sendTextView:_textView_InfoView Message:@"Found your competitor, ready to go!" 
                   AsCharacter:[_arryCharacterString objectAtIndex:CharacterAdjutant]];  
            [self sendTextView:_textView_InfoView Message:@"Commander, please drag and release to place 3 aircrafts." 
                   AsCharacter:[_arryCharacterString objectAtIndex:CharacterAdjutant]];   
        }
        else
        {// if not main thread, get main thread in order to update UI elements
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sendTextView:_textView_InfoView Message:@"Found your competitor, ready to go!" 
                       AsCharacter:[_arryCharacterString objectAtIndex:CharacterAdjutant]];  
                [self sendTextView:_textView_InfoView Message:@"Commander, please drag and release to place 3 aircrafts." 
                       AsCharacter:[_arryCharacterString objectAtIndex:CharacterAdjutant]]; 
            });
        }
    }
    if ([transStr.strDetail isEqualToString:MSG_FLAG_STATUS_COMPTOR_READY])
    {
        _isCompetitorReady = YES;
        if ([NSThread isMainThread])
            [self sendTextView:_textView_InfoView Message:@"Your competitor is getting ready!" AsCharacter:strCharacter];
        else 
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sendTextView:_textView_InfoView Message:@"Your competitor is getting ready!" 
                       AsCharacter:strCharacter];
            });
        }
    }
}

// execute when received a CHATTING message from socket connection [Yufei Lang 3/12/2012]
- (void)recvChatMessage: (CTransmissionStructure *)transStr
{
    // since it is a status message, we use "Competitor" as the speaking character
    NSString *strCharacter = [_arryCharacterString objectAtIndex:CharacterCompetitor];
    
    // if already is main thread, execute normally
    if ([NSThread isMainThread])
        [self sendTextView:_textView_InfoView Message:transStr.strDetail AsCharacter:strCharacter];
    else 
    {
        // if not main thread, get main thread in order to update UI elements
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendTextView:_textView_InfoView Message:transStr.strDetail AsCharacter:strCharacter];
        });
    }
}

// execute when received a ATTACT message from socket connection [Yufei Lang 3/12/2012]
- (void)recvAttackMessage: (CTransmissionStructure *)transStr
{
    switch (_myGrid[[transStr.iRow intValue]][[transStr.iCol intValue]]) {
        case 0:
            transStr.strDetail = MSG_ATTACK_DETAIL_MISS;
            break;
        case 1:
            transStr.strDetail = MSG_ATTACK_DETAIL_HIT;
            break;
        case 9:
            transStr.strDetail = MSG_ATTACK_DETAIL_DIE;
            break;
        default:
            break;
    }
    // if enemy's attack is missed [Yufei Lang 3/12/2012]
    if ([transStr.strDetail isEqualToString:MSG_ATTACK_DETAIL_MISS]) 
    {
        // if already is main thread, execute normally
        if ([NSThread isMainThread])
        {
            UILabel *lbl = [[_arryMyBattleFieldLabels objectAtIndex:transStr.iRow.intValue] 
                             objectAtIndex:transStr.iCol.intValue];
            lbl.text = ATTACK_MISS;
        }
        else 
        {
            // if not main thread, get main thread in order to update UI elements
            dispatch_async(dispatch_get_main_queue(), ^{
                UILabel *lbl = [[_arryMyBattleFieldLabels objectAtIndex:transStr.iRow.intValue] 
                                 objectAtIndex:transStr.iCol.intValue];
                lbl.text = ATTACK_MISS;
            });
        }
    }
    
    // if enemy's attack is hit [Yufei Lang 3/12/2012]
    if ([transStr.strDetail isEqualToString:MSG_ATTACK_DETAIL_HIT]) 
    {
        // if already is main thread, execute normally
        if ([NSThread isMainThread])
        {
            UILabel *lbl = [[_arryMyBattleFieldLabels objectAtIndex:transStr.iRow.intValue] 
                             objectAtIndex:transStr.iCol.intValue];
            lbl.text = ATTACK_HIT;
        }
        else 
        {
            // if not main thread, get main thread in order to update UI elements
            dispatch_async(dispatch_get_main_queue(), ^{
                UILabel *lbl = [[_arryMyBattleFieldLabels objectAtIndex:transStr.iRow.intValue] 
                                 objectAtIndex:transStr.iCol.intValue];
                lbl.text = ATTACK_HIT;
            });
        }
    }
    
    // if enemy's attack is hit the my aircraft's head [Yufei Lang 3/12/2012]
    if ([transStr.strDetail isEqualToString:MSG_ATTACK_DETAIL_DIE]) 
    {
        // if already is main thread, execute normally
        if ([NSThread isMainThread])
        {
            UILabel *lbl = [[_arryMyBattleFieldLabels objectAtIndex:transStr.iRow.intValue] 
                             objectAtIndex:transStr.iCol.intValue];
            lbl.text = ATTACK_DIE;
        }
        else 
        {
            // if not main thread, get main thread in order to update UI elements
            dispatch_async(dispatch_get_main_queue(), ^{
                UILabel *lbl = [[_arryMyBattleFieldLabels objectAtIndex:transStr.iRow.intValue] 
                                 objectAtIndex:transStr.iCol.intValue];
                lbl.text = ATTACK_DIE;
            });
        }
    }
    
    // send attack result back to attacker [Yufei Lang 4/12/2012]
    transStr.strFlag = MSG_FLAG_ATTACK_RESULT;
    [_socketConn sendMsgAsTransStructure:transStr];
}

// execute when received a ATTACT RESULT message from socket connection [Yufei Lang 3/12/2012]
- (void)recvAttackResultMessage: (CTransmissionStructure *)transStr
{
    // if my attack is missed [Yufei Lang 3/12/2012]
    if ([transStr.strDetail isEqualToString:MSG_ATTACK_DETAIL_MISS]) 
    {
        // if already is main thread, execute normally
        if ([NSThread isMainThread])
        {
            UIButton *btn = [[_arryEmenyBattleFieldButtons objectAtIndex:transStr.iRow.intValue] 
                             objectAtIndex:transStr.iCol.intValue];
            [btn setTitle:ATTACK_MISS forState:UIControlStateNormal];
        }
        else 
        {
            // if not main thread, get main thread in order to update UI elements
            dispatch_async(dispatch_get_main_queue(), ^{
                UIButton *btn = [[_arryEmenyBattleFieldButtons objectAtIndex:transStr.iRow.intValue] 
                                 objectAtIndex:transStr.iCol.intValue];
                [btn setTitle:ATTACK_MISS forState:UIControlStateNormal];
            });
        }
    }
    
    // if my attack is hited [Yufei Lang 3/12/2012]
    if ([transStr.strDetail isEqualToString:MSG_ATTACK_DETAIL_HIT]) 
    {
        // if already is main thread, execute normally
        if ([NSThread isMainThread])
        {
            UIButton *btn = [[_arryEmenyBattleFieldButtons objectAtIndex:transStr.iRow.intValue] 
                             objectAtIndex:transStr.iCol.intValue];
            [btn setTitle:ATTACK_HIT forState:UIControlStateNormal];
        }
        else 
        {
            // if not main thread, get main thread in order to update UI elements
            dispatch_async(dispatch_get_main_queue(), ^{
                UIButton *btn = [[_arryEmenyBattleFieldButtons objectAtIndex:transStr.iRow.intValue] 
                                 objectAtIndex:transStr.iCol.intValue];
                [btn setTitle:ATTACK_HIT forState:UIControlStateNormal];
            });
        }
    }
    
    // if my attack is hit the head of enemy's aircraft [Yufei Lang 3/12/2012]
    if ([transStr.strDetail isEqualToString:MSG_ATTACK_DETAIL_DIE]) 
    {
        // if already is main thread, execute normally
        if ([NSThread isMainThread])
        {
            UIButton *btn = [[_arryEmenyBattleFieldButtons objectAtIndex:transStr.iRow.intValue] 
                             objectAtIndex:transStr.iCol.intValue];
            [btn setTitle:ATTACK_DIE forState:UIControlStateNormal];
        }
        else 
        {
            // if not main thread, get main thread in order to update UI elements
            dispatch_async(dispatch_get_main_queue(), ^{
                UIButton *btn = [[_arryEmenyBattleFieldButtons objectAtIndex:transStr.iRow.intValue] 
                                 objectAtIndex:transStr.iCol.intValue];
                [btn setTitle:ATTACK_DIE forState:UIControlStateNormal];
            });
        }
    }
}

// this function will be called when post a notification named: ->
// -> newMsgRecved(this has been defined as NewMSGComesFromHost)
- (void) newMsgComes: (NSNotification *)note
{
    CTransmissionStructure *tempStructure = [note object];
    NSParameterAssert([tempStructure isKindOfClass:[CTransmissionStructure class]]);
    
    if ([tempStructure.strFlag isEqualToString:MSG_FLAG_END_GAME]) 
    {
        [self recvEndGameMessage: tempStructure];
    }
    
    if ([tempStructure.strFlag isEqualToString:MSG_FLAG_STATUS]) 
    {
        [self recvStatusMessage: tempStructure];
    }
    
    if ([tempStructure.strFlag isEqualToString:MSG_FLAG_CHAT]) 
    {
        [self recvChatMessage: tempStructure];
    }
    
    if ([tempStructure.strFlag isEqualToString:MSG_FLAG_ATTACK_RESULT]) 
    {
        [self recvAttackResultMessage: tempStructure];
    }
    
    if ([tempStructure.strFlag isEqualToString:MSG_FLAG_ATTACK]) 
    {
        [self recvAttackMessage: tempStructure];
    }
}

#pragma mark - own function - update the progressHud

- (void)updateProgressHudWithWorkingStatus: (BOOL)status WithPercentageInFloat: (float)fPercentage WithAMessage: (NSString *)msg
{
    if (status) {
        _progressHud.labelText = msg;
        _progressHud.progress = fPercentage;
    } else {
        _progressHud.labelText = msg;
        _progressHud.progress = fPercentage;
        [_progressHud hide:YES];
    }
}

#pragma mark - own function - make socket connection
- (void)makeSocketConnection
{
    _socketConn = [[CSocketConnection alloc] init];
    _socketConn.delegate = self;
    [_socketConn makeConnection];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initAllViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMsgComes:) name:NewMSGComesFromHost object:nil];
    
    // setting all  delegates [Yufei Lang 4/12/2012]
    _txtField_ChatTextBox.delegate = self;   
    _view_MyBattleField.delegate = self;
    _view_EnemyBattleField.delegate = self;
    
//    CTransmissionStructure *temp = [[CTransmissionStructure alloc] initWithFlag:@"attackResult" andDetail:@"miss" andNumberRow:0 andNumberCol:4];
//    [self recvAttackResultMessage:temp];
//    temp.strDetail = @"hit";
//    temp.iRow = [NSNumber numberWithInt:3];
//    [self recvAttackResultMessage:temp];
    
    // froze the screen for connecting to host [Yufei Lang 4/12/2012]
    _progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressHud.mode = MBProgressHUDModeDeterminate;
       
    NSThread *th = [[NSThread alloc]initWithTarget:self selector:@selector(makeSocketConnection) object:nil];
    th.name = @"thread for making connection";
    [th start];
    
            
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
    [self setTxtField_ChatTextBox:nil];
    [self setTextView_InfoView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIAlertView Delegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) // if exit anyway [Yufei Lang 4/12/2012]
    {
        CTransmissionStructure *attackStr = [[CTransmissionStructure alloc] initWithFlag:MSG_FLAG_END_GAME andDetail:MSG_END_GAME_YOU_WON andNumberRow:0 andNumberCol:0];
        [_socketConn sendMsgAsTransStructure:attackStr];
        [_socketConn closeConnection];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:@"Existing now will lose the game." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Exit", nil];
    [alert show];
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
        if (_iNumberOfAircraftsPlaced != 3)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Place more Aircraft(s)" message:@"You have to place 3 aircrafts" delegate:nil cancelButtonTitle:@"Got you." otherButtonTitles: nil];
            [alert show];
            return;
        }
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
        
        [_view_ChatFeild setFrame:CGRectMake(0, _view_ChatFeild.frame.origin.y + 50.0, 320, 120)];
        
        // end and commit animation [Yufei Lang 4/5/2012]
        [UIView commitAnimations];
    } 
    else 
    {
        _isAircraftHolderShowing = YES;
        // set up a new animation block [Yufei Lang 4/5/2012]
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        
        // adjust views (animation) [Yufei Lang 4/5/2012]
        //_view_AircraftHolder.alpha = 0;
        [_view_AircraftHolder setFrame:CGRectMake(0, _view_AircraftHolder.frame.origin.y - 50.0, 320, 50)];
        
        //_view_ToolsHolder.alpha = 1.0;
        [_view_ToolsHolder setFrame:CGRectMake(0, _view_ToolsHolder.frame.origin.y - 50.0, 320, 50)];
        
        if (_view_ChatFeild.frame.origin.y != 340)
            [_view_ChatFeild setFrame:CGRectMake(0, _view_ChatFeild.frame.origin.y - 50.0, 320, 120)];
        
        // end and commit animation [Yufei Lang 4/5/2012]
        [UIView commitAnimations];
    }
}

// button function changed, should be show/hide or keyboard. [Yufei Lang 4/12/2012]
// member the action name is INCORRENT [Yufei Lang 4/12/2012]
- (IBAction)btnClicked_SendChatMsg:(UIButton *)sender // INCORRENT name, should show/hide keyboard [Yufei Lang 4/12/2012]
{
    [_txtField_ChatTextBox resignFirstResponder];
}

- (IBAction)btnClicked_OnBattleGrid:(UIButton *)sender 
{
    // used for debugging [Yufei Lang 4/12/2012]
    NSLog(@"btnClicked. btn frame: %@", NSStringFromCGRect(sender.frame));
    
    // when clicked any button on enemy battle field, hide keyboard [Yufei Lang 4/10/2012]
    [_txtField_ChatTextBox resignFirstResponder];
    
    int X = sender.frame.origin.x / 29;
    int Y = sender.frame.origin.y / 29;
    CTransmissionStructure *attackStr = [[CTransmissionStructure alloc] initWithFlag:MSG_FLAG_ATTACK andDetail:@"" andNumberRow:Y andNumberCol:X];
    if (![_socketConn sendMsgAsTransStructure:attackStr])
        [self sendTextView:_textView_InfoView Message:@"Can't send attack msg, please try again." 
               AsCharacter:[_arryCharacterString objectAtIndex:CharacterAdjutant]];
}

@end
