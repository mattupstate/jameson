package net.nobien.jameson.mapping {
    
    public interface IObjectMapper {
        
        /**
        * Convert a JSON formatted string or decoded AS3 Object to the specified class.
        * @param input  JSON formatted string
        * @param clazz  Class type
        */
        function readObject(clazz:Class, json:Object):*;
        
        /**
        * Convert a JSON formatted list/array to the specified class type.
        * @param input  JSON formatted string
        * @param clazz  Class type
        */
        function readList(clazz:Class, json:Object):Array;
        
        /**
        * Register a mixin to use when parsing JSON
        * @param clazz  Class to map to
        * @param mixin  Mixin class for parsing
        */
        function registerMixin(clazz:Class, mixin:Class):void;
    }
    
}