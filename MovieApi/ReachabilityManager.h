//
//  ReachabilityManager.h
//  Diamond
//
//  Created by Ian Fan on 27/08/13.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "LocalObject.h"

@interface ReachabilityManager : NSObject
{
  UIAlertView *_interludeAlertView;
}

//internet
@property (nonatomic,retain) Reachability *hostReachability;
@property (nonatomic,retain) Reachability *internetReachability;
@property (nonatomic,retain) Reachability *wifiReachability;
@property BOOL isWWAN;
@property BOOL isWifi;

+(id)sharedInstance;

-(void)showInternetAlertViewWithIsConnected:(BOOL)isConnected;

@end
