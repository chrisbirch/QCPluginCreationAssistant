//
//  main.m
//  QCPluginCreationHelper
//
//  Created by chris on 13/01/2013.
//  Copyright (c) 2013 Chris Birch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileLoader.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool
    {
        NSString* usage = @"\n\nPlease pass two params\nParam 1 is the filename of the plist.\nParam 2 is the filename of the output file.\n\nSee ExamplePorts.plist in the xcode project for an example input plist\n\n\n";
        
        // insert code here...
        
        if (argc < 3)
        {
            NSLog(@"\n\nInvalid filenames.%@",usage);
        }
        else if (argc > 3)
        {
            NSLog(@"\n\nInvalid number of params.%@",usage);
        }
        else
        {
            //3 arguments
            NSString *inFile = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
            NSString *outFile = [NSString stringWithCString:argv[2] encoding:NSUTF8StringEncoding];
         
            NSLog(@"Input PList: %@\nOutput File:%@\n\n",inFile,outFile);
            
            FileLoader* loader = [[FileLoader alloc] init];
          
            [loader generateCodeToFile:outFile fromPListFile:inFile];
            
            NSLog(@"\n\nFinished");

        }
        
        
    }
    return 0;
}




