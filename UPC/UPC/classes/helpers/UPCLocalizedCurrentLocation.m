//
//  UPCLocalizedCurrentLocation.m
//  UPC
//
//  Created by Jose Gonzalez Gomez on 01/06/12.
//  Copyright (c) 2012 Universitat Politècnica de Catalunya. All rights reserved.
//

#import "UPCLocalizedCurrentLocation.h"


@implementation UPCLocalizedCurrentLocation

+ (NSString *)currentLocationStringForCurrentLanguage {
    
    static NSDictionary *localizedStringDictionary;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localizedStringDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                   @"Huidige locatie", @"nl",
                                                   @"Current Location", @"en",
                                                   @"Lieu actuel", @"fr",
                                                   @"Aktueller Ort", @"de",
                                                   @"Posizione attuale", @"it",
                                                   @"現在地", @"ja",
                                                   @"Ubicación actual", @"es",
                                                   @"الموقع الحالي", @"ar",
                                                   @"Ubicació actual", @"ca",
                                                   @"Současná poloha", @"cs",
                                                   @"Aktuel lokalitet", @"da",
                                                   @"Τρέχουσα τοποθεσία", @"el",
                                                   @"Current Location", @"en-GB",
                                                   @"Nykyinen sijainti", @"fi",
                                                   @"מיקום נוכחי", @"he",
                                                   @"Trenutna lokacija", @"hr",
                                                   @"Jelenlegi helyszín", @"hu",
                                                   @"Lokasi Sekarang", @"id",
                                                   @"현재 위치", @"ko",
                                                   @"Lokasi Semasa", @"ms",
                                                   @"Nåværende plassering", @"no",
                                                   @"Bieżące położenie", @"pl",
                                                   @"Localização Atual", @"pt",
                                                   @"Localização actual", @"pt-PT",
                                                   @"Loc actual", @"ro",
                                                   @"Текущая геопозиция", @"ru",
                                                   @"Aktuálna poloha", @"sk",
                                                   @"Nuvarande plats", @"sv",
                                                   @"ที่ตั้งปัจจุบัน", @"th",
                                                   @"Şu Anki Yer", @"tr",
                                                   @"Поточне місце", @"uk",
                                                   @"Vị trí Hiện tại", @"vi",
                                                   @"当前位置", @"zh-CN",
                                                   @"目前位置", @"zh-TW",
                                                   nil];
    });
    
    
    NSString *currentLanguageCode = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    
    if ([localizedStringDictionary valueForKey:currentLanguageCode]) {
        return [NSString stringWithString:[localizedStringDictionary valueForKey:currentLanguageCode]];
    } else {
        return [NSString stringWithString:[localizedStringDictionary valueForKey:@"en"]];
    }
}

@end
