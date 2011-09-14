# Jameson

Jameson is an ActionScript 3 JSON document object mapper. It is partly inspired by the [Jackson Java JSON Processer project](http://jackson.codehaus.org/). 

One of the annoying things of most JSON to AS3 object mappings, and other types of mappers is that some sort of field is added to the JSON document to denote the object type. It's not so often that you have the luxury of being able to do this, especially if you're consuming a third party API. Jameson is your way around that. 

Bear in mind that this project is essentially a proof of concept and is considered experimental. That said, I am up for hearing anyone's ideas or criticisms regarding the project. 

### Getting Started

JSON decoding in ActionScript is currently possible using one of two APIs:

* [com.adobe.serialization.json.JSON](https://github.com/mikechambers/as3corelib)
* [Flash Player 10.3 Native JSON API](http://blog.infrared5.com/2011/07/working-with-native-json-in-flash-player-11/)

Jameson takes into account that not everyone can use the latest and greatest 10.3 player APIs and can be configured to use either via the common interface `IJsonConverter`. Jameson ships with the default implementation `AdobeCoreLibJsonConverter`. Just include the as3corelib in your project and you should be good to go.

Before you can start mapping JSON to ActionScript objects you'll need an implementation of `IObjectMapper` interface. This is achieved by creating an instance of `net.nobien.jameson.ObjectMapper` and providing it with an instance of an  `IJsonConverter` implementation of your choice. For example:

    import net.nobien.jameson.mapping.AdobeCoreLibJsonConverter;
    import net.nobien.jameson.mapping.IObjectMapper;
    import net.nobien.jameson.mapping.ObjectMapper;
    
    var objectMapper:IObjectMapper = new ObjectMapper(new AdobeCoreLibJsonConverter());

You're now ready to start mapping and reading objects!

## Object Mapping

As of now Jameson maps objects using what are called 'mixins'. Other methods may well be implemented later. This concept is directly taken from the aforementioned Jackson project. Mixins are registered with the object mapper and are used to parse a JSON document using AS3 metadata annotations.

Mixins are nearly the same as your value objects but they use meta data to denote which fields from the JSON document should be mapped to the constructor of your class or fields on your value objects.

### Field/Property Mapping

Take, for example, the following JSON document:

    {
        "id": 123, 
        "name": "Simple", 
        "cool":true
    }

If you're anything like me, you'll want a nice representation of this document in ActionScript instead of a plain old object. The following is what I might want this class/object to look like:

    package {
        
        public class SimpleType {
        
            public var id:int;
            public var name:String
            public var isCool:Boolean;
        
            public function SimpleType() {
            }
        }
    }

The objects are nearly the same in concept, aside from the field names cool and `isCool`. These are different to simply illustrate that field names do not have to exactly match when using Jameson. The next step is to create a mixin to tell Jameson which fields in the JSON document map to the ActionScript object's fields. The mixin would look like so:

    package {
    
        public class SimpleTypeMixin {
        
            [JsonProperty("id")]
            public var id:String;
        
            [JsonProperty("name")]
            public var name:String;
        
            [JsonProperty("cool")]
            public var isCool:Boolean;
        
        }
    
    }
    
Notice that the mixin's ActionScript fields are identical to that of the "plain" ActionScript object and each field is annotated with some meta data to denote which field from the JSON document should be read for that field's value.

The only thing left to do before converting JSON to our old fashioned ActionScript objects is to register the mixin with the object mapper and read the object using the `readObject()` method:
    
    objectMapper.registerMixin(SimpleType, SimpleTypeMixin);
    var st:SimpleType = objectMapper.readObject(SimpleType, "{...json from above...}") as SimpleType;
    
Presto! You've got a nice "plain" ActionScript to pass around your application. 

### Constructor Mapping

Jameson also lets you map values from a JSON document into a "plain" ActionScript object's constructor. Let's take the same JSON document from above:

    {
        "id": 123, 
        "name": "Simple", 
        "cool":true
    }

Now, lets say you're "plain" ActionScript object takes constructor arguments to protect the instance's values after instantiation:

    package {
        
        public class SimpleType {
        
            private var _id:int;
            private var _name:String
            private var _isCool:Boolean;
        
            public function SimpleType(id:int, name:String, isCool:Boolean) {
                _id = id;
                _name = name;
                _isCool = isCool;
            }
            
            public function get id():int { return _id; }
            public function get name():String { return _name; }
            public function get isCool():Boolean { return _isCool; }
            
        }
    }
    
The mixin for this class should look like the following:

    package {
    
        [JsonConstructor("id", "name", "cool")]
        public class SimpleTypeMixin {
        
        }
        
    }
    
Now just register the mixin, as before, and you're good to go!

### Object Lists

In some cases you're going to want to register a mixin for a particular class, but you're JSON documents will contain arrays of these documents. Luckily Jameson lets you map lists of classes using ActionScript's Vector class. Jameson uses Vectors exclusively because its possible to infer the type of object the list contains. 

Now lets say you registered the `SimpleTypeMixin` (either flavor) above and you're JSON document contained a list:

    [{
        "id": 123, 
        "name": "Simple", 
        "cool": true
    },{
        "id": 124, 
        "name": "More Simple", 
        "cool": true
    },{
        "id": 125, 
        "name": "Even More Simple", 
        "cool": false
    }]
    
To read the list, do the following:

    objectMapper.readObject(Vector.<SimpleType> as Class, jsonString) as Vector.<SimpleType>
      
Just remember to add `as Class` after the vector reference, otherwise the Flash Player gets cranky.

### Development

To compile the swc or run the unit tests, create a file named user.properties and define the path to the Flex SDK and a few other properties. For example:

    FLEX_HOME = /Users/Matt/SDK/Flex/4.1
    is.unix = true # false if your on windows
    browser.exe = /path/to/browser/executable

Run unit tests:

    ant test

Build SWC:

    ant build

