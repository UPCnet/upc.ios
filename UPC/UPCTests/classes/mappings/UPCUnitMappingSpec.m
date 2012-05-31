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
#import "UPCUnit.h"
#import "UPCQualifications.h"


SPEC_BEGIN(UPCUnitMappingSpec)

describe(@"UPCUnitMappings", ^{
    context(@"when parsing a valid unit", ^{
        __block UPCUnit *mappedUnit;
        
        beforeAll(^{
            RKJSONParserJSONKit *parser = (RKJSONParserJSONKit *)[[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeJSON];
            id parsedUnits = [parser objectFromResource:@"unit.json" bundledWithClass:[self class] error:NULL];
            RKObjectMappingProvider *provider = [UPCRestKitConfigurator sharedManager].mappingProvider;
            [provider setMapping:[provider objectMappingForClass:[UPCUnit class]] forKeyPath:@""];
            RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:parsedUnits mappingProvider:provider];
            mappedUnit = [[mapper performMapping] asObject];
        });
        
        it(@"should have correctly parsed all the attributes", ^{
            [[mappedUnit.identifier should] equal:@"107"];
            [[mappedUnit.name should] equal:@"Escola Tècnica Superior d'Arquitectura de Barcelona"];
            [[mappedUnit.campusName should] equal:@"Campus Diagonal Sud"];
            [[mappedUnit.acronym should] equal:@"ETSAB"];
            [[mappedUnit.code should] equal:@"210"];
            [[mappedUnit.address should] equal:@"Av. Diagonal, 649. Edifici A. 08028 Barcelona"];
            [[mappedUnit.locality should] equal:@"Barcelona"];
            [[mappedUnit.postcode should] equal:@"08028"];
            [[mappedUnit.directorName should] equal:@"Ferran Sagarra Trias"];
            [[mappedUnit.phone should] equal:@"93 401 63 29 / 63 33"];
            [[mappedUnit.fax should] equal:@"93 401 58 71"];
            [[mappedUnit.emailAddress should] equal:@"informacio.etsab@(upc.edu)"];
            [[mappedUnit.webAddress should] equal:@"http://www.etsab.upc.edu"];
            [[mappedUnit.introduction should] equal:@"L&rsquo;<strong>Escola T&egrave;cnica Superior d&rsquo;Arquitectura de Barcelona </strong>&eacute;s una <strong>escola centen&agrave;ria</strong>,<strong>&nbsp;</strong>fundada l'any 1875, que ha format milers d&rsquo;arquitectes en les especialitats de projectes, urbanisme i edificaci&oacute;. El seu professorat, constitu&iuml;t per <strong>docents de prestigi i professionals reconeguts</strong>, ha contribu&iuml;t amb la seva tasca a donar a Barcelona el renom que t&eacute; actualment en l&rsquo;&agrave;mbit de l&rsquo;arquitectura. Aix&ograve; fa que sigui un Centre molt sol&middot;licitat per estudiantat d&rsquo;altres pa&iuml;sos. &nbsp;<br />\r\n<br />\r\nA l&rsquo;Escola disposar&agrave;s de biblioteca, sala d&rsquo;exposicions, sala d&rsquo;actes, aules d&rsquo;estudi amb connexi&oacute; a Internet, laboratoris docents, papereria, llibreria, taller de maquetes, etc. Els convenis de cooperaci&oacute; educativa que mantenim amb nombrosos despatxos professionals, empreses i institucions et possibilitaran la realitzaci&oacute; de <strong>pr&agrave;ctiques remunerades </strong>i l&rsquo;adquisici&oacute; <strong>d&rsquo;experi&egrave;ncia professional</strong>. Tamb&eacute; tindr&agrave;s&nbsp;l&rsquo;oportunitat de gaudir de l&rsquo;experi&egrave;ncia que aporta la mobilitat internacional (uns 130 estudiants i estudiantes cada curs) i de nombroses activitats culturals i associatives. <br />\r\n<br />\r\nL&rsquo;ETSAB <strong>allotja molts centres de recerca i laboratoris</strong>, com ara el&nbsp;Centre de Documentaci&oacute; de Projectes d&rsquo;Arquitectura de Catalunya (CDPAC), el Centre de Pol&iacute;tica del S&ograve;l i Valoracions (CPSV), el Laboratori de Modelitzaci&oacute; Virtual de la Ciutat (LMVC), el Laboratori de T&egrave;cniques Gr&agrave;fiques Arquitect&ograve;niques (LTGA) i el Laboratori d&rsquo;Urbanisme de Barcelona (LUB)."];
            [[mappedUnit.youTubeVideoAddress should] equal:@"http://youtu.be/BzjuRRbBKFc"];
            [[mappedUnit.photoAddress should] equal:@"http://www.upc.edu/gestioestudis/files/fotos_unitats/107_2.png"];
            [[mappedUnit.videoThumbnailAddress should] equal:@"http://www.upc.edu/gestioestudis/files/fotos_unitats/107_4.jpg"];
            [[mappedUnit.enrollmentWebAddress should] equal:@"http://www.etsab.upc.es/web/frame.htm?i=2&m=estudios&s=estudios-g&c=acceso"];
            [[theValue(mappedUnit.latitude) should] equal:41.383976 withDelta:1e-7];
            [[theValue(mappedUnit.longitude) should] equal:2.114557 withDelta:1e-7];
        });
        
        it(@"should have correctly parsed its degrees", ^{
            [[theValue([mappedUnit.degrees count]) should] equal:theValue(2)];
            UPCQualifications *firstDegree = [mappedUnit.degrees objectAtIndex:0];
            [[firstDegree.identifier should] equal:@"79"];
            [[firstDegree.name should] equal:@"Arquitectura"];
        });
        
        it(@"should have correctly parsed its joint degrees", ^{
            [[theValue([mappedUnit.jointDegrees count]) should] equal:theValue(0)];
        });
        
        it(@"should have correctly parsed its masters", ^{
            [[theValue([mappedUnit.masters count]) should] equal:theValue(6)];
            UPCQualifications *firstMaster = [mappedUnit.masters objectAtIndex:0];
            [[firstMaster.identifier should] equal:@"21"];
            [[firstMaster.name should] equal:@"Màster universitari en Arquitectura, Energia i Medi Ambient"];
        });
    });
});

SPEC_END
