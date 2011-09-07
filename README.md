# Jameson

Jameson is an ActionScript 3 JSON document object mapper. It is partly inspired by [Jackson Java JSON Process project](http://jackson.codehaus.org/). 

This project is very much in development and is wide open for contributions and suggestions for additional functionality. 

### Overview

JSON decoding in ActionScript is currently possible using one of two APIs:

* [com.adobe.serialization.json.JSON](https://github.com/mikechambers/as3corelib)
* [Flash Player 10.3 Native JSON API](http://blog.infrared5.com/2011/07/working-with-native-json-in-flash-player-11/)

Jameson takes into account that not everyone can use the latest and greatest 10.3 player APIs and can be configured to use either via the common interface `IJsonConverter`. Jameson ships with the default implementation `AdobeCoreLibJsonConverter`. Just include the as3corelib in your project and you should be good to go.

As of now Jameson maps objects using what are called 'mixins'. Other methods may well be implemented later. This concept is directly taken from the aforementioned Jackson project. Mixins are registered with the object mapper and are used to parse a JSON document using AS3 metadata annotations.

Lets take, for example, the following ActionScript class:

    package {

        public class SimpleType {
            public var id:int;
            public var name:String
            public var isSomething:Boolean;
        
            public function SimpleType() {
            
    	    }
    	    
        }
    }

And the following JSON document:

    {
        "id": 123, 
        "name": "Simple", 
        "isSomething":true
    }

To easily convert/map the JSON document to the ActionScript class, create a mixin that looks like the following:

    package {
    
        public class SimpleTypeMixin {
        
            [JsonProperty("id")]
            public var id:String;
        
            [JsonProperty("name")]
            public var name:String;
        
            [JsonProperty("isSomething")]
            public var isSomething:Boolean;
        
        }
    
    }
    
Then create an object mapper instance with the `IJsonConverter` implementation of your choice and register the mixin:

	om = new ObjectMapper(new AdobeCoreLibJsonConverter());
    om.registerMixin(SimpleType, SimpleTypeMixin);
    
Map the object using the `readObject()` method of the object mapper:
    
    var st:SimpleType = om.readObject(SimpleType, "{...json from above...}") as SimpleType;
    
Presto! It even can do more complex types. Refer to the unit tests for an example of that.

### Development

To compile the swc or run the unit tests, create a file named user.properties and define the path to the Flex SDK and a few other properties. For example:

    FLEX_HOME = /Users/Matt/SDK/Flex/4.1
    is.unix = true # false if your on windows
    browser.exe = /path/to/browser/executable

Run unit tests:

    ant test

Build SWC:

    ant build

