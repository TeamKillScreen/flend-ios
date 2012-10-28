//
//  FCItemTableViewController.m
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import "FCItemTableViewController.h"
#import "FCItem.h"

@interface FCItemTableViewController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation FCItemTableViewController

@synthesize items = _items;

- (id)initWithItems:(NSArray *)items
{
    self = [super init];
    
    if (self) {
        self.items = items;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Items";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"FCItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    FCItem *item = (FCItem *)[self.items objectAtIndex:indexPath.row];
    NSString *format = @"%@ (%@)";
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:format, item.description, item.postcode];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
