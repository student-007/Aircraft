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
#import "UIView_BattleField.h"
#import "MBProgressHUD.h"

typedef enum
{
    CharacterAdjutant       =0,
    CharacterMe             =1,
    CharacterCompetitor     =2,
}CharacterString;

@interface PlayViewController : UIViewController <UIScrollViewDelegate, TapDetectingImageViewDelegate, UITextFieldDelegate, UIView_BattleField, CSocketConnection, UIAlertViewDelegate>
{
    BOOL _isMyturn;
    BOOL _isGamingContinuing;       // if the game is on [Yufei Lang 4/12/2012]
    BOOL _isGettingPaired;          // if user is getting another player [Yufei Lang 4/12/2012]
    BOOL _isAircraftHolderShowing;  // is Aircraft Holder Showing [Yufei Lang 4/12/2012]
    BOOL _isPlacingAircraftsReady;  // placed all 3 aircrafts, and clicked "done" button [Yufei Lang 4/12/2012]
    BOOL _isCompetitorReady;        // is competitor placed all aircrafts [Yufei Lang 4/12/2012]
    int _iNumberOfAircraftsPlaced;  // how many aircrafts have been placed [Yufei Lang 4/12/2012]
    
    // use for showing user a temp aircraft when selecting from aircraft holder [Yufei Lang 4/5/2012]
    TapDetectingImageView *_tempAircraftView;
    // keep the old original frame in the temp rect [Yufei Lang 4/12/2012]
    CGRect _tempFrame;
    //NSMutableArray *_arryImgView_PlacedAircrafts;
    
    // my battle field grid & enemy battle field grid [Yufei Lang 4/10/2012]
    int _myGrid[10][10];
    int _enemyGrid[10][10];
    
    // temp chatting string, to keep user what wanted to say [Yufei Lang 4/10/2012]
    NSString *_tempChattingString;
    // a string array, to keep the speaking character [Yufei Lang 4/12/2012]
    // 0-Adjutant 1-Me 2-Competitor[Yufei Lang 4/12/2012]
    NSArray *_arryCharacterString;
    
    // a socket connection [Yufei Lang 4/12/2012]
    CSocketConnection *_socketConn;
    
    // give user some information when connecting to the host [Yufei Lang 4/12/2012]
    MBProgressHUD *_progressHud;
}


// properties -  IBOutlet views [Yufei Lang 4/5/2012]
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_BattleField;
@property (strong, nonatomic) IBOutlet UIView *view_AircraftHolder;
@property (strong, nonatomic) IBOutlet UIView *view_ToolsHolder;
@property (strong, nonatomic) IBOutlet UIView *view_ChatFeild;
@property (strong, nonatomic) IBOutlet UIView_BattleField *view_MyBattleField;
@property (strong, nonatomic) IBOutlet UIView_BattleField *view_EnemyBattleField;

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

// properties -  battle fields buttons[Yufei Lang 4/5/2012]
@property (strong, nonatomic) NSMutableArray *arryMyBattleFieldLabels;
@property (strong, nonatomic) NSMutableArray *arryEmenyBattleFieldButtons;

// makr whose turn it is [Yufei Lang 4/12/2012]
@property (strong, nonatomic) IBOutlet UILabel *lbl_WhoseTurn;

// properties - socket connection [Yufei Lang 4/12/2012]
@property (strong, nonatomic) CSocketConnection *socketConn;

// property - Array of Character Strings [Yufei Lang 4/12/2012]
@property (strong, nonatomic) NSArray *arryCharacterString;

// property - give user some information when connecting to the host [Yufei Lang 4/12/2012]
@property (strong, nonatomic) MBProgressHUD *progressHud;

// actions [Yufei Lang 4/5/2012]

// methods [Yufei Lang 4/5/2012]
- (void)initAllViews;
- (void)loadPage: (UIView *)viewPage toScrollView: (UIScrollView *) scrollView;
- (void)removeAircraft:(TapDetectingImageView *)aircraftView withOldFrame:(CGRect)frame fromGrid:(int [10][10])grid ;
- (BOOL)checkAircraft:(TapDetectingImageView *)aircraftView canFitGrid: (int [10][10])grid;
- (BOOL)checkAircraft:(TapDetectingImageView *)aircraftView inNewFrame:(CGRect)frame canFitGrid: (int [10][10])grid;
- (void)fillBattleFieldGrid: (int [10][10])grid withAircraft:(TapDetectingImageView *)aircraftView;
@end
