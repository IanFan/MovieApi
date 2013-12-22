//
//  DownloadObject.h
//  MovieApi
//
//  Created by Ian Fan on 20/12/2013.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OBJECTDOWNLOADER_SHOULDSAVE_KEY_TAG @"bShouldSave"
#define OBJECTDOWNLOADER_DONENOTIFICATION_KEY_TAG @"DoneNotification"

@protocol DownloadObjectDelegate;

@interface DownloadObject : NSObject
{
  BOOL _shouldCancel;
}

@property (nonatomic,assign) id <DownloadObjectDelegate> downloadObjectDelegate;
@property NSInteger tag;
@property (nonatomic,retain) NSString *downloadUrlStr;
@property (nonatomic,retain) id extraParameter;
@property (nonatomic,retain) NSMutableData *respondData;

-(DownloadObject*)initWithUrlStr:(NSString*)urlStr delegate:(id<DownloadObjectDelegate>)delegete;
-(void)cancel;

@end

@protocol DownloadObjectDelegate <NSObject>
@optional
- (void)downloadObjectDelegateDownloadSuccessWithData:(NSData*)resultData byDownloader:(DownloadObject*)theDownloader;
- (void)downloadObjectDelegateDownloadFailWithError:(NSError*)resultError byDownloader:(DownloadObject*)theDownloader;
- (void)downloadObjectDelegateDownloadCancelByDownloader:(DownloadObject*)theDownloader;
@end
