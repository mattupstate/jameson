package net.nobien.jameson.client.test {
    
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import net.nobien.jameson.client.ILoaderFactory;
    
    public class MockLoaderFactory implements ILoaderFactory {
        
        private var respondWith:*;
        private var delay:int;
        
        public function MockLoaderFactory(respondWith:*, delay:int = 250) {
            this.respondWith = respondWith;
            this.delay = delay;
        }
        
        public function getLoader(request:URLRequest = null):URLLoader {
            return new MockUrlLoader(request, respondWith, delay);
        }
        
    }
    
}