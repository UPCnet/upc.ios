//
//  UPCSearchResultsViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 31/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCSearchResultsViewController.h"
#import "UPCRestKitConfigurator.h"
#import "UPCBuildingViewController.h"
#import "UPCUnitViewController.h"
#import "UPCSearchResult.h"
#import "UPCBuilding.h"
#import "UPCUnit.h"


#define BUILDING_LOADER @"BUILDING_LOADER"
#define UNIT_LOADER     @"UNIT_LOADER"


#pragma mark Class implementation

@implementation UPCSearchResultsViewController

#pragma mark Synthesized properties

@synthesize searchResults;

#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SEARCH_RESULT_CELL = @"SEARCH_RESULT_CELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SEARCH_RESULT_CELL];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SEARCH_RESULT_CELL];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    cell.textLabel.text = [(UPCSearchResult *)[self.searchResults objectAtIndex:indexPath.row] name];
    
    return cell;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPCSearchResult *searchResult = [searchResults objectAtIndex:indexPath.row];
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
}

#pragma mark RestKit object loading

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error while loading search results!");
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if ([objectLoader.userData isEqualToString:BUILDING_LOADER]) {
        [self performSegueWithIdentifier:@"building" sender:[objects objectAtIndex:0]];
    } else if ([objectLoader.userData isEqualToString:UNIT_LOADER]) {
        [self performSegueWithIdentifier:@"unit" sender:[objects objectAtIndex:0]];
    }
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"building"]) {
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
