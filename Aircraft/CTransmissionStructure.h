//
//  CTransmissionStructure.h
//  Aircraft
//
//  Created by Yufei Lang on 12-4-5.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface CTransmissionStructure : NSObject
{
    NSInteger _iRow;
    NSInteger _iCol;
    NSMutableString *_strFlag;
    NSMutableString *_strDetail;
}
// properties [Yufei Lang 4/5/2012]
@property (strong, nonatomic) NSMutableString *strFlag;
@property (strong, nonatomic) NSMutableString *strDetail;
@property (nonatomic) NSInteger iRow;
@property (nonatomic) NSInteger iCol;

// methods [Yufei Lang 4/5/2012]
- (BOOL) fillWithJSONString: (NSString *)strJson;
@end
