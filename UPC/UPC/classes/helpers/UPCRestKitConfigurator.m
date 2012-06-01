//
//  UPCRestKitConfigurator.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 18/05/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCRestKitConfigurator.h"
#import "RestKit/RKJSONParserJSONKit.h"
#import "UPCSearchResult.h"
#import "UPCLocality.h"
#import "UPCCenter.h"
#import "UPCBuilding.h"
#import "UPCUnit.h"
#import "UPCQualifications.h"


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
    
    RKObjectMapping *centerMapping = [RKObjectMapping mappingForClass:[UPCCenter class]];
    [centerMapping mapKeyPath:@"id"     toAttribute:@"identifier"];
    [centerMapping mapKeyPath:@"nom_ca" toAttribute:@"name"];
    
    RKObjectMapping *localityMapping = [RKObjectMapping mappingForClass:[UPCLocality class]];
    [localityMapping mapKeyPath:@"nom"       toAttribute:@"name"];
    [localityMapping mapKeyPath:@"coord.lat" toAttribute:@"latitude"];
    [localityMapping mapKeyPath:@"coord.lon" toAttribute:@"longitude"];
    [localityMapping mapKeyPath:@"centres.propis"   toRelationship:@"ownCenters"      withMapping:centerMapping];
    [localityMapping mapKeyPath:@"centres.adscrits" toRelationship:@"attachedCenters" withMapping:centerMapping];
    
    RKObjectMapping *qualificationsMapping = [RKObjectMapping mappingForClass:[UPCQualifications class]];
    [qualificationsMapping mapKeyPath:@"id"     toAttribute:@"identifier"];
    [qualificationsMapping mapKeyPath:@"nom_ca" toAttribute:@"name"];
    
    RKObjectMapping *unitMapping = [RKObjectMapping mappingForClass:[UPCUnit class]];
    [unitMapping mapKeyPath:@"id"             toAttribute:@"identifier"];
    [unitMapping mapKeyPath:@"nom_ca"         toAttribute:@"name"];
    [unitMapping mapKeyPath:@"campus_ca"      toAttribute:@"campusName"];
    [unitMapping mapKeyPath:@"sigles"         toAttribute:@"acronym"];
    [unitMapping mapKeyPath:@"codi_upc"       toAttribute:@"code"];
    [unitMapping mapKeyPath:@"adreça"         toAttribute:@"address"];
    [unitMapping mapKeyPath:@"localitat"      toAttribute:@"locality"];
    [unitMapping mapKeyPath:@"codi_postal"    toAttribute:@"postcode"];
    [unitMapping mapKeyPath:@"director"       toAttribute:@"directorName"];
    [unitMapping mapKeyPath:@"telefon"        toAttribute:@"phone"];
    [unitMapping mapKeyPath:@"fax"            toAttribute:@"fax"];
    [unitMapping mapKeyPath:@"email"          toAttribute:@"emailAddress"];
    [unitMapping mapKeyPath:@"web_ca"         toAttribute:@"webAddress"];
    [unitMapping mapKeyPath:@"presentacio_ca" toAttribute:@"introduction"];
    [unitMapping mapKeyPath:@"video_youtube"  toAttribute:@"youTubeVideoAddress"];
    [unitMapping mapKeyPath:@"fotos.normal"   toAttribute:@"photoAddress"];
    [unitMapping mapKeyPath:@"fotos.video"    toAttribute:@"videoThumbnailAddress"];
    [unitMapping mapKeyPath:@"web_matricula"  toAttribute:@"enrollmentWebAddress"];
    [unitMapping mapKeyPath:@"coord.lat"      toAttribute:@"latitude"];
    [unitMapping mapKeyPath:@"coord.lon"      toAttribute:@"longitude"];
    [unitMapping mapKeyPath:@"estudis.graus"              toRelationship:@"degrees"      withMapping:qualificationsMapping];
    [unitMapping mapKeyPath:@"estudis.dobles_titulacions" toRelationship:@"jointDegrees" withMapping:qualificationsMapping];
    [unitMapping mapKeyPath:@"estudis.masters"            toRelationship:@"masters"      withMapping:qualificationsMapping];
    
    RKObjectMapping *buildingMapping = [RKObjectMapping mappingForClass:[UPCBuilding class]];
    [buildingMapping mapKeyPath:@"nom_ca"      toAttribute:@"name"];
    [buildingMapping mapKeyPath:@"campus_ca"   toAttribute:@"campusName"];
    [buildingMapping mapKeyPath:@"adreça"      toAttribute:@"address"];
    [buildingMapping mapKeyPath:@"localitat"   toAttribute:@"locality"];
    [buildingMapping mapKeyPath:@"codi_postal" toAttribute:@"postcode"];
    [buildingMapping mapKeyPath:@"coord.lat"   toAttribute:@"latitude"];
    [buildingMapping mapKeyPath:@"coord.lon"   toAttribute:@"longitude"];
    [buildingMapping mapKeyPath:@"unitats"     toRelationship:@"units" withMapping:unitMapping];
    
    [self.mappingProvider addObjectMapping:searchResultMapping];
    [self.mappingProvider addObjectMapping:centerMapping];
    [self.mappingProvider addObjectMapping:localityMapping];
    [self.mappingProvider addObjectMapping:unitMapping];
    [self.mappingProvider addObjectMapping:qualificationsMapping];
    [self.mappingProvider addObjectMapping:buildingMapping];
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
