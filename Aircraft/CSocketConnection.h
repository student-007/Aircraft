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
    NSInteger _iConn;                       // connection status [Yufei Lang 4/14/2012]
    struct sockaddr_in _their_addr;         // Socket address, internet style [Yufei Lang 4/5/2012]
    BOOL _isFirstConnecting;
    BOOL _isGameContinuing;
    int _iByteRecved;
    CTransmissionStructure *_transmissionStructure;
}

// property  [Yufei Lang 4/12/2012]
@property (nonatomic, weak) id<CSocketConnection> delegate;
@property (nonatomic, strong) CTransmissionStructure *transmissionStructure;
@property (nonatomic) BOOL isGameContinuing;
@property (nonatomic) NSInteger iConn;

// methods [Yufei Lang 4/5/2012]
- (id) init;
- (NSString *) makeConnection;
- (void)closeConnection;
- (BOOL)isConnect;
- (BOOL)sendMsgAsTransStructure: (CTransmissionStructure *)struture;
- (void)recvMsg_waitUntilDone;
@end


@protocol CSocketConnection <NSObject>
- (void)sendTextView: (UITextView *)textView Message: (NSString *)strMessage AsCharacter: (NSString *)character;
- (void)updateProgressHudWithWorkingStatus: (BOOL)status WithPercentageInFloat: (float)fPercentage WithAMessage: (NSString *)msg;
@end