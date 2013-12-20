//
//  ViewController.m
//  MovieApi
//
//  Created by Ian Fan on 19/12/2013.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import "ViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestKivaLoansURL [NSURL URLWithString: @"http://api.movies.io/movies/search?q=hobbit"] //2

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
  BOOL isInternetConnected = ([[ReachabilityManager sharedInstance] isWifi] || [[ReachabilityManager sharedInstance] isWWAN])? YES:NO;
  NSLog(@"isWifi = %d",isInternetConnected);
  
  [self setupListView];
  
  [self connectToMovieApiAndSearchHobbit];
}

#pragma mark - Connection

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

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  [_responseData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [_responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  _responseData = nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSError *error;
  
  NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableLeaves error:&error];
  NSArray *array = [rootDictionary objectForKey:@"movies"];
  [self sortWithRootArray:array];
}

#pragma mark - SortRootArray

-(void)sortWithRootArray:(NSArray*)rootArray {
  if ([rootArray count] == 0) return;
  
  NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
  
  for (int i=0; i<[rootArray count]; i++) {
    NSDictionary *loan = [rootArray objectAtIndex:i];
    
    NSString *title = [loan objectForKey:@"title"];
    NSString *year = [loan objectForKey:@"year"];
    NSString *rating = [loan objectForKey:@"rating"];
    NSDictionary *posterDic = [loan objectForKey:@"poster"];
    NSDictionary *posterUrlsDic = [posterDic objectForKey:@"urls"];
    NSString *postStr = [posterUrlsDic objectForKey:@"original"];
    
    ListItem *item = [[ListItem alloc] init];
    item.list_titleStr = title;
    item.list_yearStr = year;
    item.list_ratingStr = rating;
    item.list_posterUrlStr = postStr;
    
    [sortedArray addObject:item];
  }
  
  [[DataSingleton sharedInstance] setListItemArray:sortedArray];
  [_listView.tableView reloadData];
}

#pragma mark - ListView

-(void)setupListView {
  CGRect winRect = self.view.frame;
  
  _listView = [[ListView alloc]initWithFrame:CGRectMake(0, 0, winRect.size.width, winRect.size.height)];
  _listView.listViewDelegate = self;
  [self.view addSubview:_listView];
}

#pragma mark - Delegate

//-(void)ListViewDelegateShowMailViewMethod {
//  
//}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
