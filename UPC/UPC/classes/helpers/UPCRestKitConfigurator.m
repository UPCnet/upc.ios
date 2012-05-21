//
//  UPCRestKitConfigurator.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 18/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCRestKitConfigurator.h"
#import "UPCSearchResult.h"
#import "RestKit/RKJSONParserJSONKit.h"


#pragma mark Category for UPC web service configuration

@interface RKObjectManager (UPCRestKitConfigurator)

- (void)configureForUPCConnectivity;

@end


@implementation RKObjectManager (UPCRestKitConfigurator)

- (void)configureForUPCConnectivity
{
    // Server returns incorrect MIME type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];

    RKObjectMapping *searchResultMapping = [RKObjectMapping mappingForClass:[UPCSearchResult class]];
    [searchResultMapping mapKeyPath:@"tipus"      toAttribute:@"type"];
    [searchResultMapping mapKeyPath:@"id"         toAttribute:@"identifier"];
    [searchResultMapping mapKeyPath:@"nom_ca"     toAttribute:@"name"];
    [searchResultMapping mapKeyPath:@"coords.lat" toAttribute:@"latitude"];
    [searchResultMapping mapKeyPath:@"coords.lon" toAttribute:@"longitude"];
    
    [self.mappingProvider addObjectMapping:searchResultMapping];
}

@end


#pragma mark - Class implementation

@implementation UPCRestKitConfigurator

+ (RKObjectManager *)sharedManager
{
    static RKObjectManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://nucli.upc.edu/ws"]];
        [sharedManager configureForUPCConnectivity];
    });
    return sharedManager;
}

@end
