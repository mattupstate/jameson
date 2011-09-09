package net.nobien.jameson.support {
    
    public class SimpleTypeMixin {
        
        [JsonProperty("id")]
        public var id:int;
        
        [JsonProperty("name")]
        public var name:String;
        
        [JsonProperty("isSomething")]
        public var isSomething:Boolean;
        
    }
    
}