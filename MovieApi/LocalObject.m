//  LocalObject.m
//
//  Created by Fan Tsai Ming on 24/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalObject.h"

@implementation LocalObject

+(int)rtnIntByDeviceCurrentLanguage{
  int targetLanguageInt = 0;
  
  //if you allowed user to set Language in APP, the data is should be saved in NSUserDefaults
  /*
  NSNumber *settingLanguageNSNumber; = [[NSUserDefaults standardUserDefaults] objectForKey:NSUSERDEFAULTS_SETTING_LANGUAGE_NSNUMBER];
  targetLanguageInt = [settingLanguageNSNumber intValue];
  */
  
  //if never settting language before, just detect the current local language int device
  if (targetLanguageInt == 0) {
    NSString *deviceLocaleLanguageString = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    //current language is Traditional Chinese
    if ([deviceLocaleLanguageString isEqualToString:@"zh-Hant"]) {
      targetLanguageInt = Language_TraditionalChinese;
      
    //current language is Simplified Chinese
    }else if([deviceLocaleLanguageString isEqualToString:@"zh-Hans"]) {
      targetLanguageInt = Language_SimplifiedChinese;
      
    //current language is Others excpet Chinese, just return English
    }else{
      targetLanguageInt = Language_English;
    }
  }
  
  return targetLanguageInt;
}

//Easy way to add header in file name
//Ex: There are three kind of images in APP: tch_logo.png, sch_logo.png, and en_logo.png
//[UIImage imageNamed:[NSString stringWithFormat:@"%@_logo.png",languageHeadString]]
+(NSString*)rtnHeadStringByCurrentLanguage{
  int currentLangeageInt = [self rtnIntByDeviceCurrentLanguage];
  NSString *languageHeadString;
  
  if (currentLangeageInt == Language_TraditionalChinese) {
    languageHeadString = @"tch";
  }else if (currentLangeageInt == Language_SimplifiedChinese) {
    languageHeadString = @"sch";
  }else {
    languageHeadString = @"en";
  }
  
  return languageHeadString;
}

//Have to set Localizable.strings first
//Should have these real folders in project folder: en.lproj, zh-Hant.lproj, zh-Hans.lproj
+(NSString*)rtnLocStrWithStr:(NSString*)inputString{//rtnLocalStringWithInputString
  int targetLanguageInt = 0; 
  NSString *path;
  
  targetLanguageInt = [self rtnIntByDeviceCurrentLanguage];
	if(targetLanguageInt == Language_English)
		path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
	else if(targetLanguageInt == Language_TraditionalChinese)
		path = [[NSBundle mainBundle] pathForResource:@"zh-Hant" ofType:@"lproj"];
  else if(targetLanguageInt == Language_SimplifiedChinese)
    path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
  else path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
	
	NSBundle *languageBundle = [NSBundle bundleWithPath:path];
	NSString *targetString = [languageBundle localizedStringForKey:inputString value:@"" table:nil];
  
	return targetString;
}

@end
