package net.nobien.jameson {
    
    public interface IJsonConverter {
        /**
        * Convert a JSON string into a native ActionScript object.
        * @param json   JSON formatted string
        * @return   Generic ActionScript object
        */
        function parse(json:String):*;
        
        /**
        * Convert an object to JSON string notation.
        * @param value  ActionScript object to conver
        * @return   JSON formatted string
        */
        function stringify(value:*):String;
    }
}