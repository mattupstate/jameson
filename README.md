# Jameson

Jameson is an ActionScript 3 JSON document object mapper. It is partly inspired by [Jackson Java JSON Process project](http://jackson.codehaus.org/). 

One of the annoying things of most JSON to AS3 object mappings, and other types of mappers is that some sort of field is added to the JSON document to denote the object type. It's not so often that you have the luxury of being able to do this, especially if you're consuming a third party API. Jameson is your way around that. 

Bear in mind that this project is essentially a proof of concept and is considered experimental. That said, I am up for hearing anyone's ideas or criticisms regarding the project. 

### Getting Started

JSON decoding in ActionScript is currently possible using one of two APIs:

* [com.adobe.serialization.json.JSON](https://github.com/mikechambers/as3corelib)
* [Flash Player 10.3 Native JSON API](http://blog.infrared5.com/2011/07/working-with-native-json-in-flash-player-11/)

Jameson takes into account that not everyone can use the latest and greatest 10.3 player APIs and can be configured to use either via the common interface `IJsonConverter`. Jameson ships with the default implementation `AdobeCoreLibJsonConverter`. Just include the as3corelib in your project and you should be good to go.

Before you can start mapping JSON to ActionScript objects you'll need an implementation of `IObjectMapper` interface. This is achieved by creating an instance of `net.nobien.jameson.ObjectMapper` and providing it with an instance of an  `IJsonConverter` implementation of your choice. For example:

    import net.nobien.jameson.AdobeCoreLibJsonConverter;
    import net.nobien.jameson.IObjectMapper;
    import net.nobien.jameson.ObjectMapper;
    
	var objectMapper:IObjectMapper = new ObjectMapper(new AdobeCoreLibJsonConverter());

You're now ready to start mapping and reading objects!

### Property Mapping

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
    
Map the object using the `readObject()` method of the object mapper:
    
    objectMapper.registerMixin(SimpleType, SimpleTypeMixin);
    var st:SimpleType = om.readObject(SimpleType, "{...json from above...}") as SimpleType;
    
Presto! It even can do more complex types or mapping through the constructor. Refer to the unit tests for an example of that.

### Development

To compile the swc or run the unit tests, create a file named user.properties and define the path to the Flex SDK and a few other properties. For example:

    FLEX_HOME = /Users/Matt/SDK/Flex/4.1
    is.unix = true # false if your on windows
    browser.exe = /path/to/browser/executable

Run unit tests:

    ant test

Build SWC:

    ant build

