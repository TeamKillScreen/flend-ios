//
//  FCItemService.m
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import <Foundation/Foundation.h>
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

- (void)addItem:(FCItem *)item
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Create request.
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.baseUrl, @"items.json"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *httpRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSLog(@"urlString: %@", urlString);
    NSLog(@"url: %@", url.description);
    
    NSMutableDictionary *itemDictionary = [[NSMutableDictionary alloc] init];
    
    [itemDictionary setValue:item.title forKey:@"title"];
    [itemDictionary setValue:item.description forKey:@"description"];
    [itemDictionary setValue:@"M3 4FP" forKey:@"postcode"];
    [itemDictionary setValue:@"508c4f5ee4b0c86b6b5eac22" forKey:@"category"];
    [itemDictionary setValue:@"508cb848e4b0c54ca4492bae" forKey:@"userId"];
    
    NSMutableDictionary *itemsDictionary = [[NSMutableDictionary alloc] init];
    
    [itemsDictionary setObject:itemDictionary forKey:@"items"];
    
    NSError *jsonError;
    NSData *json = [NSJSONSerialization dataWithJSONObject:itemsDictionary options:NSJSONWritingPrettyPrinted error: &jsonError];
    
    if (jsonError) {
        NSLog(@"JSON error: %@", jsonError.localizedDescription);
        return;
    }

    NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];

    
    NSLog(@"jsonString: %@", jsonString);
    
    // Formulate request.
    httpRequest.HTTPMethod = @"POST";
    [httpRequest setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    httpRequest.HTTPBody = json;
    httpRequest.timeoutInterval = 60; // seconds
    
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
                                
            } else {
                NSLog(@"httpResponse.statusCode: %d.", httpResponse.statusCode);
                
            }
        });
    });
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
    httpRequest.timeoutInterval = 60; // seconds
    
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
