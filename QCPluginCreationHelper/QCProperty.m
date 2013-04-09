//
//  QCProperty.m
//  QCPluginCreationHelper
//
//  Created by chris on 13/01/2013.
//  Copyright (c) 2013 Chris Birch. All rights reserved.
//

#import "QCProperty.h"

@interface QCProperty ()
{
    
}

@end
@implementation QCProperty

//@synthesize name, comment, inputType,friendlyName,isInputProperty;
//@synthesize defaultValueIfBOOL, defaultValueIfNumber, defaultValueIfString;



-(NSString*)comment
{
    return [[NSString alloc] initWithFormat:@"//%@",_comment];
}

//-(NSString*) generateCode_Define
//{
//    NSString *formatString = @"#define INPUT_%@ @\"input%@\"";
//    
//    NSString* outputString = [[NSString alloc] initWithFormat:formatString,];
//    return outputString;
//}
//

-(NSString*)directionSpecifier_UpperCase: (BOOL)isUpperCase
{
    if (_isInputProperty)
        return isUpperCase ? @"INPUT" : @"input";
    else
        return isUpperCase ? @"OUTPUT" : @"output";
        
}

/**
 * Generates the code of a #define for the property
 */
-(NSString*) generatedCodeDefine
{
    NSString *formatString = @"%@\n#define %@_%@ @\"%@%@\"";
    
    NSString* directionDefineName = [self directionSpecifier_UpperCase:YES];
    NSString* directionPropertyName = [self directionSpecifier_UpperCase:NO];
    
    NSString* nameUCase = [_name uppercaseString];

    NSString* outputString = [[NSString alloc] initWithFormat:formatString,self.comment,directionDefineName, nameUCase, directionPropertyName, _name];
    return outputString;
}

/**
 * Generates the code of a ObjC Property for this property
 */
-(NSString*) generatedCodePropertyDefinition
{
    NSString *formatString = @"@property (%@) %@ %@%@;";
    NSString *retainType = [self memoryRetainType];
    NSString*objCType = [self objectiveCType];
    NSString* directionPropertyName = [self directionSpecifier_UpperCase:NO];
    
    
    NSString* outputString = [[NSString alloc] initWithFormat:formatString, retainType,objCType,directionPropertyName, _name];
    return outputString;
}

/**
 * Generates the code of a @dynamic for this property
 */
-(NSString*) generatedCodeDynamic
{
    NSString *formatString = @"@dynamic %@%@;";
    NSString* directionPropertyName = [self directionSpecifier_UpperCase:NO];
    
    NSString* outputString = [[NSString alloc] initWithFormat:formatString,directionPropertyName, _name];
    return outputString;
}

/**
 * Generates the code of a port attribute dictionary for this property
 */
-(NSString*) generatedCodePortAttributeDescription
{
    NSString* directionDefineName = [self directionSpecifier_UpperCase:YES];
    NSString* defaultValueFormatString = @"\n            %@, QCPortAttributeDefaultValueKey,";

    //do we need to add an else before the if?
    NSString* ifOrElseIf = _isFirstProperty ? @"" : @"else ";
    
    NSString *formatString = @"%@\n%@if([key isEqualToString:%@_%@])\n    return [NSDictionary dictionaryWithObjectsAndKeys:\n            @\"%@\", QCPortAttributeNameKey,%@\n            nil];";
    NSString* inputNameUCase = [_name uppercaseString];
    NSString* defaultValue = [self generateDefaultValue];
    
    //check we have a default value
    if (defaultValue)
    {
        defaultValue = [[NSString alloc] initWithFormat:defaultValueFormatString, defaultValue];
    }
    else
    {
        defaultValue = @"";
    }
    
    NSString* outputString = [[NSString alloc] initWithFormat:formatString, self.comment,ifOrElseIf, directionDefineName, inputNameUCase,self.friendlyName,defaultValue];
    return outputString;
}

/**
 * Generates the code of a value changed section for this property
 */
