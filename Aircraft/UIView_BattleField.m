//
//  UIView_BattleField.m
//  Aircraft
//
//  Created by Yufei Lang on 12-4-11.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import "UIView_BattleField.h"

@implementation UIView_BattleField
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate resignFirstResponsWhenTouching];
}

@end
