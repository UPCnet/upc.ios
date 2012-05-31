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

@synthesize campus;

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 0;
    numberOfSections += [campus.ownCenters count] > 0 ? 1 : 0;
    numberOfSections += [campus.attachedCenters count] > 0 ? 1 : 0;
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if ([campus.ownCenters count] > 0) {
                return [campus.ownCenters count];
            } else {
                return [campus.attachedCenters count];
            }
            
        case 1:
            return [campus.attachedCenters count];
            
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if ([campus.ownCenters count] > 0) {
                return @"Centres propis";
            } else {
                return @"Centres adscrits";
            }
            
        case 1:
            return @"Centres adscrits";
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CENTER_CELL = @"CENTER_CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CENTER_CELL];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CENTER_CELL];
    }
    
    switch (indexPath.section) {
        case 0:
            if ([campus.ownCenters count] > 0) {
                cell.textLabel.text = [[campus.ownCenters objectAtIndex:indexPath.row] name];
            } else {
                cell.textLabel.text = [[campus.attachedCenters objectAtIndex:indexPath.row] name];
            }
            break;
            
        default:
            cell.textLabel.text = [[campus.attachedCenters objectAtIndex:indexPath.row] name];
            break;
    }
    
    return cell;
}

@end
