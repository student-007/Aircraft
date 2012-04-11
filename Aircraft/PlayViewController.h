//
//  PlayViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 12-4-6.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapDetectingImageView.h"
#import "CSocketConnection.h"

@interface PlayViewController : UIViewController <UIScrollViewDelegate, TapDetectingImageViewDelegate, UITextFieldDelegate>
{
    BOOL _isAircraftHolderShowing;
    BOOL _isPlacingAircraftsReady;
    int _iNumberOfAircraftsPlaced;
    //UIView *_tempAircraftView; // use for showing user a temp aircraft when selecting from aircraft holder [Yufei Lang 4/5/2012]
    TapDetectingImageView *_tempAircraftView;
    CGRect _tempFrame;
    //NSMutableArray *_arryImgView_PlacedAircrafts;
    
    // my battle field grid & enemy battle field grid [Yufei Lang 4/10/2012]
    int _myGrid[10][10];
    int _enemyGrid[10][10];
    
    // temp chatting string, to keep user what wanted to say [Yufei Lang 4/10/2012]
    NSString *_tempChattingString;
}


// properties -  IBOutlet views [Yufei Lang 4/5/2012]
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_BattleField;
@property (strong, nonatomic) IBOutlet UIView *view_AircraftHolder;
@property (strong, nonatomic) IBOutlet UIView *view_ToolsHolder;
@property (strong, nonatomic) IBOutlet UIView *view_ChatFeild;
@property (strong, nonatomic) IBOutlet UIView *view_MyBattleField;
@property (strong, nonatomic) IBOutlet UIView *view_EnemyBattleField;

// properties - IBOutlet aircrafts images in holder [Yufei Lang 4/5/2012]
@property (strong, nonatomic) IBOutlet TapDetectingImageView *imgView_AircraftUp;
@property (strong, nonatomic) IBOutlet TapDetectingImageView *imgView_AircraftDown;
@property (strong, nonatomic) IBOutlet TapDetectingImageView *imgView_AircraftLeft;
@property (strong, nonatomic) IBOutlet TapDetectingImageView *imgView_AircraftRight;

// properties - IBOutlet battle fields background [Yufei Lang 4/5/2012]
@property (strong, nonatomic) IBOutlet UIImageView *imgView_MyBattleFieldBackground;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_EnemyBattleFieldBackground;

// properties - IBOutlet chatting field [Yufei Lang 4/10/2012]
@property (strong, nonatomic) IBOutlet UITextView *textView_InfoView;
@property (strong, nonatomic) IBOutlet UITextField *txtField_ChatTextBox;

// properties -  useless[Yufei Lang 4/5/2012]
@property (strong, nonatomic) NSMutableArray *arryImgView_PlacedAircrafts;

// actions [Yufei Lang 4/5/2012]

// methods [Yufei Lang 4/5/2012]
- (void)initAllViews;
- (void)loadPage: (UIView *)viewPage toScrollView: (UIScrollView *) scrollView;
- (void)initGridInBattleFieldView:(UIView *)viewBattleField;
- (void)removeAircraft:(TapDetectingImageView *)aircraftView withOldFrame:(CGRect)frame fromGrid:(int [10][10])grid ;
- (BOOL)checkAircraft:(TapDetectingImageView *)aircraftView canFitGrid: (int [10][10])grid;
- (BOOL)checkAircraft:(TapDetectingImageView *)aircraftView inNewFrame:(CGRect)frame canFitGrid: (int [10][10])grid;
- (void)fillBattleFieldGrid: (int [10][10])grid withAircraft:(TapDetectingImageView *)aircraftView;
@end
