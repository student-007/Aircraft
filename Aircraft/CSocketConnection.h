//
//  CSocketConnection.h
//  Aircraft
//
//  Created by Yufei Lang on 12-4-5.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <netdb.h>
#import <arpa/inet.h>
#import "AsyncSocket.h"
#import "MBProgressHUD.h"

@protocol CSocketConnection;

@interface CSocketConnection : NSObject <AsyncSocketDelegate>
{
    NSInteger _iSockfd;
    struct sockaddr_in _their_addr; // Socket address, internet style [Yufei Lang 4/5/2012]
    BOOL _isFirstConnecting;
}

// property - delegate [Yufei Lang 4/12/2012]
@property (nonatomic, weak) id<CSocketConnection> delegate;

// methods [Yufei Lang 4/5/2012]
- (id) init;
- (NSString *) makeConnection;
@end


@protocol CSocketConnection <NSObject>

- (void)updateProgressHudWithWorkingStatus: (BOOL)status WithPercentageInFloat: (float)fPercentage WithAMessage: (NSString *)msg;

@end