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

- (id)init
{
    self = [super init];
    if (self) {
        // init self
    }
    return self;
}

- (id)initWithFlag: (NSString *)strFlag andDetail: (NSString *)strDetail andNumberRow: (int)iRow andNumberCol: (int)iCol
{
    self = [super init];
    if (self) {
        self.strFlag = strFlag;
        self.strDetail = strDetail;
        self.iRow = [[NSNumber alloc] initWithInt:iRow];
        self.iCol =  [[NSNumber alloc] initWithInt:iCol];
    }
    return self;
}

- (BOOL) fillWithJSONString: (NSString *)strJson
{
    NSDictionary *dict = [strJson JSONValue]; // convert json string into a dictionary [Yufei Lang 4/5/2012]
    
    if (dict != NULL) 
    {
        self.strFlag = [dict objectForKey:@"strFlag"];
        self.strDetail = [dict objectForKey:@"strDetail"];
        self.iRow = [dict objectForKey:@"iRow"];
        self.iCol = [dict objectForKey:@"iCol"];
        return YES; // successed [Yufei Lang 4/5/2012]
    } 
    else 
    {
        return NO; // error when resolving json string [Yufei Lang 4/5/2012]
    }
}

- (NSString *)convertMyselfToJsonString
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:_strFlag forKey:@"strFlag"];
    [dict setValue:_strDetail forKey:@"strDetail"];
    [dict setValue:_iRow forKey:@"iRow"];
    [dict setValue:_iCol forKey:@"iCol"];
    return [dict JSONRepresentation];
}

@end
