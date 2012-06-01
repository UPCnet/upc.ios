//
//  UPCCampusViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 31/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCCampusViewController.h"


#pragma mark Class implementation

@implementation UPCCampusViewController

#pragma mark Synthesized properties

@synthesize campus = _campus;

#pragma mark Build campus data

- (void)setCampus:(UPCCampus *)campus
{
    self->_campus = campus;
    
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    NSMutableArray *sectionHeaders = [[NSMutableArray alloc] init];
    NSMutableArray *cellConfigurators = [[NSMutableArray alloc] init];
    
    CellConfigurator campusInfoCellConfigurator = ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *CAMPUS_NAME_CELL     = @"CAMPUS_NAME_CELL";
        static NSString *CAMPUS_LOCALITY_CELL = @"CAMPUS_LOCALITY_CELL";
        
        UITableViewCell *cell;
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:CAMPUS_NAME_CELL];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CAMPUS_NAME_CELL];
            }
            cell.textLabel.text = [(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:CAMPUS_LOCALITY_CELL];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CAMPUS_LOCALITY_CELL];
                cell.textLabel.font = [UIFont fontWithName:@"System" size:14];
            }
            cell.textLabel.text = [(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
        return cell;
    };
    
    CellConfigurator centerCellConfigurator = ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *CAMPUS_CENTER_CELL     = @"CAMPUS_CENTER_CELL";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CAMPUS_CENTER_CELL];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CAMPUS_CENTER_CELL];
            cell.textLabel.font = [UIFont fontWithName:@"System" size:12];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.textColor = [UIColor colorWithRed:0 green:123.f/255.f blue:192.f/255.f alpha:1];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        [cell sizeToFit];
        return cell;
    };
    
    NSArray *campusInfo = [NSArray arrayWithObjects:campus.name, campus.locality, nil];
    [sections addObject:campusInfo];
    [sectionHeaders addObject:[NSNull null]];
    [cellConfigurators addObject:campusInfoCellConfigurator];
    
    if ([campus.ownCenters count] > 0) {
        [sections addObject:campus.ownCenters];
        [sectionHeaders addObject:@"Centres propis"];
        [cellConfigurators addObject:centerCellConfigurator];
    }
    
    if ([campus.attachedCenters count] > 0) {
        [sections addObject:campus.attachedCenters];
        [sectionHeaders addObject:@"Centres adscrits"];
        [cellConfigurators addObject:centerCellConfigurator];
    }
    
    self.sections = sections;
    self.sectionHeaders = sectionHeaders;
    self.cellConfigurators = cellConfigurators;
}

@end
