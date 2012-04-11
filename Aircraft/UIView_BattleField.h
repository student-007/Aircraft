//
//  UIView_BattleField.h
//  Aircraft
//
//  Created by Yufei Lang on 12-4-11.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIView_BattleField;

@interface UIView_BattleField : UIView

@property (nonatomic, weak) id<UIView_BattleField> delegate;

@end

@protocol UIView_BattleField <NSObject>

- (void) resignFirstResponsWhenTouching;

@end