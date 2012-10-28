//
//  FCAppDelegate.m
//  flend
//
//  Created by Alan Gorton on 28/10/2012.
//  Copyright (c) 2012 Alan Gorton. All rights reserved.
//

#import "FCAppDelegate.h"
#import "FCMapViewController.h"

@interface FCAppDelegate ()

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, strong) UINavigationController *mapNavigationController;
@property (strong, nonatomic) FCMapViewController *mapViewController;

@end

@implementation FCAppDelegate

@synthesize tabBarController = _tabBarController;

@synthesize mapViewController = _mapViewController;
@synthesize mapNavigationController = _mapNavigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = self.tabBarController;

    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UITabBarController *)tabBarController
{
    if (!_tabBarController) {
        // Create tab items;
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        UIImage *image;
        
        UINavigationController *myItemsViewController = [[UINavigationController alloc] init];
        UINavigationController *wishlistItemsViewController = [[UINavigationController alloc] init];
        UINavigationController *settingsViewController = [[UINavigationController alloc] init];
        
        image = [UIImage imageNamed:@"145-persondot.png"];
        myItemsViewController.tabBarItem.image = image;
        
        image = [UIImage imageNamed:@"124-bullhorn.png"];
        wishlistItemsViewController.tabBarItem.image = image;

        image = [UIImage imageNamed:@"19-gear.png"];
        settingsViewController.tabBarItem.image = image;
        
        [items addObject:self.mapNavigationController];
        [items addObject:myItemsViewController];
        [items addObject:wishlistItemsViewController];
        [items addObject:settingsViewController];
        
        // Create tab bar controller.
        _tabBarController = [[UITabBarController alloc] init];
        _tabBarController.viewControllers = items;
    }
    
    return _tabBarController;
}

- (UINavigationController *)mapNavigationController
{
    if (!_mapNavigationController) {
        // Create map navigation view controller.
        _mapNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mapViewController];
        
        // Set up map view navigation view controller.
        UIImage *image = [UIImage imageNamed:@"07-map-marker.png"];
        
        _mapNavigationController.tabBarItem.image = image;
    }
    
    return _mapNavigationController;
}

- (FCMapViewController *)mapViewController
{
    if (!_mapViewController) {
        _mapViewController = [[FCMapViewController alloc] init];
    }
    
    return _mapViewController;
}

@end
