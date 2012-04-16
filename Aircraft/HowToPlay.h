//
//  HowToPlay.h
//  Aircraft
//
//  Created by Yufei Lang on 12-4-16.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowToPlay : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *step_1;
@property (nonatomic, strong) UIImageView *step_2;
@property (nonatomic, strong) UIImageView *step_3;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_HowToPlay;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end
