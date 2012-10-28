//
//  FCItemViewController.m
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import "FCItemViewController.h"

@interface FCItemViewController ()

@property (nonatomic, strong) FCItem *item;

@end

@implementation FCItemViewController

@synthesize item = _item;

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
}

@end
