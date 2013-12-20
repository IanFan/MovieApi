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

#pragma mark - DownloadObjectDelegate

-(void)downloadObjectDelegateDownloadSuccessWithData:(NSData *)resultData byDownloader:(DownloadObject *)theDownloader {
  if(theDownloader.tag == BASE_DOWNLOADER_REMOTEFILE_TAG) {
    NSDictionary *extraparameter=theDownloader.extraParameter;
    
    BOOL bShouldSave=[[extraparameter objectForKey:OBJECTDOWNLOADER_SHOULDSAVE_KEY_TAG] boolValue];
    
    NSString *doneNotificationName=[extraparameter objectForKey:OBJECTDOWNLOADER_DONENOTIFICATION_KEY_TAG];
    
    // Save Cache?
    if (bShouldSave) {
      [self saveCacheFileWithUrlStr:theDownloader.downloadUrlStr data:resultData];
    }
    
    // Post Notification with Data?
    if (doneNotificationName != nil) {
      NSDictionary *resultDictionary=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:TRUE],RESULT_TAG,resultData,DATA_TAG,theDownloader.downloadUrlStr,URLSTR_TAG,nil];
      
      [[NSNotificationCenter defaultCenter] postNotificationName:doneNotificationName object:resultDictionary];
    }
  }
}

-(void)downloadObjectDelegateDownloadFailWithError:(NSError *)resultError byDownloader:(DownloadObject *)theDownloader {
  if(theDownloader.tag == BASE_DOWNLOADER_REMOTEFILE_TAG){
    NSDictionary *extraparameter=theDownloader.extraParameter;
    
    NSString *doneNotificationName=[extraparameter objectForKey:OBJECTDOWNLOADER_DONENOTIFICATION_KEY_TAG];
    
    // Post Notification with NSError?
    if (doneNotificationName != nil) {
      NSDictionary *resultDictionary=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE],RESULT_TAG,resultError,ERROR_TAG,theDownloader.downloadUrlStr,URLSTR_TAG,nil];
      
      [[NSNotificationCenter defaultCenter] postNotificationName:doneNotificationName object:resultDictionary];
    }
  }
}

-(void)downloadObjectDelegateDownloadCancelByDownloader:(DownloadObject *)theDownloader {
  //do nothing
}

#pragma mark - Cache

-(BOOL)isCachedUrlStrExist:(NSString *)urlStr {
  BOOL isCached = NO;
  
  NSString *stringPrefix=@"";
  NSString *hashedFileName=[NSString stringWithFormat:@"%u",[urlStr hash]];
	NSString *targetFilePathName=[NSString stringWithFormat:@"%@/%@%@",CACHE_FOLDER,stringPrefix,hashedFileName];
	if ([[NSFileManager defaultManager] fileExistsAtPath:targetFilePathName]) isCached = YES;
  
  return isCached;
}

-(NSData*)returnCachedFileWithUrlStr:(NSString *)urlStr {
  NSData *data = nil;
  
  NSString *stringPrefix=@"";
  NSString *hashedFileName=[NSString stringWithFormat:@"%u",[urlStr hash]];
	NSString *targetFilePathName=[NSString stringWithFormat:@"%@/%@%@",CACHE_FOLDER,stringPrefix,hashedFileName];
	data = [NSData dataWithContentsOfFile:targetFilePathName];
  
  return data;
}

-(NSString*)returnCachedFilePathStrWithUrlStr:(NSString*)urlStr {
  NSString *filePathStr = nil;
  
  NSString *stringPrefix=@"";
  NSString *hashedFileName=[NSString stringWithFormat:@"%u",[urlStr hash]];
	NSString *targetFilePathName=[NSString stringWithFormat:@"%@/%@%@",CACHE_FOLDER,stringPrefix,hashedFileName];
  if([[NSFileManager defaultManager] fileExistsAtPath:targetFilePathName]) filePathStr = targetFilePathName;
  
  return filePathStr;
}

-(void)downloadFileWithUrlStr:(NSString *)urlStr saveAsCache:(BOOL)shouldSaveAsCache doneNotificationStr:(NSString *)doneNotificationStr {
  NSMutableDictionary *extraParameter=[NSMutableDictionary dictionary];
  [extraParameter setObject:[NSNumber numberWithBool:shouldSaveAsCache] forKey:OBJECTDOWNLOADER_SHOULDSAVE_KEY_TAG];
  
  if(doneNotificationStr != nil) {
    [extraParameter setObject:doneNotificationStr forKey:OBJECTDOWNLOADER_DONENOTIFICATION_KEY_TAG];
  }
  
  DownloadObject *newDownloadObj = [[DownloadObject alloc] initWithUrlStr:urlStr delegate:self];
  newDownloadObj.tag = BASE_DOWNLOADER_REMOTEFILE_TAG;
  newDownloadObj.extraParameter = extraParameter;
}

-(void)saveCacheFileWithUrlStr:(NSString*)urlStr data:(NSData*)data {
	NSString *stringPrefix=@"";
  NSString *hashedFileName=[NSString stringWithFormat:@"%u",[urlStr hash]];
	NSString *targetFilePathName=[NSString stringWithFormat:@"%@/%@%@",CACHE_FOLDER,stringPrefix,hashedFileName];
	[data writeToFile:targetFilePathName atomically:NO];
}

-(void)deleteCachedFileWithUrlStr:(NSString*)urlStr {
  NSString *stringPrefix=@"";
  NSString *hashedFileName=[NSString stringWithFormat:@"%u",[urlStr hash]];
	NSString *targetFilePathName=[NSString stringWithFormat:@"%@/%@%@",CACHE_FOLDER,stringPrefix,hashedFileName];
  [[NSFileManager defaultManager] removeItemAtPath:targetFilePathName error:nil];
}

#pragma mark - Init

-(id)init {
  if ((self = [super init])) {
  }
  
  return self;
}

@end
