//
//  LocalObject.h
//
//  Created by Fan Tsai Ming on 24/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//How to use it?
//  1. Define:
//    typedef enum {
//      TraditionalChinese = 1,
//      SimplifiedChinese = 2,
//      English = 3,
//    } CurrentLanguage;
//
//  2. Method for getting the current language which is used in device
//    int currentLanguageInt = [LocalObject rtnIntByDeviceCurrentLanguage];
//
//  3. Method for getting a String: (Have to set Localizable.strings first)
//    NSString *testString = [LocalObject localLanguageWithString:@"test"];

//How to use localizable.strings?
//  1. Create:
//    enter "genstrings viewcontroller.m" in Terminal
//  2. Synchronize:
//    enter "genstrings -o en.lproj *.m" in Terminal

#import <Foundation/Foundation.h>

typedef enum {
	Language_TraditionalChinese = 1,
	Language_SimplifiedChinese = 2,
  Language_English = 3,
} CurrentLanguage;

@interface LocalObject : NSObject

+(int)rtnIntByDeviceCurrentLanguage;
+(NSString*)rtnHeadStringByCurrentLanguage;
+(NSString*)rtnLocStrWithStr:(NSString*)inputString;

@end
