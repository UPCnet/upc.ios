//
//  UPCBuildingViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 01/06/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCBuildingViewController.h"
#import "UPCRestKitConfigurator.h"
#import "UPCUnitViewController.h"
#import "UPCLocalizedCurrentLocation.h"


#pragma mark Class implementation

@implementation UPCBuildingViewController

# pragma mark Synthesized properties

@synthesize building = _building;

#pragma mark Build building data

- (CellConfigurator)buildingInfoCellConfigurator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *BUILDING_NAME_CELL    = @"BUILDING_NAME_CELL";
        static NSString *BUILDING_ADDRESS_CELL = @"BUILDING_ADDRESS_CELL";
        
        NSString *reusableCellIdentifier = indexPath.row == 0 ? BUILDING_NAME_CELL : BUILDING_ADDRESS_CELL;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
        cell.textLabel.text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
        return cell;
    };
}

- (CellConfigurator)unitCellConfigurator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *BUILDING_UNIT_CELL = @"BUILDING_UNIT_CELL";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BUILDING_UNIT_CELL];
        cell.textLabel.text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
        [cell sizeToFit];
        return cell;
    };
}

- (CellConfigurator)directionsCellConfigurator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *BUILDING_DIRECTIONS_CELL = @"BUILDING_DIRECTIONS_CELL";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BUILDING_DIRECTIONS_CELL];
        cell.textLabel.text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
        return cell;
    };
}

- (CellHeightEstimator)buildingInfoHeightEstimator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        if (indexPath.row) {
            return tableView.rowHeight;
        } else {
            NSString *text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
            CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 500) lineBreakMode:UILineBreakModeWordWrap];
            return textSize.height + 16;
        }
    };
}

- (CellHeightEstimator)unitHeightEstimator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        NSString *text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(247, 500) lineBreakMode:UILineBreakModeWordWrap];
        return textSize.height + 16;
    };
}

- (void)setBuilding:(UPCBuilding *)building
{
    self->_building = building;
    
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    NSMutableArray *sectionHeaders = [[NSMutableArray alloc] init];
    NSMutableArray *cellHeightEstimators = [[NSMutableArray alloc] init];
    NSMutableArray *cellConfigurators = [[NSMutableArray alloc] init];
    NSMutableArray *cellActions = [[NSMutableArray alloc] init];
    
    CellConfigurator buildingInfoCellConfigurator = [self buildingInfoCellConfigurator];
    CellConfigurator unitCellConfigurator         = [self unitCellConfigurator];
    CellConfigurator directionsCellConfigurator   = [self directionsCellConfigurator];
    
    CellHeightEstimator buildingInfoHeightEstimator = [self buildingInfoHeightEstimator];
    CellHeightEstimator unitHeightEstimator         = [self unitHeightEstimator];
    
    // Add building info
    NSArray *buildingInfo = [NSArray arrayWithObjects:building.name, building.address, nil];
    [sections addObject:buildingInfo];
    [sectionHeaders addObject:[NSNull null]];
    [cellHeightEstimators addObject:buildingInfoHeightEstimator];
    [cellConfigurators addObject:buildingInfoCellConfigurator];
    [cellActions addObject:[NSNull null]];
    
    // Add units
    if ([building.units count] > 0) {
        [sections addObject:building.units];
        [sectionHeaders addObject:@"Unitats"];
        [cellHeightEstimators addObject:unitHeightEstimator];
        [cellConfigurators addObject:unitCellConfigurator];
        [cellActions addObject:^(UITableView *tableView, NSIndexPath *indexPath) {
            RKObjectManager *objectManager = [UPCRestKitConfigurator sharedManager];
            [[RKObjectManager sharedManager].operationQueue cancelAllOperations];
            UPCUnit *unit = [building.units objectAtIndex:indexPath.row];
//            NSString *searchPath = [@"/InfoUnitatv1.php" stringByAppendingQueryParameters:[NSDictionary dictionaryWithObject:unit.identifier forKey:@"id"]];
//            [objectManager loadObjectsAtResourcePath:searchPath usingBlock:^(RKObjectLoader *loader) {
//                [loader.mappingProvider setMapping:[loader.mappingProvider objectMappingForClass:[UPCUnit class]] forKeyPath:@""];
//                loader.delegate = self;
//            }];
            [RKObjectManager.sharedManager getObjectsAtPath:@"/InfoUnitatv1.php" parameters:@{@"id":unit.identifier} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
             {
                [self performSegueWithIdentifier:@"unit" sender:[[mappingResult array] objectAtIndex:0]];
                 
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 [[[UIAlertView alloc] initWithTitle:@"Error" message:@"S'ha produït un error de comunicació. Sisplau, intenta-ho de nou més tard." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                 [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
             }];
        }];
    }
    
    // Add directions button
    if (building.longitude != 0 && building.latitude != 0) {
        [sections addObject:[NSArray arrayWithObject:@"Com anar-hi"]];
        [sectionHeaders addObject:[NSNull null]];
        [cellHeightEstimators addObject:DEFAULT_HEIGHT_ESTIMATOR];
        [cellConfigurators addObject:directionsCellConfigurator];
        [cellActions addObject:^(UITableView *tableView, NSIndexPath *indexPath) {
            NSString *currentLocation = [UPCLocalizedCurrentLocation currentLocationStringForCurrentLanguage];
            NSString *googleMapsAddress = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%f,%f", [currentLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], building.latitude, building.longitude];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsAddress]];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
    }
    
    self.sections = sections;
    self.sectionHeaders = sectionHeaders;
    self.cellHeightEstimators = cellHeightEstimators;
    self.cellConfigurators = cellConfigurators;
    self.cellActions = cellActions;
}

//#pragma mark RestKit object loading
//
//- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
//{
//    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"S'ha produït un error de comunicació. Sisplau, intenta-ho de nou més tard." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//}

//- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
//{
//    [self performSegueWithIdentifier:@"unit" sender:[objects objectAtIndex:0]];
//}

#pragma mark Segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UPCUnit *unit = sender;
    UPCUnitViewController *unitViewController = segue.destinationViewController;
    unitViewController.unit = unit;
    unitViewController.navigationItem.title = unit.name;
}

@end
