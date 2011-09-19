package net.nobien.jameson.client {
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    public class DefaultLoaderFactory implements ILoaderFactory {
        
        public function DefaultLoaderFactory() {
            
        }
        
        public function getLoader(request:URLRequest = null):URLLoader {
            return new URLLoader(request);
        }
        
    }
    
}