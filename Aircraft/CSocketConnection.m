//
//  CSocketConnection.m
//  Aircraft
//
//  Created by Yufei Lang on 12-4-5.
//  Copyright (c) 2012年 UB. All rights reserved.
//

#import "CSocketConnection.h"

#define STR_HOST_NAME @"www.baidu.com"
#define I_PORT 80
#define I_BLOCK_SIZE 512

@implementation CSocketConnection

- (id) init
{
    self = [super init];
    if (self) {
        //[self makeConnection];
        //AsyncSocket *socket = [[AsyncSocket alloc] initWithDelegate:self];
        //NSError *error;
        //[socket connectToHost:STR_HOST_NAME onPort:I_PORT withTimeout:5 error:&error];
        //[socket connectToHost:STR_HOST_NAME onPort:I_PORT error:&error];
        //NSLog(@"%@", error);        
    }
    return self;
}
/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"did connected to host");
}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"did recv data");
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
    if ((_iSockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        herror("error making socket.");
        return NULL;
    }
    
    memset(&_their_addr, 0, sizeof(_their_addr));
    _their_addr.sin_family = AF_INET; // set as internet type [Yufei Lang 4/5/2012]
    _their_addr.sin_addr.s_addr = inet_addr([[self getIPAddressForHost:STR_HOST_NAME] UTF8String]); // giving ip address to _their_addr [Yufei Lang 4/5/2012]
    _their_addr.sin_port = htons(80);
    
    bzero(&(_their_addr.sin_zero), 8);
    
    int iConn = connect(_iSockfd, (struct sockaddr *)&_their_addr, sizeof(struct sockaddr)); // making the connection to the socket [Yufei Lang 4/5/2012]
    if (iConn != -1) // sucessed making connection [Yufei Lang 4/5/2012]
    {
        NSMutableString *strReadString = [[NSMutableString alloc] init]; // need a string to recv [Yufei Lang 4/5/2012]
        char chReadBuffer[I_BLOCK_SIZE]; // a char* recv transmission block [Yufei Lang 4/5/2012]
        int iByteRecved = 0; // how many bytes recved [Yufei Lang 4/5/2012]
        do 
        {
            iByteRecved = recv(_iSockfd, chReadBuffer, sizeof(chReadBuffer), 0); // recv data from socket then write to chReadBuffer. [Yufei Lang 4/5/2012]
            [strReadString appendFormat:[NSString stringWithCString:chReadBuffer encoding:NSUTF8StringEncoding]];
        } 
        while (iByteRecved == I_BLOCK_SIZE); // if recved all data, end the loop [Yufei Lang 4/5/2012]
        NSLog(@"recved data from socket: %@", strReadString);
        return strReadString;
    }
    else
        return NULL;
}

@end
