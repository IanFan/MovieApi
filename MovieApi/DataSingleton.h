//
//  DataSingleton.h
//  MovieApi
//
//  Created by Ian Fan on 19/12/2013.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSingleton : NSObject

+(id)sharedInstance;

@property (nonatomic,retain) NSMutableArray *listItemArray;

//Cache
-(BOOL)isCachedUrlStrExist:(NSString*)urlStr;
-(NSData*)loadCachedFileWithUrlStr:(NSString*)urlStr;
-(void)downloadFileWithUrlStr:(NSString*)urlStr saveAsCache:(BOOL)isSaveAsCache doneNotification:(NSString*)targetNotificationStr;
@end
