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
#import "UPCSearchResultGroup.h"
#import "UPCSearchResult.h"
#import "UPCUnit.h"
#import "UPCBuilding.h"
#import "NSArray+SearchResultsGrouping.h"
#import "UPCLocalityViewController.h"
#import "UPCSearchResultsViewController.h"
#import "UPCUnitViewController.h"
#import "UPCBuildingViewController.h"


#define LOCALITY_LOADER @"LOCALITY_LOADER"
#define SEARCH_LOADER   @"SEARCH_LOADER"
#define BUILDING_LOADER @"BUILDING_LOADER"
#define UNIT_LOADER     @"UNIT_LOADER"


#pragma mark Class extension

@interface UPCMapsViewController ()

@property (strong, nonatomic) NSString *lastSearchTerm;

- (void)loadLocalities;
- (void)showDefaultRegion;

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
    [self showDefaultRegion];
    [self loadLocalities];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark Default map area

- (void)showDefaultRegion
{
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(41.65, 2), MKCoordinateSpanMake(2, 2)) animated:NO];
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
    static double MIN_SPAN    = 0.002;
    
    if ([self.mapView.annotations count] == 1) {
        id<MKAnnotation> annotation = [self.mapView.annotations objectAtIndex:0];
        [self.mapView setRegion:MKCoordinateRegionMake([annotation coordinate], MKCoordinateSpanMake(MIN_SPAN, MIN_SPAN)) animated:YES];
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
        MKCoordinateSpan span =  MKCoordinateSpanMake(MAX((maxLatitude - minLatitude) * SPAN_FACTOR, MIN_SPAN), MAX((maxLongitude - minLongitude) * SPAN_FACTOR, MIN_SPAN));
        [self.mapView setRegion:MKCoordinateRegionMake(center, span) animated:YES];
    } else {
        [self showDefaultRegion];
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
            UPCSearchResult *searchResult = [searchResultGroup.searchResults objectAtIndex:0];
            if ([searchResult.type isEqualToString:BUILDING_TYPE]) {
                RKObjectManager *objectManager = [UPCRestKitConfigurator sharedManager];
                [objectManager.requestQueue cancelAllRequests];
                NSString *searchPath = [@"/InfoEdificiv1.php" stringByAppendingQueryParameters:[NSDictionary dictionaryWithObject:searchResult.identifier forKey:@"id"]];
                [objectManager loadObjectsAtResourcePath:searchPath usingBlock:^(RKObjectLoader *loader) {
                    [loader.mappingProvider setMapping:[loader.mappingProvider objectMappingForClass:[UPCBuilding class]] forKeyPath:@""];
                    loader.delegate = self;
                    loader.userData = BUILDING_LOADER;
                }];
            } else if ([searchResult.type isEqualToString:UNIT_TYPE]) {
                RKObjectManager *objectManager = [UPCRestKitConfigurator sharedManager];
                [objectManager.requestQueue cancelAllRequests];
                NSString *searchPath = [@"/InfoUnitatv1.php" stringByAppendingQueryParameters:[NSDictionary dictionaryWithObject:searchResult.identifier forKey:@"id"]];
                [objectManager loadObjectsAtResourcePath:searchPath usingBlock:^(RKObjectLoader *loader) {
                    [loader.mappingProvider setMapping:[loader.mappingProvider objectMappingForClass:[UPCUnit class]] forKeyPath:@""];
                    loader.delegate = self;
                    loader.userData = UNIT_LOADER;
                }];
            }
        } else {
            [self performSegueWithIdentifier:@"searchResults" sender:view];
        }
    }
}

#pragma mark RestKit object loading

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"S'ha produït un error de comunicació. Sisplau, intenta-ho de nou més tard." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if ([objectLoader.userData isEqualToString:LOCALITY_LOADER]) {
        [self.mapView removeAnnotations:self.mapView.annotations];
        [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.mapView addAnnotation:obj];
        }];
        [self showAnnotatedRegion];
    } else if ([objectLoader.userData isEqualToString:SEARCH_LOADER]) {
        [self.mapView removeAnnotations:self.mapView.annotations];
        NSArray *buildingsAndUnits = [objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type == 'edifici' OR type == 'unitat'"]];
        if ([buildingsAndUnits count] > 0) {
            NSDictionary *groupedSearchResults = [buildingsAndUnits groupByLocation];
            [groupedSearchResults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSArray *searchResultsInLocation = (NSArray *)obj;
                [self.mapView addAnnotation:[[UPCSearchResultGroup alloc] initWithSearchResults:searchResultsInLocation]];
            }];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No s'ha obtingut cap resultat" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        [self showAnnotatedRegion];
    } else if ([objectLoader.userData isEqualToString:BUILDING_LOADER]) {
        [self performSegueWithIdentifier:@"building" sender:[objects objectAtIndex:0]];
    } else if ([objectLoader.userData isEqualToString:UNIT_LOADER]) {
        [self performSegueWithIdentifier:@"unit" sender:[objects objectAtIndex:0]];
    }
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
    } else if ([segue.identifier isEqualToString:@"building"]) {
        UPCBuilding *building = sender;
        UPCBuildingViewController *buildingViewController = segue.destinationViewController;
        buildingViewController.building = building;
        buildingViewController.navigationItem.title = building.name;
    } else if ([segue.identifier isEqualToString:@"unit"]) {
        UPCUnit *unit = sender;
        UPCUnitViewController *unitViewController = segue.destinationViewController;
        unitViewController.unit = unit;
        unitViewController.navigationItem.title = unit.name;
    }
}

@end
