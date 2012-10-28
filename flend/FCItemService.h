//
//  FCItemService.h
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FCItemServiceDelegate.h"

@interface FCItemService : NSObject

@property (nonatomic, weak) id <FCItemServiceDelegate> delegate;

- (void)getItems;

@end
