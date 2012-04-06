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

@interface CSocketConnection : NSObject <AsyncSocketDelegate>
{
    NSInteger _iSockfd;
    struct sockaddr_in _their_addr; // Socket address, internet style [Yufei Lang 4/5/2012]
}


// methods [Yufei Lang 4/5/2012]
- (id) init;
- (NSString *) makeConnection;
@end
