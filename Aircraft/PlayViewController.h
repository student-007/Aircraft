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
    BOOL _isGamingContinuing;               // if the game is on [Yufei Lang 4/12/2012]
    BOOL _isGettingPaired;                  // if user is getting another player [Yufei Lang 4/12/2012]
    BOOL _isAircraftHolderShowing;          // is Aircraft Holder Showing [Yufei Lang 4/12/2012]
    BOOL _isPlacingAircraftsReady;          // placed all 3 aircrafts, and clicked "done" button [Yufei Lang 4/12/2012]
    BOOL _isCompetitorReady;                // is competitor placed all aircrafts [Yufei Lang 4/12/2012]
    int _iNumberOfAircraftsPlaced;          // how many aircrafts have been placed [Yufei Lang 4/12/2012]
    int _iNumberOfMineAircraftDestried;     // how many aircrafts of mine have been destried [Yufei Lang 4/12/2012]
    int _iNumberOfEnemyAircraftDestoried;   // how many aircrafts of mine have been destried [Yufei Lang 4/12/2012]
    
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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_BattleField;
@property (weak, nonatomic) IBOutlet UIView *view_AircraftHolder;
@property (weak, nonatomic) IBOutlet UIView *view_ToolsHolder;
@property (weak, nonatomic) IBOutlet UIView *view_ChatFeild;
@property (weak, nonatomic) IBOutlet UIView_BattleField *view_MyBattleField;
@property (weak, nonatomic) IBOutlet UIView_BattleField *view_EnemyBattleField;

// properties - IBOutlet aircrafts images in holder [Yufei Lang 4/5/2012]
@property (weak, nonatomic) IBOutlet TapDetectingImageView *imgView_AircraftUp;
@property (weak, nonatomic) IBOutlet TapDetectingImageView *imgView_AircraftDown;
@property (weak, nonatomic) IBOutlet TapDetectingImageView *imgView_AircraftLeft;
@property (weak, nonatomic) IBOutlet TapDetectingImageView *imgView_AircraftRight;

// properties - IBOutlet battle fields background [Yufei Lang 4/5/2012]
@property (weak, nonatomic) IBOutlet UIImageView *imgView_MyBattleFieldBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_EnemyBattleFieldBackground;

// properties - IBOutlet chatting field [Yufei Lang 4/10/2012]
@property (weak, nonatomic) IBOutlet UITextView *textView_InfoView;
@property (weak, nonatomic) IBOutlet UITextField *txtField_ChatTextBox;
@property (weak, nonatomic) IBOutlet UIButton *btnSendButton;

// properties -  battle fields buttons[Yufei Lang 4/5/2012]
@property (strong, nonatomic) NSMutableArray *arryMyBattleFieldLabels;
@property (strong, nonatomic) NSMutableArray *arryEmenyBattleFieldButtons;

// makr whose turn it is [Yufei Lang 4/12/2012]
@property (weak, nonatomic) IBOutlet UILabel *lbl_WhoseTurn;

// properties - socket connection [Yufei Lang 4/12/2012]
@property (strong, nonatomic) CSocketConnection *socketConn;

// property - Array of Character Strings [Yufei Lang 4/12/2012]
@property (strong, nonatomic) NSArray *arryCharacterString;

// property - give user some information when connecting to the host [Yufei Lang 4/12/2012]
@property (strong, nonatomic) MBProgressHUD *progressHud;

// actions [Yufei Lang 4/5/2012]

// methods [Yufei Lang 4/5/2012]

@end
