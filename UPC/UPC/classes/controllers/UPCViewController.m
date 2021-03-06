//
//  UPCViewController.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 16/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCAppDelegate.h"
#import "UPCViewController.h"
#import "UPCResponsiveWebViewController.h"
#import <GAI.h>
#import <GAIFields.h>
#import <GAITracker.h>
#import <GAIDictionaryBuilder.h>

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
    self.responsiveURLs = @{@"graus": @"http://www.upc.edu/grau/graus.php?lang=ca",
                            @"masters": @"http://www.upc.edu/master/masters.php?lang=ca",
                            @"mastersProfessionals": @"http://m.formaciocontinua.upc.edu/cat",
                            @"atenea": @"http://m.atenea.upc.edu?app=true&lang=ca",
                            @"bibliotecnica": @"http://m.bibliotecnica.upc.edu/home/index.php?app=true",
                            @"upcommons": @"http://m.bibliotecnica.upc.edu/upcommons/index.php?app=true"};
    
    self.titles = @{@"graus": @"Graus", @"masters": @"Màsters universitaris", @"mastersProfessionals": @"Formació permanent", @"atenea": @"Atenea", @"bibliotecnica": @"Biblioteca", @"upcommons": @"UPCommons"};

    [super viewDidLoad];

    [[GAI sharedInstance].defaultTracker set:kGAIScreenName
                                       value:@"Home Screen"];
    // Send the screen view.
    [[GAI sharedInstance].defaultTracker
     send:[[GAIDictionaryBuilder createAppView] build]];
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
    if ([segue.identifier isEqualToString:@"graus"] || [segue.identifier isEqualToString:@"masters"] || [segue.identifier isEqualToString:@"mastersProfessionals"] || [segue.identifier isEqualToString:@"atenea"] || [segue.identifier isEqualToString:@"bibliotecnica"] || [segue.identifier isEqualToString:@"upcommons"]) {
        UPCResponsiveWebViewController *webViewController = (UPCResponsiveWebViewController *)[segue destinationViewController];
        webViewController.url = [NSURL URLWithString:[self.responsiveURLs objectForKey:segue.identifier]];
        webViewController.navigationItem.title = [self.titles objectForKey:segue.identifier];
    }
}

@end
