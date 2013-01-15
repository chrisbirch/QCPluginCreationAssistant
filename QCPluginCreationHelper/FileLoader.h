//
//  FileLoader.h
//  QCPluginCreationHelper
//
//  Created by chris on 13/01/2013.
//  Copyright (c) 2013 Chris Birch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileLoader : NSObject

@property(nonatomic,strong) NSArray* properties;


@property(readonly) NSString* generatedDefines;
@property(readonly) NSString* generatedProperties;
@property(readonly) NSString* generatedSynthesizes;
@property(readonly) NSString* generatedPortAttributeDescriptions;
@property(readonly) NSString* generatedValueChangedCode;

-(void)generateCodeToFile:(NSString*)filename fromPListFile: (NSString*)plistFilename;


@end
