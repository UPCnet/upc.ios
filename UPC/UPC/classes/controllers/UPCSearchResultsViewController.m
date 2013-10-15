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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [(UPCSearchResult *)[self.searchResults objectAtIndex:indexPath.row] name];
    CGSize textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(267, 500) lineBreakMode:UILineBreakModeWordWrap];
    return textSize.height + 16;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SEARCH_RESULT_CELL = @"SEARCH_RESULT_CELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SEARCH_RESULT_CELL];
    cell.textLabel.text = [(UPCSearchResult *)[self.searchResults objectAtIndex:indexPath.row] name];
    [cell sizeToFit];
    
    return cell;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPCSearchResult *searchResult = [searchResults objectAtIndex:indexPath.row];
    if ([searchResult.type isEqualToString:BUILDING_TYPE]) {
        RKObjectManager *objectManager = [UPCRestKitConfigurator sharedManager];
        [objectManager.operationQueue cancelAllOperations];
        
//        NSString *searchPath = [@"/InfoEdificiv1.php" stringByAppendingQueryParameters:[NSDictionary dictionaryWithObject:searchResult.identifier forKey:@"id"]];
//        [objectManager loadObjectsAtResourcePath:searchPath usingBlock:^(RKObjectLoader *loader) {
//            [loader.mappingProvider setMapping:[loader.mappingProvider objectMappingForClass:[UPCBuilding class]] forKeyPath:@""];
//            loader.delegate = self;
//            loader.userData = BUILDING_LOADER;
//        }];
        
        [objectManager getObjectsAtPath:@"InfoEdificiv1.php" parameters:@{@"id":searchResult.identifier} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
         {
             [self performSegueWithIdentifier:@"building" sender:[[mappingResult array] objectAtIndex:0]];
             
         } failure:^(RKObjectRequestOperation *operation, NSError *error) {
             [[[UIAlertView alloc] initWithTitle:@"Error" message:@"S'ha produït un error de comunicació. Sisplau, intenta-ho de nou més tard." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
             [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
         }];
    } else if ([searchResult.type isEqualToString:UNIT_TYPE]) {
        RKObjectManager *objectManager = [UPCRestKitConfigurator sharedManager];
        [objectManager.operationQueue cancelAllOperations];
        
//        NSString *searchPath = [@"/InfoUnitatv1.php" stringByAppendingQueryParameters:[NSDictionary dictionaryWithObject:searchResult.identifier forKey:@"id"]];
//        [objectManager loadObjectsAtResourcePath:searchPath usingBlock:^(RKObjectLoader *loader) {
//            [loader.mappingProvider setMapping:[loader.mappingProvider objectMappingForClass:[UPCUnit class]] forKeyPath:@""];
//            loader.delegate = self;
//            loader.userData = UNIT_LOADER;
//        }];
        
        [objectManager getObjectsAtPath:@"InfoUnitatv1.php" parameters:@{@"id":searchResult.identifier} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
         {
             [self performSegueWithIdentifier:@"unit" sender:[[mappingResult array] objectAtIndex:0]];
             
         } failure:^(RKObjectRequestOperation *operation, NSError *error) {
             [[[UIAlertView alloc] initWithTitle:@"Error" message:@"S'ha produït un error de comunicació. Sisplau, intenta-ho de nou més tard." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
             [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
         }];
    }
}

//#pragma mark RestKit object loading
//
//- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
//{
//    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"S'ha produït un error de comunicació. Sisplau, intenta-ho de nou més tard." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//}
//
//- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
//{
//    if ([objectLoader.userData isEqualToString:BUILDING_LOADER]) {
//        [self performSegueWithIdentifier:@"building" sender:[objects objectAtIndex:0]];
//    } else if ([objectLoader.userData isEqualToString:UNIT_LOADER]) {
//        [self performSegueWithIdentifier:@"unit" sender:[objects objectAtIndex:0]];
//    }
//}

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
