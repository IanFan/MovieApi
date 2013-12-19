//
//  ViewController.m
//  MovieApi
//
//  Created by Ian Fan on 19/12/2013.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
  BOOL isWifi = [[ReachabilityManager sharedInstance] isWifi];
  NSLog(@"isWifi = %d",isWifi);
  
  [self connectToMovieApiAndSearchHobbit];
}

#pragma mark - Function

-(void)connectToMovieApiAndSearchHobbit {
  NSString *hostStr = @"http://api.movies.io/movies/search";
  NSString *keywordStr = @"hobbit";
  NSString *urlStr = [NSString stringWithFormat:@"%@?q=%@",hostStr,keywordStr];
  NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:12.0];
  NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
  
  if (urlConnection) {
    self.responseData = [NSMutableData data];
  }

}

#pragma mark - Connection

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  [_responseData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [_responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  _responseData = nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  NSString *resultStr = [[NSString alloc]initWithData:_responseData encoding:NSUTF8StringEncoding];
  NSLog(@"ResultStr = %@", resultStr);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
