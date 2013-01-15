//
//  FileLoader.m
//  QCPluginCreationHelper
//
//  Created by chris on 13/01/2013.
//  Copyright (c) 2013 Chris Birch. All rights reserved.
//

#import "FileLoader.h"
#import "QCProperty.h"

#define AUTHOR_STRING @"\n\n#######################################################################\n#\n# Auto generated code created using QC Plugin Assistant by Chris Birch\n#\n#######################################################################\n\n\n"

@implementation FileLoader

-(PROPERTY_TYPE)stringToType:(NSString*)propertyTypeString
{
    NSString* lowerCase = [propertyTypeString lowercaseString];
    
    if ([lowerCase isEqualToString:@"bool"])
    {
        return PROPERTY_TYPE_BOOL;
    }
    else if ([lowerCase isEqualToString:@"double"])
    {
        return PROPERTY_TYPE_DOUBLE;
    }
    else if ([lowerCase isEqualToString:@"uint"] || [lowerCase isEqualToString:@"int"])
    {
        return PROPERTY_TYPE_UINT;
    }
    else if ([lowerCase isEqualToString:@"string"])
    {
        return PROPERTY_TYPE_STRING;
    }

    [NSException raise:@"Invalid property type" format:@"Type \"%@\" unknown",propertyTypeString];
    return 0;

}


-(NSString *)generatedDefines
{
    NSMutableString* str = [[NSMutableString alloc] init];
    
    for (QCProperty* property in _properties)
    {
        [str appendFormat:@"%@\n", property.generatedCodeDefine];
    }
    
    return str;
}

-(NSString *)generatedProperties
{
    NSMutableString* str = [[NSMutableString alloc] init];
    
    for (QCProperty* property in _properties)
    {
        [str appendFormat:@"%@\n", property.generatedCodePropertyDefinition];
    }
    
    return str;
}

-(NSString *)generatedPortAttributeDescriptions
{
    NSMutableString* str = [[NSMutableString alloc] init];
    
    for (QCProperty* property in _properties)
    {
        [str appendFormat:@"%@\n", property.generatedCodePortAttributeDescription];
    }
    
    return str;
}

-(NSString *)generatedSynthesizes
{
    NSMutableString* str = [[NSMutableString alloc] init];
    
    for (QCProperty* property in _properties)
    {
        [str appendFormat:@"%@\n", property.generatedCodeDynamic];
    }
    
    return str;
}

-(NSString *)generatedValueChangedCode
{
    NSMutableString* str = [[NSMutableString alloc] init];
    
    for (QCProperty* property in _properties)
    {
        [str appendFormat:@"%@\n", property.generatedCodeValueChanged];
    }
    
    return str;
}

-(void)loadFile:(NSString*) file
{
    NSDictionary* dictionary = [NSArray arrayWithContentsOfFile:file];
    
    BOOL isFirst = YES;
    
    NSMutableArray* properties = [[NSMutableArray alloc] init];
    
    for (NSDictionary* propertyDictionary in dictionary)
    {
        QCProperty* property = [[QCProperty alloc] init];
    
        property.name = [propertyDictionary objectForKey:@"Name"];
        
        if (!property.name || [property.name isEqualToString:@""])
        {
            NSLog(@"Property name cant be empty. Skipping item");
            continue;
        }
        
        //Should we add an "else" before the if in the valuechanged section for this property
        if (isFirst)
        {
            property.isFirstProperty = YES;
            isFirst = NO;
        }
        
        //have we been supplied with a friendlyName?
        if ([[propertyDictionary allKeys] containsObject:@"FriendlyName"])
            property.friendlyName = [propertyDictionary objectForKey:@"FriendlyName"];
        
        property.isInputProperty = [((NSNumber*)[propertyDictionary objectForKey:@"IsInput"]) boolValue];
        property.comment = [propertyDictionary objectForKey:@"Comment"];
        property.type = [self stringToType:[propertyDictionary objectForKey:@"Type"]];
        property.valueChangedTarget = [propertyDictionary objectForKey:@"ValueChangedTarget"];
        property.defaultValue = [propertyDictionary objectForKey:@"DefaultValue"];
        //have we been supplied with a value changed body?
        if ([[propertyDictionary allKeys] containsObject:@"ValueChangedBody"])
            property.valueChangedBody = [propertyDictionary objectForKey:@"ValueChangedBody"];
        else
            //we havent so just use the default behaviour of constructing the value changed body using
            //the value changed target and the generated property name
            property.valueChangedBody = nil;

        
        [properties addObject:property];
    }
    
    _properties = properties;
}


-(void)generateCodeToFile:(NSString*)filename fromPListFile: (NSString*)plistFilename
{
    [self loadFile:plistFilename];
    
    NSMutableString* outputString = [[NSMutableString alloc] init];
    
    [outputString appendFormat: AUTHOR_STRING];
    
    
    [outputString appendFormat:@"\n\n###################################\n# Place in the plugin .h file\n###################################\n\n\n"];
    //Build defines
    [outputString appendFormat:@"//Port Defines\n\n%@\n\n", self.generatedDefines];
    //build properties
    [outputString appendFormat:@"//Port Properties\n\n%@\n", self.generatedProperties];
    
    [outputString appendFormat:@"\n\n###################################\n# Place in the plugin .m file\n###################################\n\n\n"];
    
    //build synths
    [outputString appendFormat:@"//Port Synthesizes\n\n%@\n", self.generatedSynthesizes];
    //build port attributes
    [outputString appendFormat:@"//Port Attributes\n\n%@\n", self.generatedPortAttributeDescriptions];
    //build value changed
    [outputString appendFormat:@"//Port Value Changed code\n\n%@\n", self.generatedValueChangedCode];
    
    NSLog(@"%@",outputString);
    NSError* error=nil;
    
    if ([outputString writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:&error])
    {
        NSLog(@"File created: %@",filename);
    }
    else
    {
        NSLog(@"Problem whilst creating file: %@\n\n%@",filename,error.description);
    }
    
}


@end
