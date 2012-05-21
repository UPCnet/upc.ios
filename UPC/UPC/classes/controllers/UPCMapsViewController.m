//
//  UPCMapsViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 17/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCMapsViewController.h"
#import "UPCRestKitConfigurator.h"
#import "UPCSearchResult.h"


#pragma mark Class implementation

@implementation UPCMapsViewController

#pragma mark Synthesized properties

@synthesize mapView;

#pragma mark View lifecycle management

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(41.65, 2), MKCoordinateSpanMake(2, 2)) animated:YES];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark Search bar

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error while loading search results!");
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"Search result ok, with %d results", [objects count]);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    RKObjectManager *objectManager = [UPCRestKitConfigurator sharedManager];
    NSString *searchPath = [@"/CercadorMapsv1.php" stringByAppendingQueryParameters:[NSDictionary dictionaryWithObject:searchBar.text forKey:@"text"]];
    [objectManager loadObjectsAtResourcePath:searchPath usingBlock:^(RKObjectLoader *loader) {
        [loader.mappingProvider setMapping:[loader.mappingProvider objectMappingForClass:[UPCSearchResult class]] forKeyPath:@""];
        loader.delegate = self;
    }];
}

@end
