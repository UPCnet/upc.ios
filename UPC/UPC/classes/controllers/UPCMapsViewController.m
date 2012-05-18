//
//  UPCMapsViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 17/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCMapsViewController.h"


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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSLog(@"Trying to search: %@", searchBar.text);
}

@end
