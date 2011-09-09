package net.nobien.jameson.support {
    
    [JsonConstructor("id","name")]
    public class ConstructorAndFieldTypeMixin {
        
        [JsonProperty("someProperty")]
        public var someProperty:String;
        
    }
    
}