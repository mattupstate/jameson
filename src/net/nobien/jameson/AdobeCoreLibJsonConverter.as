package net.nobien.jameson {
    
    import com.adobe.serialization.json.JSON;
    
    public class AdobeCoreLibJsonConverter implements IJsonConverter {
        
        public function AdobeCoreLibJsonConverter() {
        }
        
        public function parse(json:String):Object {
            return JSON.decode(json);
        }
        
        public function stringify(obj:Object):String {
            return JSON.encode(obj);
        }
        
    }
    
}