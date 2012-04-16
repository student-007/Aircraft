//
//  CSocketConnection.m
//  Aircraft
//
//  Created by Yufei Lang on 12-4-5.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import "CSocketConnection.h"

#define MSG_FLAG_CONNECTION     @"connectionTest"

#define STR_HOST_NAME           @"192.168.53.9"
#define I_PORT                  5180
#define I_BLOCK_SIZE            512

@implementation CSocketConnection

@synthesize delegate = _delegate;
@synthesize transmissionStructure = _transmissionStructure;
@synthesize isGameContinuing = _isGameContinuing;
@synthesize iConn = _iConn;

- (id) init
{
    self = [super init];
    if (self) {
        _isFirstConnecting = YES;
        _isGameContinuing = YES;
        _iConn = -1;
    }
    return self;
}

- (NSString *) getIPAddressForHost: (NSString *)strHost // get host's ip address (string type), return NULL if not found [Yufei Lang 4/5/2012]
{
    struct hostent *tempHost = gethostbyname([strHost UTF8String]); // get network data base library.  All addresses. [Yufei Lang 4/5/2012]
    if (!tempHost) 
    {
        herror("error getting network data base libary, addresses.");
        return NULL;
    }
    struct in_addr **list = (struct in_addr **)tempHost->h_addr_list; // get a list of internet addresses from host [Yufei Lang 4/5/2012]
    NSString *strAddressString = [NSString stringWithCString:inet_ntoa(*list[0]) 
                                                    encoding:NSUTF8StringEncoding]; // inet.h used for "inet_ntoa" [Yufei Lang 4/5/2012]
    if (strAddressString != NULL)
        return strAddressString;
    else
        return NULL;
}

