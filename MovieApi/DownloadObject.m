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
  //[parentDelegate release];
  _downloadObjectDelegate = nil;
  self.extraParameter = nil;
  //  [super dealloc];
}

#pragma mark

-(void)startDownload {
//  _downloadUrlStr = @"http://cf2.imgobject.com/t/p/original/8KYEsBl0bT4V3HzOawohxlhIJB6.jpg";
  NSURL *url = [NSURL URLWithString:_downloadUrlStr];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
  NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
  
  NSLog(@"urlStr = %@",_downloadUrlStr);
  
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
                                 //NSLog(@"respond Data = %@",respondData);
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
  //    [respondData release];
  self.respondData = nil;
}

-(void) cancel {
  _shouldCancel = YES;  // Will trigger the cancel action at next delegate methods
}

@end
