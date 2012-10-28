//
//  FCItemViewController.m
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import "FCItemViewController.h"
#import "FCItemService.h"

@interface FCItemViewController ()

@property (nonatomic, strong) FCItem *item;

@end

@implementation FCItemViewController

@synthesize item = _item;
@synthesize titleTextField = _titleTextField;
@synthesize descriptionTextField = _descriptionTextField;

// Designated initializer.
- (FCItemViewController *)initWithItem:(FCItem *)item
{
    self = [super init];
    
    if (self) {
        self.item = item;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Cancel button.
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(cancel)];
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone  target:self action:@selector(done)];
    
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
}

- (void)cancel
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)done
{
    FCItemService *service = [[FCItemService alloc] init];
    FCItem *item = [[FCItem alloc] init];
    
    item.title = self.titleTextField.text;
    item.description = self.descriptionTextField.text;
    item.postcode = @"OL12 9NU";
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [service addItem:item];
}

@end
