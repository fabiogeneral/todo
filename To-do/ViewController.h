//
//  ViewController.h
//  To-do
//
//  Created by Fabio General on 10/9/15.
//  Copyright © 2015 Fabio General. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController

// instance variables
@property (nonatomic) NSMutableArray *todos;
@property (nonatomic) UIBarButtonItem *addButton;

// methods
- (void)insertNewTodo:(id)sender;

@end

