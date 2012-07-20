//
//  UPCSearchResultsSelectionViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 20/07/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCSearchResultsSelectionViewController.h"
#import "UPCSearchResultSelectionCell.h"
#import "UISwitch+SearchResultIndex.h"


#pragma mark Class extension

@interface UPCSearchResultsSelectionViewController ()
@property (strong, nonatomic) NSMutableIndexSet *selectedSearchResultsIndexes;
@end


#pragma mark - Class implementation

@implementation UPCSearchResultsSelectionViewController

#pragma mark Synthesized properties

@synthesize delegate                     = _delegate;
@synthesize searchResults                = _searchResults;
@synthesize selectedSearchResultsIndexes = _selectedSearchResultsIndexes;

#pragma mark View lifecycle management

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedSearchResultsIndexes = [[NSMutableIndexSet alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.selectedSearchResultsIndexes = nil;
}

#pragma mark Selection management

- (NSArray *)selectedSearchResults
{
    NSMutableArray *selectedSearchResults = [[NSMutableArray alloc] init];
    [self.searchResults enumerateObjectsAtIndexes:self.selectedSearchResultsIndexes options:NULL usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedSearchResults addObject:obj];
    }];
    return [NSArray arrayWithArray:selectedSearchResults];
}

- (void)switchSearchResultSelection:(id)sender
{
    UISwitch *searchResultSwitch = (UISwitch *)sender;
    NSInteger searchResultIndex = searchResultSwitch.searchResultIndex;
    if (searchResultSwitch.on) {
        [self.selectedSearchResultsIndexes addIndex:searchResultIndex];
    } else {
        [self.selectedSearchResultsIndexes removeIndex:searchResultIndex];
    }
}

- (void)selectionDone:(id)sender
{
    [self.delegate selectionDone:self];
}

#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [[self.searchResults objectAtIndex:indexPath.row] name];
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(193, 500) lineBreakMode:UILineBreakModeWordWrap];
    return MAX(textSize.height + 17, 44);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPCSearchResultSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SEARCH_RESULT_SELECTION_CELL"];
    cell.nameLabel.text = [[self.searchResults objectAtIndex:indexPath.row] name];
    cell.selectedSwitch.searchResultIndex = indexPath.row;
    cell.selectedSwitch.on = [self.selectedSearchResultsIndexes containsIndex:indexPath.row];
    [cell sizeToFit];
    return cell;
}

@end
