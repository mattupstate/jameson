package net.nobien.jameson.support {
    
    public class SimpleTypeMixin {
        
        [JsonProperty("id")]
        public var id:String;
        
        [JsonProperty("name")]
        public var name:String;
        
        [JsonProperty("isSomething")]
        public var isSomething:Boolean;
        
    }
    
}