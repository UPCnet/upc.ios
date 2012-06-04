//
//  UPCUnitViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 01/06/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCUnitViewController.h"
#import "UPCQualificationsViewController.h"
#import "UPCQualifications.h"
#import "UPCLocalizedCurrentLocation.h"


#pragma mark Class implementation

@implementation UPCUnitViewController

#pragma mark Synthesized properties

@synthesize unit = _unit;

#pragma mark Build locality data

- (CellConfigurator)unitInfoCellConfigurator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *UNIT_NAME_CELL = @"UNIT_NAME_CELL";
        
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:UNIT_NAME_CELL];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UNIT_NAME_CELL];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
        return cell;
    };
}

- (CellConfigurator)qualificationsCellConfigurator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *UNIT_QUALIFICATIONS_CELL = @"UNIT_QUALIFICATIONS_CELL";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UNIT_QUALIFICATIONS_CELL];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UNIT_QUALIFICATIONS_CELL];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.textColor = [UIColor colorWithRed:0 green:123.f/255.f blue:192.f/255.f alpha:1];
        }
        cell.textLabel.text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
        [cell sizeToFit];
        return cell;
    };
}

- (CellConfigurator)directionsCellConfigurator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *UNIT_DIRECTIONS_CELL = @"UNIT_DIRECTIONS_CELL";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UNIT_DIRECTIONS_CELL];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UNIT_DIRECTIONS_CELL];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
        }
        cell.textLabel.text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
        return cell;
    };
}

- (CellHeightEstimator)qualificationsHeightEstimator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        NSString *text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(282, 44) lineBreakMode:UILineBreakModeWordWrap];
        return textSize.height + 16;
    };
}

- (void)setUnit:(UPCUnit *)unit
{
    self->_unit = unit;
    
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    NSMutableArray *sectionHeaders = [[NSMutableArray alloc] init];
    NSMutableArray *cellHeightEstimators = [[NSMutableArray alloc] init];
    NSMutableArray *cellConfigurators = [[NSMutableArray alloc] init];
    NSMutableArray *cellActions = [[NSMutableArray alloc] init];
    
    CellConfigurator unitInfoCellConfigurator       = [self unitInfoCellConfigurator];
    CellConfigurator qualificationsCellConfigurator = [self qualificationsCellConfigurator];
    CellConfigurator directionsCellConfigurator     = [self directionsCellConfigurator];
    
    CellHeightEstimator qualificationsHeightEstimator = [self qualificationsHeightEstimator];
    
    // Add locality info
    NSArray *unitInfo = [NSArray arrayWithObjects:unit.name, nil];
    [sections addObject:unitInfo];
    [sectionHeaders addObject:[NSNull null]];
    [cellHeightEstimators addObject:DEFAULT_HEIGHT_ESTIMATOR];
    [cellConfigurators addObject:unitInfoCellConfigurator];
    [cellActions addObject:[NSNull null]];
    
    // Add qualifications
    if ([unit.degrees count] > 0) {
        [sections addObject:unit.degrees];
        [sectionHeaders addObject:@"Grau"];
        [cellHeightEstimators addObject:qualificationsHeightEstimator];
        [cellConfigurators addObject:qualificationsCellConfigurator];
        [cellActions addObject:^(UITableView *tableView, NSIndexPath *indexPath) {
            UPCQualifications *qualifications = [unit.degrees objectAtIndex:indexPath.row];
            NSString *degreeInfoAddress = [NSString stringWithFormat:@"http://www.upc.edu/grau/fitxa_grau.php?id_estudi=%@&lang=ca", qualifications.identifier];
            [self performSegueWithIdentifier:@"qualifications" sender:[NSURL URLWithString:degreeInfoAddress]];
        }];
    }
    
    if ([unit.masters count] > 0) {
        [sections addObject:unit.masters];
        [sectionHeaders addObject:@"2n cicle"];
        [cellHeightEstimators addObject:qualificationsHeightEstimator];
        [cellConfigurators addObject:qualificationsCellConfigurator];
        [cellActions addObject:^(UITableView *tableView, NSIndexPath *indexPath) {
            UPCQualifications *qualifications = [unit.masters objectAtIndex:indexPath.row];
            NSString *degreeInfoAddress = [NSString stringWithFormat:@"http://www.upc.edu/master/fitxa_master.php?id_estudi=%@&lang=ca", qualifications.identifier];
            [self performSegueWithIdentifier:@"qualifications" sender:[NSURL URLWithString:degreeInfoAddress]];
        }];
    }
    
    if ([unit.jointDegrees count] > 0) {
        [sections addObject:unit.jointDegrees];
        [sectionHeaders addObject:@"Dobles titulacions"];
        [cellHeightEstimators addObject:qualificationsHeightEstimator];
        [cellConfigurators addObject:qualificationsCellConfigurator];
        [cellActions addObject:[NSNull null]];
    }
    
    // Add directions button
    if (unit.longitude != 0 && unit.latitude != 0) {
        [sections addObject:[NSArray arrayWithObject:@"Com anar-hi"]];
        [sectionHeaders addObject:[NSNull null]];
        [cellHeightEstimators addObject:DEFAULT_HEIGHT_ESTIMATOR];
        [cellConfigurators addObject:directionsCellConfigurator];
        [cellActions addObject:^(UITableView *tableView, NSIndexPath *indexPath) {
            NSString *currentLocation = [UPCLocalizedCurrentLocation currentLocationStringForCurrentLanguage];
            NSString *googleMapsAddress = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%f,%f", [currentLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], unit.latitude, unit.longitude];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UPCQualificationsViewController *qualificationsViewController = segue.destinationViewController;
    qualificationsViewController.url = sender;
}

@end
