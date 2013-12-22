//
//  DownloadObject.m
//  MovieApi
//
//  Created by Ian Fan on 20/12/2013.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import "DownloadObject.h"

@implementation DownloadObject

#pragma mark - Init

-(DownloadObject*)initWithUrlStr:(NSString *)urlStr delegate:(id<DownloadObjectDelegate>)delegete {
  self = [super init];
  
  if (self) {
    // Initialization code
    self.downloadUrlStr = urlStr;
    self.downloadObjectDelegate = delegete;
    
    [self startDownload];
  }
  
  return self;
}

-(void)dealloc {
  self.downloadUrlStr = nil;
  _downloadObjectDelegate = nil;
  self.extraParameter = nil;
}

#pragma mark

-(void)startDownload {
  NSURL *url = [NSURL URLWithString:_downloadUrlStr];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
  NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
  
  if (connection) {
    self.respondData = [NSMutableData data];
  }
  
  request = nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  [_respondData setLength:0];
  
  if(_shouldCancel == YES) {
    [connection cancel];
    
    // Report to delegate
    if ([_downloadObjectDelegate respondsToSelector:@selector(downloadObjectDelegateDownloadCancelByDownloader:)])
      [_downloadObjectDelegate downloadObjectDelegateDownloadCancelByDownloader:self];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
  [_respondData appendData:data]; //  Data will be appended to here!
  
  if(_shouldCancel == YES) {
    [connection cancel];
    // Report to delegate
    if ([_downloadObjectDelegate respondsToSelector:@selector(downloadObjectDelegateDownloadCancelByDownloader:)])
      [_downloadObjectDelegate downloadObjectDelegateDownloadCancelByDownloader:self];
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error {
  // Report to delegate
  if ([_downloadObjectDelegate respondsToSelector:@selector(downloadObjectDelegateDownloadFailWithError:byDownloader:)])
    [_downloadObjectDelegate downloadObjectDelegateDownloadFailWithError:error byDownloader:self];
  
  // respondData need to be released if fail!
  //    [respondData release];
  self.respondData = nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
  if ([_downloadObjectDelegate respondsToSelector:@selector(downloadObjectDelegateDownloadSuccessWithData:byDownloader:)])
    [_downloadObjectDelegate downloadObjectDelegateDownloadSuccessWithData:_respondData byDownloader:self];
  
  // Release respondData
  self.respondData = nil;
}

-(void) cancel {
  _shouldCancel = YES;  // Will trigger the cancel action at next delegate methods
}

@end
