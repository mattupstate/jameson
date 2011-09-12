package net.nobien.jameson.client {
    
    import flash.events.Event;
    
    import net.nobien.jameson.AdobeCoreLibJsonConverter;
    import net.nobien.jameson.ObjectMapper;
    import net.nobien.jameson.client.support.SimpleType;
    import net.nobien.jameson.client.support.SimpleTypeMixin;
    import net.nobien.jameson.client.test.MockLoaderFactory;
    
    import org.flexunit.Assert;
    import org.flexunit.async.Async;
    
    public class RestTemplateTests {
        
        private var restTemplate:RestTemplate;
        
        [Before]
        public function before():void {
            restTemplate = new RestTemplate();
        }
        
        [Test(async, description="Test without object mapping")]
        public function test_without_object_mapper():void {
            restTemplate.loaderFactory = new MockLoaderFactory("Hello World!");
            restTemplate.addEventListener(Event.COMPLETE,
                Async.asyncHandler(this, handlTextComplete, 500, null, handleTimeout), false, 0, true);
            restTemplate.getForObject("/something", String);
        }
        
        protected function handlTextComplete(event:Event, data:Object):void {
            Assert.assertTrue(restTemplate.data is String);
            Assert.assertEquals("Hello World!", restTemplate.data);
        }
        
        [Test(async, description="Test json object mapping")]
        public function test_with_json_object_mapper():void {
            restTemplate.objectMapper = new ObjectMapper(new AdobeCoreLibJsonConverter());
            restTemplate.objectMapper.registerMixin(SimpleType, SimpleTypeMixin);
            restTemplate.loaderFactory = new MockLoaderFactory('{ "id": 1, "name": "Joe" }');
            restTemplate.addEventListener(Event.COMPLETE,
                Async.asyncHandler(this, handleJsonComplete, 500, null, handleTimeout), false, 0, true);
            restTemplate.getForObject("/something", SimpleType);
        }
        
        protected function handleJsonComplete(event:Event, data:Object):void {
            Assert.assertTrue(restTemplate.data is SimpleType);
            Assert.assertEquals(1, restTemplate.data.id);
            Assert.assertEquals("Joe", restTemplate.data.name);
        }
        
        protected function handleTimeout(data:Object):void {
            Assert.fail( "Timeout reached before event");
        }
    }
    
}