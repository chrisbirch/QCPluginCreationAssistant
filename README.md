QCPluginCreationAssistant
=========================

Chris Birch
14/01/2013

Command line app to automatically generate port code for Quartz Composer plugins.

Given a PList file, will generate repetitive port code for QC plugins.

See <a href="QCPluginCreationAssistant/tree/master/QCPluginCreationHelper/ExamplePorts.plist">ExamplePorts.plist</a> for information on how to structure the input property list.


The generated code is outputted to the console and also to the specified text file.

Once generated its up to the developer to copy and paste the code into appropriate sections.

Generates code for:
-------------------
<pre>
*Objective C properties and @dynamic declarations
*+(NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
*- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
</pre>

Usage:

<pre>
QCPluginCreationHelper InputPList OutputTextFile
</pre>

The input PList should be created with the following structure:

<pre>
&lt;array&gt;
	&lt;dict&gt;
		&lt;key&gt;Name&lt;/key&gt;
		&lt;string&gt;&lt;/string&gt;
		&lt;key&gt;FriendlyName&lt;/key&gt;
		&lt;string&gt;&lt;/string&gt;
		&lt;key&gt;Type&lt;/key&gt;
		&lt;string&gt;&lt;/string&gt;
		&lt;key&gt;DefaultValue&lt;/key&gt;
		&lt;string&gt;&lt;/string&gt;
		&lt;key&gt;Comment&lt;/key&gt;
		&lt;string&gt;&lt;/string&gt;
		&lt;key&gt;IsInput&lt;/key&gt;
		&lt;true/&gt;
		&lt;key&gt;ValueChangedTarget&lt;/key&gt;
		&lt;string&gt;&lt;/string&gt;
		&lt;key&gt;ValueChangedBody&lt;/key&gt;
		&lt;string&gt;&lt;/string&gt;
	&lt;/dict&gt;
	&lt;dict /&gt;
	&lt;dict /&gt;
	&lt;dict /&gt;
&lt;/array&gt;
</pre>

For each input or output port you wish to create, copy the Dict structure from above into your plist.

Explanation of the properties:

Both input and output ports:
------------------------------

<dl>
<dt>Name</dt>
<dd>The name of the ObjectiveC property</dd>


<dt>FriendlyName </dt>
<dd>the name of the port as it will appear in Quartz Composer. This param is optional, if not supplied the Name is used instead.</dd>

<dt>Type</dt>
<dd>can be one of the following: int, double, string, bool, array, dictionary</dd>

<dt>Comment</dt>
<dd>a brief comment about what the port is (this will be outputted in the generated code). This param is optional.</dd>


<dt>IsInput</dt>
<dd> a bool value that dictates whether or not this port is an input(true) or an output(false).</dd>


</dl>


Input ports Only:
-----------------

<dl>

<dt>DefaultValue</dt>
<dd>The default value used by input ports. This param is optional.</dd>

<dt>ValueChangedTarget</dt>
<dd>describes a property or field that should be set when the input port value changes. This param is optional</dd>

<dt>ValueChangedBody</dt>
<dd>(overrides ValueChangedTarget). Describes a snippet of code that will be run when the value of an input port changes. This param is optional. NB: A #warning  directive will be created for each port that specifies this property. This is warn that potentially old code is being pasted into the project</dd>

</dl>


Example.
---------

Here is an example PList file and the generated output created by running the console app.

Input 
--------

See <a href="QCPluginCreationAssistant/tree/master/QCPluginCreationHelper/ExamplePorts.plist">An Example Plist file</a>

Output
--------

<pre>
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
    myInstance.myProperty = self.inputPortA;
}
//An example Input port using ValueChangedBody
if ([self didValueForInputKeyChange:INPUT_PORTB])
{
#warning This code could be out of date as it was read in from Ports PList
myInstance.myProperty = inputPortB; foo();
}


</pre>

