//
//  UPCSearchResultsMappingSpecs.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 18/05/12.
//  Copyright 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "Kiwi.h"
#import "RestKit/RestKit.h"
#import "RKJSONParserJSONKit+TestAdditions.h"
#import "UPCRestKitConfigurator.h"
#import "UPCBuilding.h"
#import "UPCUnit.h"


SPEC_BEGIN(UPCBuildingMappingSpec)

describe(@"UPCBuildingMappings", ^{
    context(@"when parsing a valid building", ^{
        __block UPCBuilding *mappedBuilding;
        
        beforeAll(^{
            RKJSONParserJSONKit *parser = (RKJSONParserJSONKit *)[[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeJSON];
            id parsedBuildings = [parser objectFromResource:@"building.json" bundledWithClass:[self class] error:NULL];
            RKObjectMappingProvider *provider = [UPCRestKitConfigurator sharedManager].mappingProvider;
            [provider setMapping:[provider objectMappingForClass:[UPCBuilding class]] forKeyPath:@""];
            RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:parsedBuildings mappingProvider:provider];
            mappedBuilding = [[mapper performMapping] asObject];
        });
        
        it(@"should have correctly parsed all the attributes", ^{
            [[mappedBuilding.name should] equal:@"Edifici A"];
            [[mappedBuilding.campusName should] equal:@"Campus Diagonal Sud"];
            [[mappedBuilding.address should] equal:@"Campus Campus Diagonal Sud, Av. Diagonal, 649, 08028 Barcelona"];
            [[mappedBuilding.locality should] equal:@"Barcelona"];
            [[mappedBuilding.postcode should] equal:@"08028"];
            [[theValue(mappedBuilding.latitude) should] equal:41.3843384 withDelta:1e-7];
            [[theValue(mappedBuilding.longitude) should] equal:2.1136291 withDelta:1e-7];
        });
        
        it(@"should have correctly parsed its units", ^{
            [[theValue([mappedBuilding.units count]) should] equal:theValue(20)];
            UPCUnit *firstUnit = [mappedBuilding.units objectAtIndex:0];
            [[firstUnit.identifier should] equal:@"107"];
            [[firstUnit.name should] equal:@"Escola Tècnica Superior d'Arquitectura de Barcelona"];
        });
    });
});

SPEC_END
