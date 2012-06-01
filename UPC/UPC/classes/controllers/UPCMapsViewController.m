//
//  UPCMapsViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 17/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCMapsViewController.h"
#import "UPCRestKitConfigurator.h"
#import "UPCLocality.h"
#import "UPCSearchResult.h"
#import "UPCSearchResultGroup.h"
#import "NSArray+SearchResultsGrouping.h"
#import "UPCLocalityViewController.h"
#import "UPCSearchResultsViewController.h"


NSString * const LOCALITY_LOADER = @"LOCALITY_LOADER";
NSString * const SEARCH_LOADER   = @"SEARCH_LOADER";


#pragma mark Class extension

@interface UPCMapsViewController ()

@property (strong, nonatomic) NSString *lastSearchTerm;

- (void)loadLocalities;

@end


#pragma mark - Class implementation

@implementation UPCMapsViewController

#pragma mark Synthesized properties

@synthesize mapView;
@synthesize lastSearchTerm;

#pragma mark View lifecycle management

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(41.65, 2), MKCoordinateSpanMake(2, 2)) animated:NO];
    [self loadLocalities];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark Initial loading of localities

- (void)loadLocalities
{
    RKObjectManager *objectManager = [UPCRestKitConfigurator sharedManager];
    [objectManager.requestQueue cancelAllRequests];
    [objectManager loadObjectsAtResourcePath:@"/InfoLocalitatsv1.php" usingBlock:^(RKObjectLoader *loader) {
        [loader.mappingProvider setMapping:[loader.mappingProvider objectMappingForClass:[UPCLocality class]] forKeyPath:@""];
        loader.delegate = self;
        loader.userData = LOCALITY_LOADER;
    }];
}

#pragma mark Search bar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    RKObjectManager *objectManager = [UPCRestKitConfigurator sharedManager];
    [objectManager.requestQueue cancelAllRequests];
    NSString *searchPath = [@"/CercadorMapsv1.php" stringByAppendingQueryParameters:[NSDictionary dictionaryWithObject:searchBar.text forKey:@"text"]];
    [objectManager loadObjectsAtResourcePath:searchPath usingBlock:^(RKObjectLoader *loader) {
        [loader.mappingProvider setMapping:[loader.mappingProvider objectMappingForClass:[UPCSearchResult class]] forKeyPath:@""];
        loader.delegate = self;
        loader.userData = SEARCH_LOADER;
    }];
    self.lastSearchTerm = searchBar.text;
}

#pragma mark Map view management

- (void)showAnnotatedRegion
{
    static double SPAN_FACTOR = 1.5;
    
    if ([self.mapView.annotations count] == 1) {
        id<MKAnnotation> annotation = [self.mapView.annotations objectAtIndex:0];
        [self.mapView setRegion:MKCoordinateRegionMake([annotation coordinate], MKCoordinateSpanMake(0.0005, 0.0005)) animated:YES];
    }
    else if ([self.mapView.annotations count] > 1) {
        __block CLLocationDegrees minLatitude  =  DBL_MAX;
        __block CLLocationDegrees maxLatitude  = -DBL_MAX;
        __block CLLocationDegrees minLongitude =  DBL_MAX;
        __block CLLocationDegrees maxLongitude = -DBL_MAX;
        
        [self.mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id<MKAnnotation> annotation = (id<MKAnnotation>)obj;
            minLatitude  = MIN(minLatitude,  [annotation coordinate].latitude);
            maxLatitude  = MAX(maxLatitude,  [annotation coordinate].latitude);
            minLongitude = MIN(minLongitude, [annotation coordinate].longitude);
            maxLongitude = MAX(maxLongitude, [annotation coordinate].longitude);
        }];
        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLatitude + maxLatitude) / 2, (minLongitude + maxLongitude) / 2);
        MKCoordinateSpan span =  MKCoordinateSpanMake((maxLatitude - minLatitude) * SPAN_FACTOR, (maxLongitude - minLongitude) * SPAN_FACTOR);
        [self.mapView setRegion:MKCoordinateRegionMake(center, span) animated:YES];
    } else {
        [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(41.65, 2), MKCoordinateSpanMake(2, 2)) animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *SEARCH_RESULT = @"SEARCH_RESULT";
    
    if ([annotation isKindOfClass:[UPCLocality class]] || [annotation isKindOfClass:[UPCSearchResultGroup class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:SEARCH_RESULT];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:SEARCH_RESULT];
            annotationView.canShowCallout            = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.pinColor                  = MKPinAnnotationColorRed;
            annotationView.animatesDrop              = YES;
        }
        else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[UPCLocality class]]) {
        [self performSegueWithIdentifier:@"locality" sender:view];
    } else  if ([view.annotation isKindOfClass:[UPCSearchResultGroup class]]) {
        UPCSearchResultGroup *searchResultGroup = (UPCSearchResultGroup *)view.annotation;
        if ([searchResultGroup.searchResults count] == 1) {
        } else {
            [self performSegueWithIdentifier:@"searchResults" sender:view];
        }
    }
}

#pragma mark RestKit object loading

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error while loading search results!");
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if ([objectLoader.userData isEqualToString:LOCALITY_LOADER]) {
        [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.mapView addAnnotation:obj];
        }];
    } else if ([objectLoader.userData isEqualToString:SEARCH_LOADER]) {
        NSDictionary *groupedSearchResults = [objects groupByLocation];
        [groupedSearchResults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSArray *searchResultsInLocation = (NSArray *)obj;
            [self.mapView addAnnotation:[[UPCSearchResultGroup alloc] initWithSearchResults:searchResultsInLocation]];
        }];
    }
    
    [self showAnnotatedRegion];
}

#pragma mark Segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"locality"]) {
        UPCLocality *locality = [(MKAnnotationView *)sender annotation];
        UPCLocalityViewController *localityViewController = segue.destinationViewController;
        localityViewController.locality = locality;
        localityViewController.navigationItem.title = locality.name;
    } else if ([segue.identifier isEqualToString:@"searchResults"]) {
        UPCSearchResultGroup *searchResultGroup = (UPCSearchResultGroup *)[(MKAnnotationView *)sender annotation];
        UPCSearchResultsViewController *searchResultsViewController = segue.destinationViewController;
        searchResultsViewController.searchResults = searchResultGroup.searchResults;
        searchResultsViewController.navigationItem.title = self.lastSearchTerm;
    }
}

@end