-(NSString*) generatedCodeValueChanged
{
    //Only need this code if the port is an input
    if (_isInputProperty)
    {
        NSString* directionDefineName = [self directionSpecifier_UpperCase:YES];
        NSString* directionPropertyName = [self directionSpecifier_UpperCase:NO];
        
        NSString *formatString = @"%@\nif ([self didValueForInputKeyChange:%@_%@])\n{\n%@\n}";
        NSString* inputNameUCase = [_name uppercaseString];
        NSString* valueChangedBody = nil;
     
        BOOL hasValueChangedTarget =_valueChangedTarget && ![_valueChangedTarget isEqualToString:@""];
        BOOL hasValueChangedBody = _valueChangedBody && ![_valueChangedBody isEqualToString:@""];
        
        //make sure we have been given values for this otherwise dont bother
        if (!hasValueChangedBody && !hasValueChangedTarget)
        {
            return [[NSString alloc] initWithFormat:@"//Skipping Value changed section for property: %@ as no values have been supplied for valueChangedTarget or valueChangedBody",_name];
        }
        else
        {
        
            //have we been given the exact body to insert or should we generate it?
            if (hasValueChangedBody)
            {
                valueChangedBody = [[NSString alloc] initWithFormat:@"#warning This code could be out of date as it was read in from Ports PList\n%@",self.valueChangedBody];
            }
            else//valueChanged target
            {
                NSString *generatedFormatStringValueChangedBody = @"    %@ = self.%@%@;";            

                valueChangedBody  =[[NSString alloc] initWithFormat:generatedFormatStringValueChangedBody,_valueChangedTarget, directionPropertyName, self.name];

            }

            NSString* outputString  =[[NSString alloc] initWithFormat:formatString,self.comment,directionDefineName, inputNameUCase,valueChangedBody];

            return outputString;
        }
    }
    else
        return @"";
}





#pragma mark -
#pragma mark Helpers

-(NSString *)friendlyName
{
    if (!_friendlyName || [_friendlyName isEqualToString:@""])
        return _name;
    else
        return _friendlyName;
    
}

-(NSString*) generateDefaultValue
{
    if (!_defaultValue || [_defaultValue isEqualToString:@""])
    {
        return nil;
    }
    else
    {
        switch (self.type)
        {
            case PROPERTY_TYPE_BOOL:
                return [[NSString alloc] initWithFormat:@"[NSNumber numberWithBool:%@]", _defaultValue];
            case PROPERTY_TYPE_UINT:
            case PROPERTY_TYPE_DOUBLE:
            case PROPERTY_TYPE_STRING:
            {
                return [[NSString alloc] initWithFormat:@"@\"%@\"",_defaultValue];
                
            }
                default:
                return @"";
        
        }
    }
}

-(NSString*) objectiveCType
{
    switch (self.type)
    {
        case PROPERTY_TYPE_BOOL:
            return @"BOOL";
        case PROPERTY_TYPE_UINT:
            return @"NSUInteger";
        case PROPERTY_TYPE_DOUBLE:
        {
            return @"double";
        }
        case PROPERTY_TYPE_STRING:
        {
            return @"NSString*";
        }
        case PROPERTY_TYPE_ARRAY:
        {
           return @"NSArray*";
        }
        case PROPERTY_TYPE_DICTIONARY:
        {
            return @"NSDictionary*";
        }
        case PROPERTY_TYPE_IMAGEPROVIDER:
        {
            return @"id<QCPlugInInputImageProvider>";
        }
        case PROPERTY_TYPE_IMAGESOURCE:
        {
            return @"id<QCPlugInInputImageSource>";
        }
        case PROPERTY_TYPE_CGCOLORREF:
        {
            return @"CGColorRef";
        }
            
            
        default:
            break;
    }

}

-(NSString*) memoryRetainType
{
    switch (self.type)
    {
        case PROPERTY_TYPE_BOOL:
        case PROPERTY_TYPE_UINT:
        case PROPERTY_TYPE_DOUBLE:
        case PROPERTY_TYPE_CGCOLORREF:
        case PROPERTY_TYPE_IMAGESOURCE:
        case PROPERTY_TYPE_IMAGEPROVIDER:
        {
            return @"assign";
            break;
        }
        case PROPERTY_TYPE_ARRAY:
        case PROPERTY_TYPE_DICTIONARY:
        case PROPERTY_TYPE_STRING:
        {
            return @"assign";
            break;
        }
            
        default:
            break;
    }
}


@end
