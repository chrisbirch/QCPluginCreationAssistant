//
//  QCProperty.h
//  QCPluginCreationHelper
//
//  Created by chris on 13/01/2013.
//  Copyright (c) 2013 Chris Birch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    PROPERTY_TYPE_BOOL,
    PROPERTY_TYPE_DOUBLE,
    PROPERTY_TYPE_UINT,
    PROPERTY_TYPE_STRING,
    PROPERTY_TYPE_DICTIONARY,
    PROPERTY_TYPE_ARRAY,
    
    PROPERTY_TYPE_CGCOLORREF,
    PROPERTY_TYPE_IMAGESOURCE,
    PROPERTY_TYPE_IMAGEPROVIDER
    
    
    
} PROPERTY_TYPE;

@interface QCProperty : NSObject

/**
 * If set to YES then the code for the valuechanged section of this  property will be generated
 * as being if, and not else if.
 */
@property(nonatomic,assign) BOOL isFirstProperty;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* friendlyName;

/**
 * The property or field to set when input value changes. This is ignored if valueChangedBody != nil
 */
@property(nonatomic,strong) NSString* valueChangedTarget;

/**
 * Overrides the default behaviour of the value changed body and just blindy inserts the text found here
 * into the value changed body.
 */
@property(nonatomic,strong) NSString* valueChangedBody;


@property(nonatomic,strong) NSString* comment;
@property(nonatomic,assign) PROPERTY_TYPE type;
/**
 * YES if property is an input, NO if property is an output
 */
@property(nonatomic,assign) BOOL isInputProperty;

//seem to be able to get away with passing number types as strings
@property(nonatomic,strong) NSString* defaultValue;


@property(nonatomic,readonly) NSString* generatedCodeDefine;
@property(nonatomic,readonly) NSString* generatedCodePropertyDefinition;
@property(nonatomic,readonly) NSString* generatedCodeDynamic;
@property(nonatomic,readonly) NSString* generatedCodePortAttributeDescription;
@property(nonatomic,readonly) NSString* generatedCodeValueChanged;




@end
