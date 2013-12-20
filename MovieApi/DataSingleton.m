//
//  DataSingleton.m
//  MovieApi
//
//  Created by Ian Fan on 19/12/2013.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import "DataSingleton.h"

@implementation DataSingleton

+(id)sharedInstance {
  static id shared = nil;
  if (shared == nil) shared= [[DataSingleton alloc]init];
  
  return shared;
}

#pragma mark - Cache

-(BOOL)isCachedUrlStrExist:(NSString *)urlStr {
  BOOL isCached = NO;
  
  return isCached;
}

-(NSData*)loadCachedFileWithUrlStr:(NSString *)urlStr {
  NSData *data = nil;
  
  return data;
}

-(void)downloadFileWithUrlStr:(NSString *)urlStr saveAsCache:(BOOL)isSaveAsCache doneNotification:(NSString *)targetNotificationStr {
  
}

#pragma mark - Init

-(id)init {
  if ((self = [super init])) {
  }
  
  return self;
}

@end
