package net.nobien.jameson.mapping.support {
    
    [JsonConstructor("id","name")]
    public class ConstructorAndFieldTypeMixin {
        
        [JsonProperty("someProperty")]
        public var someProperty:String;
        
    }
    
}