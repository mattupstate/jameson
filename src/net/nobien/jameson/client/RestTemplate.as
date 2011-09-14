package net.nobien.jameson.client {
    
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import net.nobien.jameson.mapping.IObjectMapper;
    
    /**
     * Dispatched when a loading operation has completed.
     * @eventType flash.events.Event
     */
    [Event(name="complete", type="flash.events.Event")]
    
    /**
     * Dispatched when a mapping operation has experienced an error.
     * @eventType flash.events.ErrorEvent
     */
    [Event(name="error", type="flash.events.ErrorEvent")]
    
    /**
     * Dispatched when a loading operation has experienced an IO error.
     * @eventType flash.events.IOErrorEvent
     */
    [Event(name="ioError", type="flash.events.IOErrorEvent")]
    
    /**
     * Dispatched when a loading operation has experienced a security error.
     * @eventType flash.events.SecurityErrorEvent
     */
    [Event(name="securityError", type="flash.events.SecurityErrorEvent")]
    
    public class RestTemplate extends EventDispatcher {
        
        public var loaderFactory:ILoaderFactory = new DefaultLoaderFactory();
        public var objectMapper:IObjectMapper;
        
        private var loader:URLLoader;
        private var responseType:Class;
        
        private var _data:*;
        
        public function RestTemplate() {
            
        }
        
        protected function onLoadComplete(event:Event):void {
            killEventListeners();
            try {
                var data:* = URLLoader(event.target).data;
                _data = (objectMapper) 
                    ? objectMapper.readObject(responseType, data) 
                    : responseType(data);
                dispatchEvent(event.clone());
            } catch(e:Error) {
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, e.getStackTrace()))
            }
        }
        
        protected function onLoadError(event:ErrorEvent):void {
            killEventListeners();
            dispatchEvent(event.clone());
        }
        
        protected function killEventListeners():void {
            try {
                loader.removeEventListener(Event.COMPLETE, onLoadComplete);
                loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
                loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
            } catch(e:Error) { }
        }
        
        protected function createLoader(request:URLRequest, clazz:Class):void {
            _data = null;
            responseType = clazz;
            
            try { 
                killEventListeners();
                loader.close();
            } catch(e:Error) { }
            
            loader = loaderFactory.getLoader(request);
            loader.addEventListener(Event.COMPLETE, onLoadComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
        }
        
        protected function createRequest(url:String, method:String, params:Object):URLRequest {
            var request:URLRequest = new URLRequest(url);
            request.method = method;
            var vars:URLVariables = new URLVariables();
            for(var key:String in params) {
                vars[key] = params[key];
            }
            request.data = params;
            return request;
        }
        
        public function getForObject(url:String, clazz:Class):void {
            createLoader(createRequest(url, URLRequestMethod.GET, {}), clazz);
        }
        
        public function postForObject(url:String, params:Object, clazz:Class):void {
            createLoader(createRequest(url, URLRequestMethod.POST, params), clazz);
        }
        
        public function get data():* {
            return _data;
        }
        
    }
    
}