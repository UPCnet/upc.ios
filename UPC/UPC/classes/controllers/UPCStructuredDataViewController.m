//
//  UPCStructuredDataViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 01/06/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCStructuredDataViewController.h"


const CellHeightEstimator DEFAULT_HEIGHT_ESTIMATOR = ^(UITableView *tableView, NSIndexPath *indexPath) {
    return tableView.rowHeight;
};


#pragma mark - UPCStructuredDataAction class implementation

@implementation UPCStructuredDataAction

@synthesize label  = _label;
@synthesize action = _action;

- (id)initWithLabel:(NSString *)label andAction:(CellAction)action
{
    self = [super init];
    if (self) {
        self->_label  = label;
        self->_action = action;
    }
    return self;
}

- (NSString *)description
{
    return self.label;
}

@end


#pragma mark - UPCStructuredDataViewController class implementation

@implementation UPCStructuredDataViewController

#pragma mark Synthesized properties

@synthesize sections             = _sections;
@synthesize sectionHeaders       = _sectionHeaders;
@synthesize cellHeightEstimators = _cellHeightEstimators;
@synthesize cellConfigurators    = _cellConfigurators;

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
    CellHeightEstimator cellHeightEstimator = [self.cellHeightEstimators objectAtIndex:indexPath.section];
    return cellHeightEstimator(tableView, indexPath);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellConfigurator cellConfigurator = [self.cellConfigurators objectAtIndex:indexPath.section];
    return cellConfigurator(tableView, indexPath);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isKindOfClass:[UPCStructuredDataAction class]]) {
        return indexPath;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPCStructuredDataAction *action = [(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    action.action(tableView, indexPath);
}

@end
