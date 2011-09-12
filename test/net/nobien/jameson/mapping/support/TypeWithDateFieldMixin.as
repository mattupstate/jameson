package net.nobien.jameson.mapping.support {
    
    public class TypeWithDateFieldMixin {
        
        [JsonProperty("id")]
        public var id:int;
        
        [JsonProperty("created")]
        public var created:Date;
        
    }
}