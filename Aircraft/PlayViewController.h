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

@interface PlayViewController : UIViewController <UIScrollViewDelegate, TapDetectingImageViewDelegate>
{
    BOOL _isAircraftHolderShowing;
    BOOL _isPlacingAircraftsReady;
    int _iNumberOfAircraftsPlaced;
    //UIView *_tempAircraftView; // use for showing user a temp aircraft when selecting from aircraft holder [Yufei Lang 4/5/2012]
    TapDetectingImageView *_tempAircraftView;
    //NSMutableArray *_arryImgView_PlacedAircrafts;
}


// properties -  IBOutlet views [Yufei Lang 4/5/2012]
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_BattleField;
@property (strong, nonatomic) IBOutlet UIView *view_AircraftHolder;
@property (strong, nonatomic) IBOutlet UIView *view_ToolsHolder;
@property (strong, nonatomic) IBOutlet UIView *view_ChatFeild;
@property (strong, nonatomic) IBOutlet UIView *view_MyBattleField;
@property (strong, nonatomic) IBOutlet UIView *view_EnemyBattleField;

// properties - IBOutlet aircrafts images in holder [Yufei Lang 4/5/2012]
@property (strong, nonatomic) IBOutlet UIImageView *imgView_AircraftUp;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_AircraftDown;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_AircraftLeft;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_AircraftRight;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_MyBattleFieldBackground;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_EnemyBattleFieldBackground;

// properties -  [Yufei Lang 4/5/2012]
@property (strong, nonatomic) NSMutableArray *arryImgView_PlacedAircrafts;

// actions [Yufei Lang 4/5/2012]

// methods [Yufei Lang 4/5/2012]
- (void)initAllViews;
- (void)loadPage: (UIView *)viewPage toScrollView: (UIScrollView *) scrollView;
- (void)initGridInBattleFieldView:(UIView *)viewBattleField;
@end
