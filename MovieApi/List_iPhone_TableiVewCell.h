//
//  List_iPhone_TableiVewCell.h
//  MovieApi
//
//  Created by Ian Fan on 20/12/2013.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface List_iPhone_TableiVewCell : UITableViewCell
{
  
}

@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) UILabel *imageLabel;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *subTitleLabel;
@property (nonatomic,retain) UIImageView *backgroundImageView;

@property (nonatomic,retain) NSString *targetDoneNotification;

-(void)prepareCell;

-(void)waitDoneNotification:(NSString*)doneNotification;
-(void)removeAllNotificationWaitting;

@end
