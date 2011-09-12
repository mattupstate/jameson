package net.nobien.jameson {
    
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    
    import net.nobien.jameson.support.ComplexType;
    import net.nobien.jameson.support.ComplexTypeMixin;
    import net.nobien.jameson.support.ConstructorAndFieldType;
    import net.nobien.jameson.support.ConstructorAndFieldTypeMixin;
    import net.nobien.jameson.support.SimpleType;
    import net.nobien.jameson.support.SimpleTypeConstructor;
    import net.nobien.jameson.support.SimpleTypeConstructorMixin;
    import net.nobien.jameson.support.SimpleTypeMixin;
    import net.nobien.jameson.support.SimpleTypeWithList;
    import net.nobien.jameson.support.SimpleTypeWithListMixin;
    
    import org.flexunit.Assert;

    public class ObjectMapperTests {
        
        private var om:ObjectMapper;
        
        [Before]
        public function before():void {
            om = new ObjectMapper(new AdobeCoreLibJsonConverter());
            om.registerMixin(SimpleType, SimpleTypeMixin);
            om.registerMixin(ComplexType, ComplexTypeMixin);
            om.registerMixin(SimpleTypeConstructor, SimpleTypeConstructorMixin);
            om.registerMixin(ConstructorAndFieldType, ConstructorAndFieldTypeMixin);
            om.registerMixin(SimpleTypeWithList, SimpleTypeWithListMixin);
        }
        
        [Test]
        public function test_map_simple_type():void {
            var json:String = '{"id":123, "name": "Simple", "isSomething":true}';
            var st:SimpleType = om.readObject(SimpleType, json) as SimpleType;
            Assert.assertEquals(123, st.id);
            Assert.assertEquals("Simple", st.name);
            Assert.assertEquals(true, st.isSomething);
        }
        
        [Test]
        public function test_map_complex_type():void {
            var json:String = '{"id":321, "name": "Complex", "simpleType":{"id":123, "name": "Matt", "isSomething":true} }';
            var ct:ComplexType = om.readObject(ComplexType, json) as ComplexType;
            Assert.assertEquals(321, ct.id);
            Assert.assertEquals("Complex", ct.name);
            Assert.assertNotNull(ct.simpleType);
            Assert.assertTrue(ct.simpleType is SimpleType)
        }
        
        [Test]
        public function test_constructor_mixin():void {
            var json:String = '{ "id": 123, "name": "Hello" }';
            var stc:SimpleTypeConstructor = om.readObject(SimpleTypeConstructor, json) as SimpleTypeConstructor;
            Assert.assertEquals(123, stc.id);
            Assert.assertEquals("Hello", stc.name);
        }
        
        [Test]
        public function test_constructor_and_field_type_mixin():void {
            var json:String = '{ "id": 123, "name": "Hello", "someProperty": "World" }';
            var instance:ConstructorAndFieldType = om.readObject(ConstructorAndFieldType, json) as ConstructorAndFieldType;
            Assert.assertEquals(123, instance.id);
            Assert.assertEquals("Hello", instance.name);
            Assert.assertEquals("World", instance.someProperty);
        }
        
        [Test]
        public function test_read_list():void {
            var json:String = '[{"id":122, "name": "Simple", "isSomething":true}, {"id":123, "name": "Simple", "isSomething":true}]';
            var list:Array = om.readList(SimpleType, json);
            Assert.assertEquals(2, list.length);
            Assert.assertTrue(list[0] is SimpleType);
            Assert.assertTrue(list[1] is SimpleType);
        }
        
        [Test]
        public function test_simple_type_with_list_field():void {
            om.readObject(SimpleTypeWithList, '{ "id": 1, "list": [{"id":122, "name": "Simple", "isSomething":true}, {"id":123, "name": "Simple", "isSomething":true}] }');
        }
    }
    
}