//
//  List_iPhone_TableiVewCell.m
//  MovieApi
//
//  Created by Ian Fan on 20/12/2013.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import "List_iPhone_TableiVewCell.h"

@implementation List_iPhone_TableiVewCell

@synthesize imageView=_imageView;

#pragma mark - Cell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animate {
  [super setHighlighted:highlighted animated:animate];
}

- (void) prepareCell {
  [self removeAllNotificationWaitting];
}

- (void)waitDoneNotification:(NSString*)doneNotification {
  // Wait the Notificatio of downloading done!
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDoneNotification:) name:doneNotification object:nil];
  
  if(_targetDoneNotification != nil)
    [self removeAllNotificationWaitting];
  
  self.targetDoneNotification = doneNotification;
//  targetDoneNotification=[doneNotification retain];
}

#pragma mark - Notification

- (void) getDoneNotification:(NSNotification*)notification {
//  NSLog(@"getNotification");
  [_imageView setImage:[UIImage imageWithData:[[DataSingleton sharedInstance] returnCachedFileWithUrlStr:[notification name]]]];
  [_activityIndicatorView stopAnimating];
  
  [self removeAllNotificationWaitting];
}

- (void) removeAllNotificationWaitting {
  if(_targetDoneNotification != nil)
    {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_targetDoneNotification object:nil];
    
//    [targetDoneNotification release];
    self.targetDoneNotification = nil;
    }
}

- (void)layoutSubviews {
  [super layoutSubviews];
}

#pragma mark - Init

-(void)setupCell {
  CGRect cellFrame = CGRectMake(0, 0, 320, 80);
  float boardSpace = 5;
  
  //cell
  self.frame = cellFrame;
  
  //background
  self.backgroundImageView = [[UIImageView alloc]init];
  _backgroundImageView.frame = cellFrame;
  [self addSubview:_backgroundImageView];
  [self sendSubviewToBack:_backgroundImageView];
  
  //imageView
  self.imageView = [[UIImageView alloc]init];
  _imageView.frame = CGRectMake(boardSpace, boardSpace, cellFrame.size.height-2*boardSpace, cellFrame.size.height-2*boardSpace);
  [_imageView setContentMode:UIViewContentModeScaleAspectFit];
  [self addSubview:_imageView];
  
  //activityIndicatorView
  self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  _activityIndicatorView.frame = CGRectMake(_imageView.center.x-15, _imageView.center.y-15, 30, 30);
  [_imageView addSubview:_activityIndicatorView];
  
  //title
  self.titleLabel = [[UILabel alloc] init];
  _titleLabel.frame = CGRectMake(_imageView.frame.origin.x+_imageView.frame.size.width+boardSpace, boardSpace, 200, 0.5*(cellFrame.size.height-2*boardSpace));
  [self addSubview:_titleLabel];
  _titleLabel.numberOfLines = 2;
  _titleLabel.adjustsFontSizeToFitWidth = YES;
  
  //subitle
  self.subTitleLabel = [[UILabel alloc] init];
  _subTitleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, _titleLabel.frame.size.width, 0.4*(cellFrame.size.height-2*boardSpace));
  [self addSubview:_subTitleLabel];
  _subTitleLabel.numberOfLines = 2;
  [_subTitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    
    [self setupCell];
  }
  return self;
}

@end
