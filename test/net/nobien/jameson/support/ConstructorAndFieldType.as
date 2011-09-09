package net.nobien.jameson.support
{
    public class ConstructorAndFieldType {
        
        private var _id:int;
        private var _name:String;
        private var _someProperty:String;
        
        public function ConstructorAndFieldType(id:int, name:String) {
            _id = id;
            _name = name;
            _someProperty = "default";
        }
        
        public function get id():int {
            return _id;
        }
        
        public function get name():String {
            return _name;
        }
        
        public function get someProperty():String {
            return _someProperty;
        }
        
        public function set someProperty(value:String):void {
            _someProperty = value;
        }
    }
}