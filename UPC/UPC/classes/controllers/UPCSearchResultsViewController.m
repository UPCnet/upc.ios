//
//  UPCSearchResultsViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 31/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCSearchResultsViewController.h"
#import "UPCSearchResult.h"


#pragma mark Class implementation

@implementation UPCSearchResultsViewController

#pragma mark Synthesized properties

@synthesize searchResults;

#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SEARCH_RESULT_CELL = @"SEARCH_RESULT_CELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SEARCH_RESULT_CELL];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SEARCH_RESULT_CELL];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    cell.textLabel.text = [(UPCSearchResult *)[self.searchResults objectAtIndex:indexPath.row] name];
    
    return cell;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
