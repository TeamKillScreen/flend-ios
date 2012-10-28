//
//  FCItemService.m
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "FCItemService.h"
#import "FCItem.h"

#define BASE_URL @"http://flendapi.azurewebsites.net"

@interface FCItemService ()

@property (nonatomic, strong) NSURL *baseUrl;

- (void)handleInvalidResponseData:(NSData *)responseData httpStatusCode:(NSInteger)httpStatusCode;
- (void)handleItemsResponseData:(NSData *)responseData;

@end

@implementation FCItemService

#pragma mark - Synthesize properties

@synthesize baseUrl = _baseUrl;
@synthesize delegate;

#pragma mark - FCItemServiceImpl

- (NSURL *)baseUrl
{
    if (!_baseUrl) {
        _baseUrl = [NSURL URLWithString:BASE_URL];
    }
    
    return _baseUrl;
}

- (void)getItems
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Create request.
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.baseUrl, @"items.json"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *httpRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSLog(@"urlString: %@", urlString);
    NSLog(@"url: %@", url.description);
    
    // Formulate request.
    httpRequest.HTTPMethod = @"GET";
    // [httpRequest setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    httpRequest.timeoutInterval = 30; // seconds
    
    // Send request.
    __block NSHTTPURLResponse *httpResponse;
    __block NSError *error;
    
    dispatch_async(globalQueue, ^{
        NSData *responseData = [NSURLConnection sendSynchronousRequest:httpRequest
                                                     returningResponse:&httpResponse
                                                                 error:&error];
        
        dispatch_async(mainQueue, ^{
            NSString *errorMessage;
            
            if (error) {
                // Failed, likely a network error.
                errorMessage = error.localizedDescription;
                
                NSLog(@"%@", errorMessage);
                
            } else if (httpResponse.statusCode == 200) {
                [self handleItemsResponseData:responseData];
                
            } else {
                NSLog(@"httpResponse.statusCode: %d.", httpResponse.statusCode);
                [self handleInvalidResponseData:responseData httpStatusCode:httpResponse.statusCode];
                
            }
        });
    });
}

#pragma mark - JSON response handlers
    
- (void)handleItemsResponseData:(NSData *)responseData
{
    NSError *error;
    
    NSArray* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:0
                          error:&error];
    
    if (error) {
        [self.delegate didFailToGetItems:error.localizedDescription];
        return;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (NSDictionary *each in json) {
        FCItem *item = [[FCItem alloc] init];

        item.itemId = [each objectForKey:@"id"];

        item.title = [each objectForKey:@"title"];
        item.description = [each objectForKey:@"description"];

        item.postcode = [each objectForKey:@"postcode"];
        
        NSString *latString = [each objectForKey:@"lat"];
        NSString *lngString = [each objectForKey:@"lng"];
        
        double lat = [latString doubleValue];
        double lon = [lngString doubleValue];
        
        CLLocationCoordinate2D coordinate;
        
        coordinate.latitude = lat;
        coordinate.longitude = lon;
        
        item.coordinate = coordinate;
        
        [items addObject:item];
    }
    
    [self.delegate didGetItems:items];
}

- (void)handleInvalidResponseData:(NSData *)responseData httpStatusCode:(NSInteger)httpStatusCode
{
    NSLog(@"handleInvalidResponseData: %d.", httpStatusCode);
}

@end
