//
//  FCItem.h
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FCItem : NSObject

@property CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSString *itemId;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) NSString *postcode;

@end
