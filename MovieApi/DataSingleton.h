//
//  DataSingleton.h
//  MovieApi
//
//  Created by Ian Fan on 19/12/2013.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ObjectDownloader.h"
#import "DownloadObject.h"

#define DOCUMENTS_FOLDERZ [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define CACHE_FOLDER [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define OBJECTDOWNLOADER_SHOULDSAVE_KEY_TAG @"bShouldSave"
#define OBJECTDOWNLOADER_DONENOTIFICATION_KEY_TAG @"DoneNotification"

#define ASIHTTPREQUEST_TIMEOUT  90

#define BASE_DOWNLOADER_REMOTEFILE_TAG    88888

#define RESULT_TAG  @"Result"
#define DATA_TAG    @"Data"
#define URLSTR_TAG     @"Url"
#define ERROR_TAG   @"Error"

#define DOWNLOADER_TAG_CHAPTERCONTENTFILE_AND_FULL           68999

@interface DataSingleton : NSObject <DownloadObjectDelegate>

+(id)sharedInstance;

@property (nonatomic,retain) NSMutableArray *listItemArray;

//Cache
-(BOOL)isCachedUrlStrExist:(NSString*)urlStr;
-(NSData*)returnCachedFileWithUrlStr:(NSString*)urlStr;
-(NSString*)returnCachedFilePathStrWithUrlStr:(NSString*)urlStr;
-(void)downloadFileWithUrlStr:(NSString*)urlStr saveAsCache:(BOOL)shouldSaveAsCache doneNotificationStr:(NSString*)doneNotificationStr;
-(void)saveCacheFileWithUrlStr:(NSString*)urlStr data:(NSData*)data;
-(void)deleteCachedFileWithUrlStr:(NSString*)urlStr;

@end
