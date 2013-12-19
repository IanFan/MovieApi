//
//  ReachabilityManager.m
//  Diamond
//
//  Created by Ian Fan on 27/08/13.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import "ReachabilityManager.h"

@implementation ReachabilityManager

+(id)sharedInstance {
  static id shared = nil;
  if (shared == nil) shared= [[ReachabilityManager alloc]init];
  
  return shared;
}

#pragma mark Alert

-(BOOL)checkInternetAndAlert {
  BOOL isConnect = NO;
  if (_isWifi == YES || _isWWAN == YES) isConnect = YES;
  
  if (isConnect == YES) {
    return YES;
  }else {
    [self showInternetAlertViewWithIsConnected:NO];
  }
  
  return isConnect;
}

#pragma mark - Alert

-(void)showInternetAlertViewWithIsConnected:(BOOL)isConnected {
  NSString *str;
  if (isConnected == YES) {
    switch ([LocalObject rtnIntByDeviceCurrentLanguage]) {
        //    case Language_SimplifiedChinese: str = @"请检查网路"; break;
        //    case Language_TraditionalChinese: str = @"請檢查網路"; break;
      default: str = @"Internet is connected."; break;
    }
  }else {
    switch ([LocalObject rtnIntByDeviceCurrentLanguage]) {
        //    case Language_SimplifiedChinese: str = @"请检查网路"; break;
        //    case Language_TraditionalChinese: str = @"請檢查網路"; break;
      default: str = @"Please check internet connection."; break;
    }
  }
  
  [self launchInterludeAlertWithMessage:str];
  [self performSelector:@selector(dismissInterludeAlert) withObject:nil afterDelay:2.0];
}

-(void)launchInterludeAlertWithMessage:(NSString *)targetMessage {
  if(_interludeAlertView != nil) return;
  
  _interludeAlertView = [[UIAlertView alloc] initWithTitle:@"" message:targetMessage delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
  UIActivityIndicatorView *waitView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  waitView.frame = CGRectMake(127, 74, 30, 30);
  [waitView startAnimating];
  [_interludeAlertView addSubview:waitView];
//  [waitView release];
  
  [_interludeAlertView show];
}

-(void)dismissInterludeAlert{
  if(_interludeAlertView != nil){
    [_interludeAlertView dismissWithClickedButtonIndex:0 animated:YES];
//    [_interludeAlertView release];
    _interludeAlertView = nil;
  }
}

#pragma mark ReachbilityChanged

-(void) reachabilityChanged:(NSNotification *)note {
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}


-(void)updateInterfaceWithReachability:(Reachability *)reachability {
  if (reachability == self.hostReachability) {
    //		[self configureTextField:self.remoteHostStatusField imageView:self.remoteHostImageView reachability:reachability];
//    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    
//    self.summaryLabel.hidden = (netStatus != ReachableViaWWAN);
    NSString* baseLabelText = @"";
    
    if (connectionRequired) {
      baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
    } else {
      baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
    }
//    self.summaryLabel.text = baseLabelText;
  }
  
	if (reachability == self.internetReachability) {
		[self configureTextField:nil imageView:nil reachability:reachability];
  }
  
	if (reachability == self.wifiReachability) {
		[self configureTextField:nil imageView:nil reachability:reachability];
  }
}


- (void)configureTextField:(UITextField *)textField imageView:(UIImageView *)imageView reachability:(Reachability *)reachability {
  NetworkStatus netStatus = [reachability currentReachabilityStatus];
  BOOL connectionRequired = [reachability connectionRequired];
//  NSString* statusString = @"";
  
  switch (netStatus) {
    case NotReachable: {
//      statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
//      imageView.image = [UIImage imageNamed:@"stop-32.png"] ;
      /*
       Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
       */
      NSLog(@"Rechability_NotReachable");
      _isWWAN = NO;
      _isWifi = NO;
      connectionRequired = NO;
    } break;
    
    case ReachableViaWWAN: {
      NSLog(@"Rechability_ReachableViaWWAN");
      _isWWAN = YES;
//      statusString = NSLocalizedString(@"Reachable WWAN", @"");
//      imageView.image = [UIImage imageNamed:@"WWAN5.png"];
    } break;
      
    case ReachableViaWiFi: {
      NSLog(@"Rechability_ReachableViaWiFi");
      _isWifi = YES;
//      statusString= NSLocalizedString(@"Reachable WiFi", @"");
//      imageView.image = [UIImage imageNamed:@"Airport.png"];
    } break;
  }
  
  if (connectionRequired) {
//    NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
//    statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
  
//  textField.text= statusString;
}

-(void)setupHostReachabilityWithRemoteHostName:(NSString*)remoteHostName {
  self.hostReachability = [Reachability reachabilityWithHostname:remoteHostName];
  [self.hostReachability startNotifier];
  [self updateInterfaceWithReachability:self.hostReachability];
}

-(void)setupInternetReachbility {
  self.internetReachability = [Reachability reachabilityForInternetConnection];
  [self.internetReachability startNotifier];
  [self updateInterfaceWithReachability:self.internetReachability];
}

-(void)setupWifiReachbility {
  self.wifiReachability = [Reachability reachabilityForLocalWiFi];
  [self.wifiReachability startNotifier];
  [self updateInterfaceWithReachability:self.wifiReachability];
}

#pragma mark - Init

-(id)init {
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    NSString *remoteHostName = @"http://www.google.com";
    [self setupHostReachabilityWithRemoteHostName:remoteHostName]; //unrecognized selector
    [self setupInternetReachbility];
    [self setupWifiReachbility];
    
  }
  
  return self;
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
//  if (_hostReachability != nil) [_hostReachability stopNotifier], [_hostReachability release], self.hostReachability = nil;
//  if (_internetReachability != nil) [_internetReachability stopNotifier], [_internetReachability release], self.internetReachability = nil;
//  if (_wifiReachability != nil) [_wifiReachability stopNotifier], [_wifiReachability release], self.wifiReachability = nil;
  
//  [super dealloc];
}

@end
