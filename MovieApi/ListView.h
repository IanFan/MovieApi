//
//  ListView.h
//  MovieApi
//
//  Created by Ian Fan on 19/12/2013.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListItem.h"
#import "List_iPhone_TableiVewCell.h"

@protocol ListViewDelegate;

@interface ListView : UIView <UITableViewDataSource, UITableViewDelegate>
{
  
}

@property (nonatomic,assign) id <ListViewDelegate> listViewDelegate;
@property (nonatomic,retain) UIView *headerBarView;
@property (nonatomic,retain) UIButton *editButton;
@property (nonatomic,retain) UITableView *tableView;

//control
-(void)changeEditModeIsOn:(BOOL)isOn;

@end

@protocol ListViewDelegate <NSObject>
@optional
-(void)ListViewDelegateShowMailViewMethod;
@end
