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
    NSNumber *_iRow;
    NSNumber *_iCol;
    NSString *_strFlag;
    NSString *_strDetail;
}
// properties [Yufei Lang 4/5/2012]
@property (strong, nonatomic) NSString *strFlag;
@property (strong, nonatomic) NSString *strDetail;
@property (strong, nonatomic) NSNumber *iRow;
@property (strong, nonatomic) NSNumber *iCol;

// methods [Yufei Lang 4/5/2012]
- (id)init;
- (id)initWithFlag: (NSString *)strFlag andDetail: (NSString *)strDetail andNumberRow: (int)iRow andNumberCol: (int)iCol;
- (BOOL) fillWithJSONString: (NSString *)strJson;
- (NSString *) convertMyselfToJsonString;
@end
