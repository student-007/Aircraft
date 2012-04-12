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
#import "MBProgressHUD.h"
#import "CTransmissionStructure.h"

#define NewMSGComesFromHost @"newMsgRecved"

@protocol CSocketConnection;

@interface CSocketConnection : NSObject
{
    NSInteger _iSockfd;
    struct sockaddr_in _their_addr; // Socket address, internet style [Yufei Lang 4/5/2012]
    BOOL _isFirstConnecting;
    BOOL _isGameContinuing;
    CTransmissionStructure *_transmissionStructure;
}

// property  [Yufei Lang 4/12/2012]
@property (nonatomic, weak) id<CSocketConnection> delegate;
@property (nonatomic, strong) CTransmissionStructure *transmissionStructure;
@property (nonatomic) BOOL isGameContinuing;

// methods [Yufei Lang 4/5/2012]
- (id) init;
- (NSString *) makeConnection;
- (BOOL)sendMsgAsTransStructure: (CTransmissionStructure *)struture;
- (void)recvMsg_waitUntilDone;
@end


@protocol CSocketConnection <NSObject>
- (void)updateProgressHudWithWorkingStatus: (BOOL)status WithPercentageInFloat: (float)fPercentage WithAMessage: (NSString *)msg;
@end