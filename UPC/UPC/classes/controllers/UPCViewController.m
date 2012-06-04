//
//  UPCViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 16/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCViewController.h"
#import "UPCResponsiveWebViewController.h"


#pragma mark Class extension

@interface UPCViewController ()

@property (strong, nonatomic) NSDictionary *responsiveURLs;
@property (strong, nonatomic) NSDictionary *titles;

@end


#pragma mark - Class implementation

@implementation UPCViewController

#pragma mark Synthesized properties

@synthesize responsiveURLs;
@synthesize titles;

#pragma mark View lifecycle management

- (void)viewDidLoad
{
    self.responsiveURLs = [NSDictionary dictionaryWithObjectsAndKeys:@"http://www.upc.edu/grau/graus.php?lang=ca", @"graus", @"http://www.upc.edu/master/masters.php?lang=ca", @"masters", @"http://m.atenea.upc.edu", @"atenea", nil];
    self.titles = [NSDictionary dictionaryWithObjectsAndKeys:@"Graus", @"graus", @"Màsters universitaris", @"masters", @"Atenea", @"atenea", nil];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.responsiveURLs = nil;
    self.titles = nil;
    [super viewDidUnload];
}

#pragma Event management

- (IBAction)videosButtonTapped:(id)sender 
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/es/institution/universitat-politecnica-catalunya./id465046416"]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"graus"] || [segue.identifier isEqualToString:@"masters"] || [segue.identifier isEqualToString:@"atenea"]) {
        UPCResponsiveWebViewController *webViewController = (UPCResponsiveWebViewController *)[segue destinationViewController];
        webViewController.url = [NSURL URLWithString:[self.responsiveURLs objectForKey:segue.identifier]];
        webViewController.navigationItem.title = [self.titles objectForKey:segue.identifier];
    }
}

@end
