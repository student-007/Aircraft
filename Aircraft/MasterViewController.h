//
//  MasterViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 12-4-5.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
