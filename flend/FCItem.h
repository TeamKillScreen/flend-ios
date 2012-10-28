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

- (FCItem *)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle;

@property (readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *subtitle;

@end
