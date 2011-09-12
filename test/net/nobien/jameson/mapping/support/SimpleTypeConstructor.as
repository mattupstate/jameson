package net.nobien.jameson.mapping.support {
    
    public class SimpleTypeConstructor {
        
        private var _id:int;
        private var _name:String;
        
        public function SimpleTypeConstructor(id:int, name:String) {
            _id = id;
            _name = name;
        }
        
        public function get id():int {
            return _id;
        }
        
        public function get name():String {
            return _name;
        }
        
    }
    
}