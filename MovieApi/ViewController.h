//
//  ViewController.h
//  MovieApi
//
//  Created by Ian Fan on 19/12/2013.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListView.h"

@interface ViewController : UIViewController <ListViewDelegate>
{
  ListView *_listView;
}

@property (nonatomic,retain) NSMutableData *responseData;

@end
