//
//  FCItemAnnotation.h
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "FCItem.h"

@interface FCItemAnnotation : NSObject <MKAnnotation>

- (FCItemAnnotation *)initWithItem:(FCItem *)item;

- (NSString *)title;
- (NSString *)subtitle;

- (CLLocationCoordinate2D)coordinate;

@end
