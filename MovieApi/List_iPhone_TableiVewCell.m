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
  NSData *data = [[DataSingleton sharedInstance] returnCachedFileWithUrlStr:[notification name]];
  if (data == nil) {
    NSString *noImageStr = nil;
    CurrentLanguage deviceCurrentLanguage = (CurrentLanguage)[LocalObject rtnIntByDeviceCurrentLanguage];
    switch (deviceCurrentLanguage) {
      case Language_TraditionalChinese: _imageLabel.numberOfLines = 2; noImageStr = [NSString stringWithFormat:@"%@\n%@",@"暫無",@"圖片"]; break;
      case Language_SimplifiedChinese: _imageLabel.numberOfLines = 2; noImageStr = [NSString stringWithFormat:@"%@\n%@",@"暂无",@"图片"]; break;
      default: _imageLabel.numberOfLines = 1; noImageStr = @"N/A"; break;
    }
    _imageLabel.text = noImageStr;
  }else {
   [_imageView setImage:[UIImage imageWithData:data]];
  }
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
  
  //imageLabel
  self.imageLabel = [[UILabel alloc]init];
  _imageLabel.frame = CGRectMake(0.1*_imageView.frame.size.width, 0.5*_imageView.frame.size.height-16, 0.8*_imageView.frame.size.width, 32);
  _imageLabel.adjustsFontSizeToFitWidth = YES;
  [_imageLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
  [_imageLabel setTextColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.2]];
  [_imageLabel setTextAlignment:NSTextAlignmentCenter];
  [_imageView addSubview:_imageLabel];
  
  //activityIndicatorView
  self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  _activityIndicatorView.frame = CGRectMake(0.5*_imageView.frame.size.width-15, 0.5*_imageView.frame.size.height-15, 30, 30);
  [_imageView addSubview:_activityIndicatorView];
  
  //title
  self.titleLabel = [[UILabel alloc] init];
  _titleLabel.frame = CGRectMake(_imageView.frame.origin.x+_imageView.frame.size.width+boardSpace, boardSpace, 200, 0.5*(cellFrame.size.height-2*boardSpace));
  [self addSubview:_titleLabel];
  _titleLabel.numberOfLines = 2;
  _titleLabel.adjustsFontSizeToFitWidth = YES;
  [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
  
  //subitle
  self.subTitleLabel = [[UILabel alloc] init];
  _subTitleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, _titleLabel.frame.size.width, 0.4*(cellFrame.size.height-2*boardSpace));
  [self addSubview:_subTitleLabel];
  _subTitleLabel.numberOfLines = 2;
  [_subTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:12]];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    
    [self setupCell];
  }
  return self;
}

#pragma mark - Memory

-(void)dealloc {
//  if (_activityIndicatorView != nil) self.activityIndicatorView = nil;
//  if (_imageLabel != nil) self.imageLabel = nil;
//  if (_imageView != nil) self.imageView = nil;
//  if (_titleLabel != nil) self.titleLabel = nil;
//  if (_subTitleLabel != nil) self.subTitleLabel = nil;
//  if (_backgroundImageView != nil) self.backgroundImageView = nil;
//  if (_targetDoneNotification != nil) self.targetDoneNotification = nil;
}

@end
