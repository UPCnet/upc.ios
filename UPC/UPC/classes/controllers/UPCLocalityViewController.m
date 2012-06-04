//
//  UPCLocalityViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 31/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCLocalityViewController.h"
#import "UPCLocalizedCurrentLocation.h"


#pragma mark Class implementation

@implementation UPCLocalityViewController

#pragma mark Synthesized properties

@synthesize locality = _locality;

#pragma mark Build locality data

- (CellConfigurator)localityInfoCellConfigurator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *LOCALITY_NAME_CELL = @"LOCALITY_NAME_CELL";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LOCALITY_NAME_CELL];
        cell.textLabel.text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
        return cell;
    };
}

- (CellConfigurator)centerCellConfigurator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *LOCALITY_CENTER_CELL = @"LOCALITY_CENTER_CELL";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LOCALITY_CENTER_CELL];
        cell.textLabel.text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
        [cell sizeToFit];
        return cell;
    };
}

- (CellConfigurator)directionsCellConfigurator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *LOCALITY_DIRECTIONS_CELL = @"LOCALITY_DIRECTIONS_CELL";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LOCALITY_DIRECTIONS_CELL];
        cell.textLabel.text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
        return cell;
    };
}

- (CellHeightEstimator)centerHeightEstimator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        NSString *text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 500) lineBreakMode:UILineBreakModeWordWrap];
        return textSize.height + 16;
    };
}

- (void)setLocality:(UPCLocality *)locality
{
    self->_locality = locality;
    
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    NSMutableArray *sectionHeaders = [[NSMutableArray alloc] init];
    NSMutableArray *cellHeightEstimators = [[NSMutableArray alloc] init];
    NSMutableArray *cellConfigurators = [[NSMutableArray alloc] init];
    NSMutableArray *cellActions = [[NSMutableArray alloc] init];
    
    CellConfigurator localityInfoCellConfigurator = [self localityInfoCellConfigurator];
    CellConfigurator centerCellConfigurator       = [self centerCellConfigurator];
    CellConfigurator directionsCellConfigurator   = [self directionsCellConfigurator];
    
    CellHeightEstimator centerHeightEstimator = [self centerHeightEstimator];
    
    // Add locality info
    NSArray *localityInfo = [NSArray arrayWithObjects:locality.name, nil];
    [sections addObject:localityInfo];
    [sectionHeaders addObject:[NSNull null]];
    [cellHeightEstimators addObject:DEFAULT_HEIGHT_ESTIMATOR];
    [cellConfigurators addObject:localityInfoCellConfigurator];
    [cellActions addObject:[NSNull null]];
    
    // Add centers
    if ([locality.ownCenters count] > 0) {
        [sections addObject:locality.ownCenters];
        [sectionHeaders addObject:@"Centres propis"];
        [cellHeightEstimators addObject:centerHeightEstimator];
        [cellConfigurators addObject:centerCellConfigurator];
        [cellActions addObject:[NSNull null]];
    }
    
    // Add attached centers
    if ([locality.attachedCenters count] > 0) {
        [sections addObject:locality.attachedCenters];
        [sectionHeaders addObject:@"Centres adscrits"];
        [cellHeightEstimators addObject:centerHeightEstimator];
        [cellConfigurators addObject:centerCellConfigurator];
        [cellActions addObject:[NSNull null]];
    }
    
    // Add directions button
    if (locality.longitude != 0 && locality.latitude != 0) {
        [sections addObject:[NSArray arrayWithObject:@"Com anar-hi"]];
        [sectionHeaders addObject:[NSNull null]];
        [cellHeightEstimators addObject:DEFAULT_HEIGHT_ESTIMATOR];
        [cellConfigurators addObject:directionsCellConfigurator];
        [cellActions addObject:^(UITableView *tableView, NSIndexPath *indexPath) {
            NSString *currentLocation = [UPCLocalizedCurrentLocation currentLocationStringForCurrentLanguage];
            NSString *googleMapsAddress = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%f,%f", [currentLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], locality.latitude, locality.longitude];
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

@end
