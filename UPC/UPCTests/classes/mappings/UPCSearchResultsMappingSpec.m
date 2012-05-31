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
#import "UPCSearchResult.h"


SPEC_BEGIN(UPCSearchResultsMappingSpec)

describe(@"UPCSearchResultMappings", ^{
    context(@"when parsing a valid search result", ^{
        __block NSArray *mappedSearchResults;
        __block UPCSearchResult *mappedSearchResult;
        
        beforeAll(^{
            RKJSONParserJSONKit *parser = (RKJSONParserJSONKit *)[[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeJSON];
            id parsedSearchResults = [parser objectFromResource:@"searchResult.json" bundledWithClass:[self class] error:NULL];
            RKObjectMappingProvider *provider = [UPCRestKitConfigurator sharedManager].mappingProvider;
            [provider setMapping:[provider objectMappingForClass:[UPCSearchResult class]] forKeyPath:@""];
            RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:parsedSearchResults mappingProvider:provider];
            mappedSearchResults = [[mapper performMapping] asCollection];
            mappedSearchResult = [mappedSearchResults objectAtIndex:0];
        });
        
        it(@"should have parsed the correct number of results", ^{
            [[theValue([mappedSearchResults count]) should] equal:theValue(3)];
        });
        
        context(@"for the first result", ^{
            it(@"should have correctly parsed all the attributes", ^{
                [[mappedSearchResult.type should] equal:@"unitat"];
                [[mappedSearchResult.identifier should] equal:@"114"];
                [[mappedSearchResult.name should] equal:@"Facultat d'Informàtica de Barcelona"];
                [[theValue(mappedSearchResult.latitude) should] equal:41.3894272 withDelta:1e-7];
                [[theValue(mappedSearchResult.longitude) should] equal:2.1133471 withDelta:1e-7];
            });
        });
    });
});

SPEC_END
