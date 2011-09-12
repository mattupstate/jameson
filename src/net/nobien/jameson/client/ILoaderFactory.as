package net.nobien.jameson.client {
    
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    public interface ILoaderFactory {
        
        function getLoader(request:URLRequest = null):URLLoader;
        
    }
    
}