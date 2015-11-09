//
//  ViewController.m
//  To-do
//
//  Created by Fabio General on 10/9/15.
//  Copyright © 2015 Fabio General. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.todos = @[@{@"name" : @"write your to-do", @"category" : @"Home"}, @{@"name" : @"write your to-do", @"category" : @"Work"}].mutableCopy;
    self.categories = @[@"Home", @"Work", @"Completed"];

    // Declaring add button
    // it needs to be instantiated after all stop
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewTodo:)];
    self.navigationItem.rightBarButtonItem = addButton;
    // Edit Button
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Add to-dos

//@synthesize someObject = _someObject; // to provide setter AND getter
//or @synthesize someObject;

/* to accessor method for a property - “lazy accessor” GETTER [https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html]
 
 - (XYZObject *)someObject {
 if (!_someObject) _someObject = [[XYZObject alloc] init];
 return _someObject;
 }*/

/* method to SETTER
 
 - (void)setsomeObject:(XYZObject *)someObject {
 if (someObject = [self something]) {
 _someObject = someObject;
 }
 }*/

@synthesize todos;

#pragma mark - Table View

// Helper methods
- (NSArray *)todosInCategory:(NSString *)targetCategory {
    NSPredicate *matchingPredicate = [NSPredicate predicateWithFormat:@"category == %@", targetCategory];
    NSArray *categoryTodos = [todos filteredArrayUsingPredicate:matchingPredicate];
    
    return categoryTodos;
}

- (NSInteger)numberOfTodosInCategory:(NSString *)targetCategory {
    return [self todosInCategory:targetCategory].count;
}

- (NSDictionary *)todosAtIndexPath:(NSIndexPath *)indexPath {
    NSString *category = self.categories[indexPath.section];
    NSArray *categoryTodos = [self todosInCategory:category];
    NSDictionary *todo = categoryTodos[indexPath.row];
    
    return todo;
}

// Copied from Master-detail application

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.categories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfTodosInCategory:self.categories[section]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.categories[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Changing to text field
    if ([indexPath row] >= 0) {
        UITextField *useTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 8, cell.contentView.bounds.size.width - 60, 30)];
        // Passing to insert new to-do
        NSDictionary *todo = self.todos[indexPath.row];
        useTextField.placeholder = todo[@"name"];
        useTextField.backgroundColor = [UIColor whiteColor]; // trick to hide reusablecell deleted
        [cell.contentView addSubview:useTextField];
        // Setting Return Key Button
        useTextField.returnKeyType = UIReturnKeyDone;
        [useTextField addTarget:self action:@selector(insertNewTodo:) forControlEvents:UIControlEventEditingDidEndOnExit];
    }
    return cell;
}

// Inserting New To-do
- (void)insertNewTodo:(id)sender {
    if (!todos) todos = [[NSMutableArray alloc] init];
    NSDictionary *createTodo = @{@"name" : @"write your to-do", @"category" : @"Home"};
    [todos addObject:createTodo];
    
    NSInteger numHomeTodos = [self numberOfTodosInCategory:@"Home"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numHomeTodos - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

// Finishing New To-do
- (BOOL)finishedTodo:(UITextField *)textField {
    [self.view endEditing:YES];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewTodo:)];
    self.navigationItem.rightBarButtonItem = addButton;
    return YES;
}

// Editing To-do
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // Moving to completed section
        [self.todos removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSDictionary *addObject = @{@"name" : @"teste", @"category" : @"Completed"};
        [self.todos addObject:addObject];
        NSInteger numCompletedTodos = [self numberOfTodosInCategory:@"Completed"];
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:numCompletedTodos - 1 inSection:2];
        [self.tableView insertRowsAtIndexPaths:@[toIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // fix checkmark new-todo
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [self.todos removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
