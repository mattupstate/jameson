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
        
        private function gatherConstructorValues(paramValues:XMLList, decodedObject:Object):Array {
            var params:Array = [];
            for each(var item:XML in paramValues) {
                params.push(decodedObject[item.toString()]);
            }
            return params;
        }
        
        private function constructInstance(clazz:Class, decodedObject:Object, classDesc:XML, mixinDesc:XML):* {
            var jsonConstructor:XML = mixinDesc.factory.metadata.(@name=="JsonConstructor")[0];
            if(jsonConstructor) {
                var paramAmount:int = jsonConstructor.arg.length();
                var p:Array = gatherConstructorValues(jsonConstructor.arg.@value, decodedObject);
                switch(paramAmount) {
                    case 0  : return (new clazz());
                    case 1  : return (new clazz(p[0]));
                    case 2  : return (new clazz(p[0], p[1]));
                    case 3  : return (new clazz(p[0], p[1], p[2]));
                    case 4  : return (new clazz(p[0], p[1], p[2], p[3]));
                    case 5  : return (new clazz(p[0], p[1], p[2], p[3], p[4]));
                    case 6  : return (new clazz(p[0], p[1], p[2], p[3], p[4], p[5]));
                    case 7  : return (new clazz(p[0], p[1], p[2], p[3], p[4], p[5], p[6]));
                    case 8  : return (new clazz(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]));
                    case 9  : return (new clazz(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]));
                    case 10 : return (new clazz(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]));
                }
            }
            return null;
        }
        
        private function setInstanceProperties(instance:*, decodedObject:Object, classDesc:XML, mixinDesc:XML):* {
            for each(var mixinVar:XML in mixinDesc.factory.variable) {
                var meta:XML = mixinVar.metadata.(@name=="JsonProperty")[0];
                if(meta) {
                    var instancePropName:String = mixinVar.@name;
                    var instancePropType:String = mixinVar.@type;
                    var jsonPropName:String = meta.arg.@value;
                    var jsonPropValue:* = decodedObject[jsonPropName];
                    var jsonPropType:String = getQualifiedClassName(jsonPropValue);
                    if(instancePropType.indexOf("Array") > -1) {
                        throw new Error("Jameson does not support Array fields (yet). Use Vectors to denote object type.");
                    } else if(instancePropType != jsonPropType) {
                        instance[instancePropName] = readObject(getDefinitionByName(instancePropType) as Class, jsonPropValue); 
                    } else {
                        instance[instancePropName] = decodedObject[jsonPropName];
                    }
                }
            }
            return instance;
        }
        
        public function registerMixin(clazz:Class, mixin:Class):void {
            mixins[clazz] = mixin;
        }
        
        public function readObject(clazz:Class, json:Object):* {
            var decodedObject:Object = (json is String) ? jsonConverter.parse(json as String) : json;
            var classDesc:XML = describeType(clazz);
            var classTypeStr:String = classDesc.@name;
            
            if(classTypeStr.indexOf("__AS3__.vec::Vector") == 0) {
                var vectorType:Class = getDefinitionByName(classTypeStr) as Class;
                var vectorInstanceType:Class = getDefinitionByName(classTypeStr.split("<")[1].split(">")[0]) as Class;
                return clazz(readList(vectorInstanceType, decodedObject));;
            }
            
            var mixinDesc:XML = describeType(mixins[clazz]);
            var instance:* = null;
            try {
                instance = new clazz();
            } catch(e:Error) {
                instance = constructInstance(clazz, decodedObject, classDesc, mixinDesc);
            }
            return setInstanceProperties(instance, decodedObject, classDesc, mixinDesc);;
        }
        
        public function readList(clazz:Class, json:Object):Array {
            var decodedList:Array = (json is String) ? jsonConverter.parse(json as String) as Array : json as Array;
            var list:Array = []
            for(var i:int = 0; i < decodedList.length; i++) {
                list.push(readObject(clazz, decodedList[i]));
            }
            return list;
        }
        
    }
    
}