package net.nobien.jameson {
    
    public interface IObjectMapper {
        
        /**
        * Convert a JSON formatted string or decoded AS3 Object to the specified class.
        * @param input  JSON formatted string
        * @param clazz  Class type
        */
        function readObject(clazz:Class, json:Object):Object;
        
        /**
        * Convert a JSON formatted list/array to the specified class type.
        * @param input  JSON formatted string
        * @param clazz  Class type
        */
        function readList(clazz:Class, json:String):Vector.<Object>;
    }
    
}