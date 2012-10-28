//
//  FCItemService.m
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import "FCItemService.h"

#define BASE_URL @"http://flendapi.azurewebsites.net"

@interface FCItemService ()

@property (nonatomic, strong) NSURL *baseUrl;

- (void)parseInvalidResponseData:(NSData *)responseData;
- (NSArray *)parseItemsResponseData:(NSData *)responseData;

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
    httpRequest.HTTPMethod = @"POST";
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
                
            } else if (httpResponse.statusCode == 200) {
                NSArray *items = [self parseItemsResponseData:responseData];
                
                [self.delegate didGetItems:items];
            } else {
                [self parseInvalidResponseData:responseData];
            }
        });
    });
}

#pragma mark - JSON response parsers
    
- (NSArray *)parseItemsResponseData:(NSData *)responseData
{
    return nil;
}

- (void)parseInvalidResponseData:(NSData *)responseData
{
}

@end
