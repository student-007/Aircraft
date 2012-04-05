//
//  CTransmissionStructure.m
//  Aircraft
//
//  Created by Yufei Lang on 12-4-5.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import "CTransmissionStructure.h"

@implementation CTransmissionStructure
@synthesize strFlag = _strFlag;
@synthesize strDetail = _strDetail;
@synthesize iRow = _iRow;
@synthesize iCol = _iCol;

- (BOOL) fillWithJSONString: (NSString *)strJson
{
    NSDictionary *dict = [strJson JSONValue]; // convert json string into a dictionary [Yufei Lang 4/5/2012]
    
    if (dict != NULL) {
        _strFlag = [dict objectForKey:@"strFlag"];
        _strDetail = [dict objectForKey:@"strDetail"];
        _iRow = (NSInteger)[dict objectForKey:@"iRow"];
        _iRow = (NSInteger)[dict objectForKey:@"iCol"];
        return YES; // successed [Yufei Lang 4/5/2012]
    } else {
        return NO; // error when resolving json string [Yufei Lang 4/5/2012]
    }
}



@end
