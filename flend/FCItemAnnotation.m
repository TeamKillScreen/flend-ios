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

- (NSString *)title
{
    return self.item.title;
}

- (NSString *)subtitle
{
    NSString *subtitle;
    
    if (self.item.postcode ) {
        subtitle = [NSString stringWithFormat:@"%@ (%@)", self.item.description, self.item.postcode];
    } else {
        subtitle = self.item.description;
    }
    
    return subtitle;
}

- (CLLocationCoordinate2D)coordinate
{
    return self.item.coordinate;
}

@end
