//
//  FCItemServiceDelegate.h
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FCItem.h"

@protocol FCItemServiceDelegate <NSObject>

- (void)didAddItem:(FCItem *)item;
- (void)didGetItems:(NSArray *)items;
- (void)didFailToGetItems:(NSString* )message;

@end
