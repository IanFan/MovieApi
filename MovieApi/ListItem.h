//
//  ListItem.h
//  MovieApi
//
//  Created by Ian Fan on 19/12/2013.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListItem : NSObject
{
}

@property (nonatomic,retain) NSString *list_titleStr;
@property (nonatomic,retain) NSString *list_yearStr;
@property (nonatomic,retain) NSString *list_ratingStr;
@property (nonatomic,retain) NSString *list_posterUrlStr;

@end