- (NSString *) makeConnection
{
    if (_isFirstConnecting)
        [_delegate updateProgressHudWithWorkingStatus:YES WithPercentageInFloat:0.2f WithAMessage:@"Preparing connection..."];
    
    if ((_iSockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        if (_isFirstConnecting)
        {
            [_delegate updateProgressHudWithWorkingStatus:NO WithPercentageInFloat:0.0f WithAMessage:@"failed making connecting."];
        }
        herror("error making socket.");
        return NULL;
    }
    
    if (_isFirstConnecting)
        [_delegate updateProgressHudWithWorkingStatus:YES WithPercentageInFloat:0.4f WithAMessage:@"Looking for destination..."];
    memset(&_their_addr, 0, sizeof(_their_addr));
    _their_addr.sin_family = AF_INET; // set as internet type [Yufei Lang 4/5/2012]
    _their_addr.sin_addr.s_addr = inet_addr([[self getIPAddressForHost:STR_HOST_NAME] UTF8String]); // giving ip address to _their_addr [Yufei Lang 4/5/2012]
    _their_addr.sin_port = htons(I_PORT);
    
    bzero(&(_their_addr.sin_zero), 8);
    
    if (_isFirstConnecting)
        [_delegate updateProgressHudWithWorkingStatus:YES WithPercentageInFloat:0.5f WithAMessage:@"Connecting to destination..."];
    
    NSThread *thTimeOut = [[NSThread alloc] initWithTarget:self selector:@selector(connectTimeOut) object:nil];
    [thTimeOut start];
    
    _iConn = connect(_iSockfd, (struct sockaddr *)&_their_addr, sizeof(struct sockaddr)); // making the connection to the socket [Yufei Lang 4/5/2012]
    
    if (_iConn != -1) // sucessed making connection [Yufei Lang 4/5/2012]
    {
        NSMutableString *strReadString = [[NSMutableString alloc] init]; // need a string to recv [Yufei Lang 4/5/2012]
        char chReadBuffer[I_BLOCK_SIZE] = {0}; // a char* recv transmission block [Yufei Lang 4/5/2012]
        int iByteRecved = 0; // how many bytes recved [Yufei Lang 4/5/2012]
        if (_isFirstConnecting)
            [_delegate updateProgressHudWithWorkingStatus:YES WithPercentageInFloat:0.6f WithAMessage:@"Receiving data..."];
        do 
        {
            iByteRecved = recv(_iSockfd, chReadBuffer, sizeof(chReadBuffer), 0); // recv data from socket then write to chReadBuffer. [Yufei Lang 4/5/2012]
            [strReadString appendFormat:[NSString stringWithCString:chReadBuffer encoding:NSASCIIStringEncoding]];
        } 
        while (iByteRecved == I_BLOCK_SIZE); // if recved all data, end the loop [Yufei Lang 4/5/2012]
        if (_isFirstConnecting)
        {
            [_delegate updateProgressHudWithWorkingStatus:YES WithPercentageInFloat:0.8f WithAMessage:@"Data received..."];
        }
        _transmissionStructure = [[CTransmissionStructure alloc] init];
        [_transmissionStructure fillWithJSONString:strReadString];
        
        [[NSNotificationCenter defaultCenter] postNotificationName: NewMSGComesFromHost object:_transmissionStructure];
        
        if (_isFirstConnecting)
        {
            [_delegate updateProgressHudWithWorkingStatus:NO WithPercentageInFloat:1.0f WithAMessage:@"Connected!"];
        }
        
        NSLog(@"recved data from socket: %@", strReadString);
        _isFirstConnecting = NO;
        
        // making a new thread to watch new coming data all the time until game ended.
        NSThread *th = [[NSThread alloc] initWithTarget:self selector:@selector(recvMsg_waitUntilDone) object:nil];
        th.name = @"thread recving data.";
        [th start];
                
        return strReadString;
    }
    else
    {
        if (_isFirstConnecting)
        {
            [_delegate updateProgressHudWithWorkingStatus:NO WithPercentageInFloat:0.0f WithAMessage:@"failed connecting destination."];
            [_delegate sendTextView:nil Message:@"Failed making connection. Will you please try again." AsCharacter:@"system"];
        }
        return @"Connect to host failed.";
    }
}

- (BOOL)isConnect
{
    if (_iConn == -1) {
        return NO;
    }
    CTransmissionStructure *tempStr = [[CTransmissionStructure alloc] initWithFlag:MSG_FLAG_CONNECTION andDetail:@"" andNumberRow:0 andNumberCol:0];
    NSString *strJsonString = [tempStr convertMyselfToJsonString];
    NSData *data = [strJsonString dataUsingEncoding:NSASCIIStringEncoding];
    ssize_t dataSended = send(_iSockfd, [data bytes], [data length], 0);
    if (dataSended != [data length]) 
    {
        NSLog(@"error while sending socket data, connection may have closed.");
        return NO;
    }
    else {
        return YES;
    }

}

- (BOOL)sendMsgAsTransStructure:(CTransmissionStructure *)struture
{
    NSString *strJsonString = [struture convertMyselfToJsonString];
    NSData *data = [strJsonString dataUsingEncoding:NSASCIIStringEncoding];
    ssize_t dataSended = send(_iSockfd, [data bytes], [data length], 0);
    if (dataSended != [data length]) 
    {
        NSLog(@"error while sending socket data, connection may have closed.");
        return NO;
    }
    else {
        return YES;
    }
}

- (void)closeConnection
{
    _isGameContinuing = NO;
    close(_iSockfd);
}

- (void)recvMsg_waitUntilDone
{
    while (_isGameContinuing)
    {
        NSMutableString *strReadString = [[NSMutableString alloc] init]; // need a string to recv [Yufei Lang 4/5/2012]
        char chReadBuffer[I_BLOCK_SIZE] = {0}; // a char* recv transmission block [Yufei Lang 4/5/2012]
        int iByteRecved = 0; // how many bytes recved [Yufei Lang 4/5/2012]
        do 
        {
            iByteRecved = recv(_iSockfd, chReadBuffer, sizeof(chReadBuffer), 0); // recv data from socket then write to chReadBuffer. [Yufei Lang 4/5/2012]
            [strReadString appendFormat:[NSString stringWithCString:chReadBuffer encoding:NSASCIIStringEncoding]];
            if (iByteRecved == 0) {
                // if socket is disconnected, close it, make loop stop.
                _isGameContinuing = NO;
                close(_iSockfd);
                _transmissionStructure.strFlag = @"status";
                _transmissionStructure.strDetail = @"Your competitor quit the game.";
                [[NSNotificationCenter defaultCenter] postNotificationName: NewMSGComesFromHost object:_transmissionStructure];
                return;
            }
        } 
        while (iByteRecved == I_BLOCK_SIZE); // if recved all data, end the loop [Yufei Lang 4/5/2012]
        [_transmissionStructure fillWithJSONString:strReadString];
        [[NSNotificationCenter defaultCenter] postNotificationName: NewMSGComesFromHost object:_transmissionStructure];
    }
}

- (void)connectTimeOut
{
    [NSThread sleepForTimeInterval:5.0f];
    if (_iConn == -1) 
        [_delegate updateProgressHudWithWorkingStatus:NO WithPercentageInFloat:0.0f WithAMessage:@"Time out for connecting."];
}

@end
