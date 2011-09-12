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
    
    import net.nobien.jameson.IObjectMapper;
    
    import org.flexunit.runner.IRequest;
    
    public class RestTemplate extends EventDispatcher {
        
        public var loaderFactory:ILoaderFactory = new DefaultLoaderFactory();
        public var objectMapper:IObjectMapper;
        
        private var _data:*;
        
        public function RestTemplate() {
            
        }
        
        protected function initEventListeners(loader:URLLoader, clazz:Class):URLLoader {
            var self:RestTemplate = this;
            loader.addEventListener(Event.COMPLETE, 
                function(event:Event):void {
                    try {
                        var data:* = URLLoader(event.target).data;
                        self._data = (objectMapper) 
                            ? objectMapper.readObject(clazz, data) 
                            : clazz(data);
                        self.dispatchEvent(event.clone());
                    } catch(e:Error) {
                        self.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, e.message))
                    }
                }
            );
            loader.addEventListener(IOErrorEvent.IO_ERROR,
                function(event:IOErrorEvent):void {
                    self.dispatchEvent(event.clone());
                }
            );
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
                function(event:IOErrorEvent):void {
                    self.dispatchEvent(event.clone());
                }
            );
            return loader;
        }
        
        protected function createLoader(request:URLRequest, clazz:Class):URLLoader {
            _data = null;
            return initEventListeners(loaderFactory.getLoader(request), clazz);
        }
        
        protected function createRequest(url:String, method:String, params:Object = null):URLRequest {
            var request:URLRequest = new URLRequest(url);
            request.method = method;
            if(params != null) {
                var vars:URLVariables = new URLVariables();
                for(var key:String in params) {
                    vars[key] = params[key];
                }
                request.data = params;
            }
            return request;
        }
        
        public function getForObject(url:String, clazz:Class):URLLoader {
            return createLoader(
                createRequest(url, URLRequestMethod.GET), clazz 
            );
        }
        
        public function postForObject(url:String, params:Object, clazz:Class):URLLoader {
            return createLoader(
                createRequest(url, URLRequestMethod.POST, params), clazz
            );
        }
        
        public function get data():* {
            return _data;
        }
    }
    
}