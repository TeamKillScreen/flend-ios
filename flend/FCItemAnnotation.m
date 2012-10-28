//
//  FCItemAnnotation.m
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import "FCItemAnnotation.h"
#import "FCItem.h"

@interface FCItemAnnotation ()

@property (nonatomic, strong) FCItem *item;

@end

@implementation FCItemAnnotation

@synthesize item = _item;

- (FCItemAnnotation *)initWithItem:(FCItem *)item
{
    self = [self init];
    
    if (self) {
        _item = item;
    }
    
    return self;
}

@end
