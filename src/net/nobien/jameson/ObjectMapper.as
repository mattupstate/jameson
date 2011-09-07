package net.nobien.jameson {
    
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    public class ObjectMapper implements IObjectMapper {
        
        private var jsonConverter:IJsonConverter;
        private var mixins:Dictionary = new Dictionary();
        
        public function ObjectMapper(jsonConverter:IJsonConverter) {
            this.jsonConverter = jsonConverter;
        }
        
        public function registerMixin(clazz:Class, mixin:Class):void {
            mixins[clazz] = mixin;
        }
        
        public function readObject(clazz:Class, json:Object):Object {
            var obj:Object = (json is String) ? jsonConverter.parse(json as String) : json;
            var mixin:Class = mixins[clazz];
            var clazzDesc:XML = describeType(clazz);
            var mixinDesc:XML = describeType(mixin);
            
            var instance:* = new clazz();
            for each(var classVar:XML in clazzDesc.factory.variable) {
                var classPropertyName:String = classVar.@name;
                var mixinVar:XML = mixinDesc.factory.variable.(@name == classPropertyName)[0];
                var jsonPropertyName:String = mixinVar.metadata.(@name == "JsonProperty").arg.(@key == "").@value;
                var decodedValue:Object = obj[jsonPropertyName];
                var decodedType:String = describeType(decodedValue).@name;
                var instanceType:String = classVar.@type;
                if(decodedType != instanceType) {
                    instance[classPropertyName] = readObject(getDefinitionByName(instanceType) as Class, decodedValue); 
                } else {
                    instance[classPropertyName] = decodedValue;
                }
            }
            return instance;
        }
        
        public function readList(clazz:Class, json:String):Vector.<Object> {
            return null;
        }
        
    }
    
}