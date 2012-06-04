//
//  UPCUnitViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 01/06/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCUnitViewController.h"
#import "UPCQualificationsViewController.h"
#import "UPCAddressVideoCell.h"
#import "UPCQualifications.h"
#import "UPCLocalizedCurrentLocation.h"
#import <SDWebImage/UIButton+WebCache.h>


#pragma mark Class implementation

@implementation UPCUnitViewController

#pragma mark Synthesized properties

@synthesize unit = _unit;

#pragma mark Build locality data

- (CellConfigurator)unitInfoCellConfigurator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *UNIT_NAME_CELL          = @"UNIT_NAME_CELL";
        static NSString *UNIT_ADDRESS_VIDEO_CELL = @"UNIT_ADDRESS_VIDEO_CELL";
        static NSString *UNIT_ADDRESS_CELL       = @"UNIT_ADDRESS_CELL";
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UNIT_NAME_CELL];
            cell.textLabel.text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
            return cell;
        } else {
            NSString *imageURL = self.unit.youTubeVideoAddress != nil ? (self.unit.videoThumbnailAddress != nil ? self.unit.videoThumbnailAddress : self.unit.photoAddress) : self.unit.photoAddress;
            NSString *reusableCellIdentifier = self.unit.photoAddress || (self.unit.youTubeVideoAddress && self.unit.videoThumbnailAddress) ? UNIT_ADDRESS_VIDEO_CELL : UNIT_ADDRESS_CELL;
            UPCAddressVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
            cell.addressLabel.text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
            if (imageURL) {
                [cell.videoButton setImageWithURL:[NSURL URLWithString:imageURL]];
            }
            [cell sizeToFit];
            return cell;
        }
        
    };
}

- (CellConfigurator)qualificationsCellConfigurator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *UNIT_QUALIFICATIONS_CELL = @"UNIT_QUALIFICATIONS_CELL";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UNIT_QUALIFICATIONS_CELL];
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
        cell.textLabel.text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
        return cell;
    };
}

- (CellHeightEstimator)unitInfoHeightEstimator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        if (indexPath.row == 0) {
            return tableView.rowHeight;
        } else {
            NSString *text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
            CGFloat addressWidth = self.unit.photoAddress || (self.unit.youTubeVideoAddress && self.unit.videoThumbnailAddress) ? 140.f : 280.f;
            CGFloat minimumCellHeight  = self.unit.photoAddress || (self.unit.youTubeVideoAddress && self.unit.videoThumbnailAddress) ? 100.f : 44.f;
            CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(addressWidth, 500) lineBreakMode:UILineBreakModeWordWrap];
            return MAX(textSize.height + 16, minimumCellHeight);
        }
    };
}

- (CellHeightEstimator)qualificationsHeightEstimator
{
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        NSString *text = [[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(247, 44) lineBreakMode:UILineBreakModeWordWrap];
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
    NSArray *unitInfo = [NSArray arrayWithObjects:unit.name, unit.address, nil];
    [sections addObject:unitInfo];
    [sectionHeaders addObject:[NSNull null]];
    [cellHeightEstimators addObject:[self unitInfoHeightEstimator]];
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

#pragma mark YouTube video button

- (IBAction)youtubeVideoButtonTapped:(id)sender
{
    if (self.unit.youTubeVideoAddress) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.unit.youTubeVideoAddress]];
    }
}

@end
