package net.nobien.jameson.support
{
    public class SimpleTypeWithListMixin
    {
        [JsonProperty("id")]
        public var id:int;
        
        [JsonProperty("list")]
        public var list:Vector.<SimpleType>;
        
    }
}