package net.nobien.jameson.client {
    
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import org.flexunit.Assert;
    import org.flexunit.async.Async;
    
    import net.nobien.jameson.client.test.MockLoaderFactory;

    public class LoaderFactoryTests {
        
        [Test(async, description="Test mock url loader")]
        public function test_mock_loader_factory():void {
            var factory:MockLoaderFactory = new MockLoaderFactory("Hello", 250);
            var urlLoader:URLLoader = factory.getLoader(new URLRequest("http://www.google.com"));
            urlLoader.addEventListener(Event.COMPLETE, 
                Async.asyncHandler(this, handleLoaderComplete, 500, null, handleTimeout), false, 0, true);
        }
        
        protected function handleLoaderComplete(event:Event, data:Object):void {
            var urlLoader:URLLoader = event.target as URLLoader;
            Assert.assertEquals("Hello", urlLoader.data);
        }
        
        protected function handleTimeout(data:Object):void {
            Assert.fail( "Timeout reached before event");
        }
    }
    
}