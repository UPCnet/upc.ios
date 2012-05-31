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
#import "UPCCampus.h"
#import "UPCCenter.h"


SPEC_BEGIN(UPCCampusMappingSpec)

describe(@"UPCSearchResultMappings", ^{
    context(@"when parsing a valid campus list result", ^{
        __block NSArray *mappedCampuses;
        __block UPCCampus *mappedCampus;
        
        beforeAll(^{
            RKJSONParserJSONKit *parser = (RKJSONParserJSONKit *)[[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeJSON];
            id parsedCampuses = [parser objectFromResource:@"campuses.json" bundledWithClass:[self class] error:NULL];
            RKObjectMappingProvider *provider = [UPCRestKitConfigurator sharedManager].mappingProvider;
            [provider setMapping:[provider objectMappingForClass:[UPCCampus class]] forKeyPath:@""];
            RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:parsedCampuses mappingProvider:provider];
            mappedCampuses = [[mapper performMapping] asCollection];
        });
        
        it(@"should have parsed the correct number of results", ^{
            [[theValue([mappedCampuses count]) should] equal:theValue(12)];
        });
        
        context(@"for the 'Urgell' campus", ^{
            beforeAll(^{
                mappedCampus = [mappedCampuses objectAtIndex:0];
            });
            
            it(@"should have correctly parsed all the attributes", ^{
                [[mappedCampus.name should] equal:@"Urgell"];
                [[mappedCampus.locality should] equal:@"Barcelona"];
                [[theValue(mappedCampus.latitude) should] equal:41.388474 withDelta:1e-7];
                [[theValue(mappedCampus.longitude) should] equal:2.148685 withDelta:1e-7];
            });
            
            it(@"should have correctly parsed its own centers", ^{
                [[theValue([mappedCampus.ownCenters count]) should] equal:theValue(0)];
            });
            
            it(@"should have correctly parsed its attached centers", ^{
                [[theValue([mappedCampus.attachedCenters count]) should] equal:theValue(1)];
                UPCCenter *center = [mappedCampus.attachedCenters objectAtIndex:0];
                [[center.identifier should] equal:@"378"];
                [[center.name should] equal:@"Escola Universitària d'Enginyeria Tècnica Industrial de Barcelona"];
            });
        });
        
        context(@"for the 'Campus de Terrassa' campus", ^{
            beforeAll(^{
                mappedCampus = [mappedCampuses objectAtIndex:10];
            });
            
            it(@"should have correctly parsed all the attributes", ^{
                [[mappedCampus.name should] equal:@"Campus de Terrassa"];
                [[mappedCampus.locality should] equal:@"Terrassa"];
                [[theValue(mappedCampus.latitude) should] equal:41.563099 withDelta:1e-7];
                [[theValue(mappedCampus.longitude) should] equal:2.023394 withDelta:1e-7];
            });
            
            it(@"should have correctly parsed its own centers", ^{
                [[theValue([mappedCampus.ownCenters count]) should] equal:theValue(3)];
                UPCCenter *center = [mappedCampus.ownCenters objectAtIndex:0];
                [[center.identifier should] equal:@"110"];
                [[center.name should] equal:@"Escola Tècnica Superior d'Enginyeries Industrial i Aeronàutica de Terrassa"];
            });
            
            it(@"should have correctly parsed its attached centers", ^{
                [[theValue([mappedCampus.attachedCenters count]) should] equal:theValue(1)];
                UPCCenter *center = [mappedCampus.attachedCenters objectAtIndex:0];
                [[center.identifier should] equal:@"1066"];
                [[center.name should] equal:@"Centre de la Imatge i la Tecnologia Multimèdia"];
            });
        });
    });
});

SPEC_END
