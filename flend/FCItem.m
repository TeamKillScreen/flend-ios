//
//  FCItem.m
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import "FCItem.h"

@interface FCItem ()

@end

@implementation FCItem

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (FCItem *)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle
{
    self = [super init];
    
    if (self) {
        _coordinate.latitude = coordinate.latitude;
        _coordinate.longitude = coordinate.longitude;
        
        _title = title;
        _subtitle = subtitle;
    }
    
    return self;
}

@end
