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
#import "UPCLocality.h"
#import "UPCCenter.h"


SPEC_BEGIN(UPCLocalityMappingSpec)

describe(@"UPCLocalityMappings", ^{
    context(@"when parsing a valid locality list result", ^{
        __block NSArray *mappedLocalities;
        __block UPCLocality *mappedLocality;
        
        beforeAll(^{
            RKJSONParserJSONKit *parser = (RKJSONParserJSONKit *)[[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeJSON];
            id parsedLocalities = [parser objectFromResource:@"localities.json" bundledWithClass:[self class] error:NULL];
            RKObjectMappingProvider *provider = [UPCRestKitConfigurator sharedManager].mappingProvider;
            [provider setMapping:[provider objectMappingForClass:[UPCLocality class]] forKeyPath:@""];
            RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:parsedLocalities mappingProvider:provider];
            mappedLocalities = [[mapper performMapping] asCollection];
        });
        
        it(@"should have parsed the correct number of results", ^{
            [[theValue([mappedLocalities count]) should] equal:theValue(8)];
        });
        
        context(@"for Barcelona", ^{
            beforeAll(^{
                mappedLocality = [mappedLocalities objectAtIndex:0];
            });
            
            it(@"should have correctly parsed all the attributes", ^{
                [[mappedLocality.name should] equal:@"Barcelona"];
                [[theValue(mappedLocality.latitude) should] equal:41.3878212 withDelta:1e-7];
                [[theValue(mappedLocality.longitude) should] equal:2.1699286 withDelta:1e-7];
            });
            
            it(@"should have correctly parsed its own centers", ^{
                [[theValue([mappedLocality.ownCenters count]) should] equal:theValue(9)];
                UPCCenter *center = [mappedLocality.ownCenters objectAtIndex:0];
                [[center.identifier should] equal:@"103"];
                [[center.name should] equal:@"Centre de Formació Interdisciplinària Superior"];
            });
            
            it(@"should have correctly parsed its attached centers", ^{
                [[theValue([mappedLocality.attachedCenters count]) should] equal:theValue(2)];
                UPCCenter *center = [mappedLocality.attachedCenters objectAtIndex:0];
                [[center.identifier should] equal:@"325"];
                [[center.name should] equal:@"Centre Universitari EAE"];
            });
        });
    });
});

SPEC_END
