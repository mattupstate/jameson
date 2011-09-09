package net.nobien.jameson.support {
    
    public class ComplexTypeMixin {
        
        [JsonProperty("id")]
        public var id:int;
        
        [JsonProperty("name")]
        public var name:String;
        
        [JsonProperty("simpleType")]
        public var simpleType:SimpleType;
        
    }
    
}