//
//  FCItemViewController.h
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FCItem.h"

@interface FCItemViewController : UIViewController

- (FCItemViewController *)initWithItem:(FCItem *)item;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;

@end
