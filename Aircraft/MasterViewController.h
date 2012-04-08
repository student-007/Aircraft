//
//  MasterViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 12-4-5.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayViewController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <UITableViewDelegate>
{
    
}

@property (strong, nonatomic) NSArray *arryTableContent;// whats in section one. play online or play with computer
@end
