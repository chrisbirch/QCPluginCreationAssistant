QCPluginCreationAssistant
=========================

Chris Birch
14/01/2013

Command line app to automatically generate port code for Quartz Composer plugins.

Given a PList file, will generate repetitive port code for QC plugins.

See ExamplePorts.plist for information on how to structure the input property list.


The generated code is outputted to the console and also to the specified text file.

Once generated its up to the developer to copy and paste the code into appropriate sections.

Usage:

QCPluginCreationHelper <InputPList> <OutputTextFile>

The input PList should be created with the following structure:

<array>
	<dict>
		<key>Name</key>
		<string></string>
		<key>FriendlyName</key>
		<string></string>
		<key>Type</key>
		<string></string>
		<key>DefaultValue</key>
		<string></string>
		<key>Comment</key>
		<string></string>
		<key>IsInput</key>
		<true/>
		<key>ValueChangedTarget</key>
		<string></string>
		<key>ValueChangedBody</key>
		<string></string>
	</dict>
	<dict />
	<dict />
	<dict />
</array>


For each input or output port you wish to create, copy the Dict structure from above into your plist.

Explanation of the properties:

Both import and output ports:

- Name is the name of the ObjectiveC property

- FriendlyName is the name of the port as it will appear in Quartz Composer. This param is optional, if not supplied the Name is used instead.

- Type can be one of the following: int, double, string, bool

- Comment is a brief comment about what the port is (this will be outputted in the generated code). This param is optional.

- IsInput is a bool value that dictates whether or not this port is an input(true) or an output(false).


Input ports Only:

- DefaultValue is the default value used by input ports. This param is optional.

-ValueChangedTarget describes a property or field that should be set when the input port value changes. This param is optional.

-ValueChangedBody (overrides ValueChangedTarget). Describes a snippet of code that will be run when the value of an input port changes. This param is optional. NB: A #warning  directive will be created for each port that specifies this property. This is warn that potentially old code is being pasted into the project.



Example.

Input: 


<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
	<dict>
		<key>Name</key>
		<string></string>
		<key>FriendlyName</key>
		<string></string>
		<key>Type</key>
		<string></string>
		<key>DefaultValue</key>
		<string></string>
		<key>Comment</key>
		<string>This dict is ignored as its Name is empty</string>
		<key>IsInput</key>
		<true/>
		<key>ValueChangedTarget</key>
		<string></string>
		<key>ValueChangedBody</key>
		<string></string>
	</dict>
	<dict>
		<key>Name</key>
		<string>PortA</string>
		<key>FriendlyName</key>
		<string>Port A</string>
		<key>Type</key>
		<string>bool</string>
		<key>DefaultValue</key>
		<string>YES</string>
		<key>Comment</key>
		<string>An example Input port using ValueChangedTarget</string>
		<key>IsInput</key>
		<true/>
		<key>ValueChangedTarget</key>
		<string>myInstance.myProperty</string>
		<key>ValueChangedBody</key>
		<string></string>
	</dict>
	<dict>
		<key>Name</key>
		<string>PortB</string>
		<key>FriendlyName</key>
		<string>Port B</string>
		<key>Type</key>
		<string>bool</string>
		<key>DefaultValue</key>
		<string>YES</string>
		<key>Comment</key>
		<string>An example Input port using ValueChangedBody</string>
		<key>IsInput</key>
		<true/>
		<key>ValueChangedBody</key>
		<string>myInstance.myProperty = inputPortB; foo();</string>
	</dict>
	<dict>
		<key>Name</key>
		<string>PortC</string>
		<key>FriendlyName</key>
		<string>Port C</string>
		<key>Type</key>
		<string>double</string>
		<key>Comment</key>
		<string>An example output port</string>
		<key>IsInput</key>
		<false/>
	</dict>
</array>
</plist>



Output:


#######################################################################
#
# Auto generated code created using QC Plugin Assistant by Chris Birch
#
#######################################################################




###################################
# Place in the plugin .h file
###################################


//Port Defines

//An example Input port using ValueChangedTarget
#define INPUT_PORTA @"inputPortA"
//An example Input port using ValueChangedBody
#define INPUT_PORTB @"inputPortB"
//An example output port
#define OUTPUT_PORTC @"outputPortC"


//Port Properties

@property (assign) BOOL inputPortA;
@property (assign) BOOL inputPortB;
@property (assign) double outputPortC;



###################################
# Place in the plugin .m file
###################################


//Port Synthesizes

@dynamic inputPortA;
@dynamic inputPortB;
@dynamic outputPortC;

//Port Attributes

//An example Input port using ValueChangedTarget
if([key isEqualToString:INPUT_PORTA])
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Port A", QCPortAttributeNameKey,
            [NSNumber numberWithBool:YES], QCPortAttributeDefaultValueKey,
            nil];
//An example Input port using ValueChangedBody
else if([key isEqualToString:INPUT_PORTB])
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Port B", QCPortAttributeNameKey,
            [NSNumber numberWithBool:YES], QCPortAttributeDefaultValueKey,
            nil];
//An example output port
else if([key isEqualToString:OUTPUT_PORTC])
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Port C", QCPortAttributeNameKey,
            nil];

//Port Value Changed code

//An example Input port using ValueChangedTarget
if ([self didValueForInputKeyChange:INPUT_PORTA])
{
#warning This code could be out of date as it was read in from Ports PList

}
//An example Input port using ValueChangedBody
if ([self didValueForInputKeyChange:INPUT_PORTB])
{
#warning This code could be out of date as it was read in from Ports PList
myInstance.myProperty = inputPortB; foo();
}



