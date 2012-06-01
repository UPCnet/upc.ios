//
//  UPCLocalityViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 31/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCLocalityViewController.h"


#pragma mark Class implementation

@implementation UPCLocalityViewController

#pragma mark Synthesized properties

@synthesize locality = _locality;

#pragma mark Build locality data

- (void)setLocality:(UPCLocality *)locality
{
    self->_locality = locality;
    
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    NSMutableArray *sectionHeaders = [[NSMutableArray alloc] init];
    NSMutableArray *cellConfigurators = [[NSMutableArray alloc] init];
    
    CellConfigurator localityInfoCellConfigurator = ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *LOCALITY_NAME_CELL     = @"LOCALITY_NAME_CELL";
        static NSString *LOCALITY_LOCALITY_CELL = @"LOCALITY_LOCALITY_CELL";
        
        UITableViewCell *cell;
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:LOCALITY_NAME_CELL];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LOCALITY_NAME_CELL];
            }
            cell.textLabel.text = [(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:LOCALITY_LOCALITY_CELL];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LOCALITY_LOCALITY_CELL];
                cell.textLabel.font = [UIFont fontWithName:@"System" size:14];
            }
            cell.textLabel.text = [(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
        return cell;
    };
    
    CellConfigurator centerCellConfigurator = ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *LOCALITY_CENTER_CELL     = @"LOCALITY_CENTER_CELL";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LOCALITY_CENTER_CELL];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LOCALITY_CENTER_CELL];
            cell.textLabel.font = [UIFont fontWithName:@"System" size:12];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.textColor = [UIColor colorWithRed:0 green:123.f/255.f blue:192.f/255.f alpha:1];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        [cell sizeToFit];
        return cell;
    };
    
    NSArray *localityInfo = [NSArray arrayWithObjects:locality.name, nil];
    [sections addObject:localityInfo];
    [sectionHeaders addObject:[NSNull null]];
    [cellConfigurators addObject:localityInfoCellConfigurator];
    
    if ([locality.ownCenters count] > 0) {
        [sections addObject:locality.ownCenters];
        [sectionHeaders addObject:@"Centres propis"];
        [cellConfigurators addObject:centerCellConfigurator];
    }
    
    if ([locality.attachedCenters count] > 0) {
        [sections addObject:locality.attachedCenters];
        [sectionHeaders addObject:@"Centres adscrits"];
        [cellConfigurators addObject:centerCellConfigurator];
    }
    
    self.sections = sections;
    self.sectionHeaders = sectionHeaders;
    self.cellConfigurators = cellConfigurators;
}

@end
