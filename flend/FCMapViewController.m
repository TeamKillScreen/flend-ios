//
//  FCMapViewController.m
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "FCMapViewController.h"
#import "FCItemAnnotation.h"

#import "FCItemViewController.h"

#import "FCItemService.h"

@interface FCMapViewController () <CLLocationManagerDelegate, FCItemServiceDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;

- (void)showList;
- (void)refreshList;

@end

@implementation FCMapViewController

@synthesize locationManager = _locationManager;
@synthesize mapView = _mapView;

#pragma mark - UIViewController impl

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create and set up location manager.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Get items using external service.
    FCItemService *service = [[FCItemService alloc] init];
    
    service.delegate = self;
    [service getItems];
}

- (void)loadView
{
    [super loadView];
    
    // Create map view.
    self.mapView = [[MKMapView alloc] init];
    
    // Set up map view properties.
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    // Set up map view controller.
    self.view = self.mapView;
    
    self.title = @"Map";

    // List button.
    UIImage *listImage = [UIImage imageNamed:@"259-list.png"];
    UIBarButtonItem *listBarButtonItem = [[UIBarButtonItem alloc] initWithImage:listImage style:UIBarButtonItemStyleBordered target:self action:@selector(showList)];

    // Refresh button.
    /*
    UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshList)];
    */

    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(addItem)];

    self.navigationItem.leftBarButtonItem = addBarButtonItem;
    self.navigationItem.rightBarButtonItem = listBarButtonItem;
    
    self.view = self.mapView;
}

#pragma mark - MKMapView impl

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D location = userLocation.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 2000, 2000);
    
    [mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseIdentifier = @"ItemAnnotation";
    
    if ([annotation isKindOfClass:[FCItemAnnotation class]]) {
        FCItemAnnotation *itemAnnotation = (FCItemAnnotation *)annotation;
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:itemAnnotation reuseIdentifier:reuseIdentifier];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            annotationView.animatesDrop = YES;
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = button;
        } else {
            annotationView.annotation = itemAnnotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - FCMapViewController impl

- (void)showList
{
    UIViewController *tableViewController = [[UIViewController alloc] init];
    
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (void)addItem
{
    FCItemViewController *itemViewController = [[FCItemViewController alloc] init];
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:itemViewController];
    
    navigationViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self.navigationController presentViewController:navigationViewController animated:YES completion:^{
        // Do nothing on completion.
    }];
}

- (void)refreshList
{
}

#pragma mark - FCItemServiceDelegate impl

- (void)didGetItems:(NSArray *)items
{
    for (NSDictionary *each in items) {
        FCItem *item = (FCItem *)each;
        FCItemAnnotation *annotation = [[FCItemAnnotation alloc] initWithItem:item];
    
        [self.mapView addAnnotation:annotation];
    }
}

- (void)didFailToGetItems:(NSString *)message
{
    NSLog(@"didFailToGetItems: %@", message);
}

@end
