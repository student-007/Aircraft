//
//  MasterViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 12-4-5.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayViewController.h"
#import "HowToPlay.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <UITableViewDelegate>
{
    
}
// whats in section one. play online or play with computer or  how to play
@property (strong, nonatomic) NSArray *arryTableContent;

@property (strong, nonatomic) HowToPlay *howToPlay;
@property (strong, nonatomic) PlayViewController *playView;

@end
