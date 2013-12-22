//
//  ListView.m
//  MovieApi
//
//  Created by Ian Fan on 19/12/2013.
//  Copyright (c) 2013 Ian Fan. All rights reserved.
//

#import "ListView.h"

@implementation ListView


#pragma mark - Control

-(void)changeEditModeIsOn:(BOOL)isOn {
  if (isOn == YES) {
    [_tableView setEditing:YES animated:YES];
    [_editButton setSelected:YES];
  }else {
    [_tableView setEditing:NO animated:YES];
    [_editButton setSelected:NO];
  }
}

-(void)editButtonTapped:(id)sender event:(id)event {
  if (_tableView.isEditing == YES) {
    [self changeEditModeIsOn:NO];
  }else {
    [self changeEditModeIsOn:YES];
  }
}

-(void)accessoryButtonTapped:(id)sender event:(id)event {
//  NSSet *touches = [event allTouches];
//  UITouch *touch = [touches anyObject];
//  CGPoint currentTouchPosition = [touch locationInView:_tableView];
//  NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint: currentTouchPosition];
  
//  if (indexPath != nil) [self tableView:_tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

#pragma mark - Table view delegate

- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  //  [self tableView:_tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
  /*
   <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   */
}

// Override to support conditional editing of the table view.
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return NO;
}

// Override to support conditional rearranging of the table view.
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the item to be re-orderable.
  return NO;
}

// Override to support editing the table view.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
  }
  else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }
}

// Override to support rearranging the table view.
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [[[DataSingleton sharedInstance] listItemArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  //normal cell
  /*
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  //default cell
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  ListItem *item = [[[DataSingleton sharedInstance] listItemArray] objectAtIndex:[indexPath row]];
  
  [cell.textLabel setText:item.list_titleStr];
  cell.textLabel.textColor = [UIColor blackColor];
  [cell.textLabel setNumberOfLines:5];
   
  //longtapGesture
  UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
  longPressGesture.minimumPressDuration = 1.0;
  [cell addGestureRecognizer:longPressGesture];
  */

  //cusomized cell
  static NSString *cellIdentifier = @"List_iPhone_TableiVewCell";
  List_iPhone_TableiVewCell *cell = (List_iPhone_TableiVewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (cell == nil) {
    cell = [[List_iPhone_TableiVewCell alloc] init];
  }
  [cell prepareCell];
  
  // Configure the cell...
  //text:title,year,rating
  ListItem *item = [[[DataSingleton sharedInstance] listItemArray] objectAtIndex:[indexPath row]];
  cell.titleLabel.text = item.list_titleStr;
  cell.subTitleLabel.text = [NSString stringWithFormat:@"Year:  %@\nRating: %@",item.list_yearStr,item.list_ratingStr];
  
  //check image
  NSString *imageUrlStr = item.list_posterUrlStr;
  if ([[DataSingleton sharedInstance] isCachedUrlStrExist:imageUrlStr] == YES) {
    NSData *data = [[DataSingleton sharedInstance] returnCachedFileWithUrlStr:imageUrlStr];
    UIImage *image = [UIImage imageWithData:data];
    
    [cell.imageView setImage:image];
    [cell.activityIndicatorView stopAnimating];
  }else {
    [[DataSingleton sharedInstance] downloadFileWithUrlStr:imageUrlStr saveAsCache:YES doneNotificationStr:imageUrlStr];
    [cell waitDoneNotification:imageUrlStr];
    [cell.activityIndicatorView startAnimating];
  }
  
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  float cellHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 100:80;
  return cellHeight;
}

#pragma mark - Gesture

-(void)tapGesture:(UITapGestureRecognizer*)sender {
  //  [_tableView scrollToRowAtIndexPath:0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
  [_tableView setContentOffset:CGPointZero animated:YES];
  //  [theTableView setContentOffset: animated:YES];
}

-(void)cellLongPress:(UILongPressGestureRecognizer*)sender {
  if (sender.state == UIGestureRecognizerStateBegan){
    [self editButtonTapped:nil event:nil];
  }
}

#pragma mark - Setup

-(void)setupHeaderBarView {
  /*
  float headbarHeight = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)? HISTORYVIEW_HEADBAR_HEIGHT_PAD:HISTORYVIEW_HEADBAR_HEIGHT_PHONE;
  self.headerBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, headbarHeight)];
  
  UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)]autorelease];
  [_headerBarView addGestureRecognizer:tapGesture];
  
  [self addSubview:_headerBarView];
  
  UILabel *headbarLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _headerBarView.frame.size.width, _headerBarView.frame.size.height)];
  headbarLabel.textAlignment = NSTextAlignmentCenter;
  headbarLabel.text = @"Favorite Record";
  float headbarSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 24:18;
  [headbarLabel setFont:[UIFont fontWithName:FONT_NAME_TITLE size:headbarSize]];
  [_headerBarView addSubview:headbarLabel];
  
  //deleteButton
  float buttonSize = 44;
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(_headerBarView.frame.size.width-15-buttonSize, _headerBarView.center.y-0.5*buttonSize, buttonSize, buttonSize);
  [button setContentMode:UIViewContentModeScaleToFill];
  [button setBackgroundImage:[UIImage imageNamed:@"button_trash.png"] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"button_trash_highlighted.png"] forState:UIControlStateSelected];
  [button addTarget:self action:@selector(editButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
  self.editButton = button;
  [_headerBarView addSubview:_editButton];
  //  cell.accessoryView = button;
   */
}

-(void)setupTableView {
  float headbarHeight = 20;
  self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, headbarHeight, self.frame.size.width, self.frame.size.height-headbarHeight)];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  if ([[[DataSingleton sharedInstance] listItemArray] count] > 0) [_tableView reloadData];
  
  [self addSubview:_tableView];
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self setupHeaderBarView];
    [self setupTableView];
  }
  return self;
}

-(void)dealloc {
  self.listViewDelegate = nil;
//  if (_headerBarView != nil) self.headerBarView = nil;
//  if (_editButton != nil) self.editButton = nil;
//  if (_tableView != nil) self.tableView = nil;
}

@end
