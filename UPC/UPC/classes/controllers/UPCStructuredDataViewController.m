//
//  UPCStructuredDataViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 01/06/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCStructuredDataViewController.h"


@implementation UPCStructuredDataViewController

#pragma mark Synthesized properties

@synthesize sections          = _sections;
@synthesize sectionHeaders    = _sectionHeaders;
@synthesize cellConfigurators = _cellConfigurators;

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sections objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionHeader = [self.sectionHeaders objectAtIndex:section];
    if (![sectionHeader isEqual:[NSNull null]]) {
        return sectionHeader;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellConfigurator cellConfigurator = [self.cellConfigurators objectAtIndex:indexPath.section];
    return cellConfigurator(tableView, indexPath);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
