package net.nobien.jameson.mapping {
    
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    
    import net.nobien.jameson.mapping.support.ComplexType;
    import net.nobien.jameson.mapping.support.ComplexTypeMixin;
    import net.nobien.jameson.mapping.support.ConstructorAndFieldType;
    import net.nobien.jameson.mapping.support.ConstructorAndFieldTypeMixin;
    import net.nobien.jameson.mapping.support.SimpleType;
    import net.nobien.jameson.mapping.support.SimpleTypeConstructor;
    import net.nobien.jameson.mapping.support.SimpleTypeConstructorMixin;
    import net.nobien.jameson.mapping.support.SimpleTypeMixin;
    import net.nobien.jameson.mapping.support.SimpleTypeWithList;
    import net.nobien.jameson.mapping.support.SimpleTypeWithListMixin;
    import net.nobien.jameson.mapping.support.TypeWithDateField;
    import net.nobien.jameson.mapping.support.TypeWithDateFieldMixin;
    
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
            om.registerMixin(TypeWithDateField, TypeWithDateFieldMixin);
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
        
        [Test]
        public function test_read_object_with_vector():void {
            var json:String = '[{"id":122, "name": "Simple", "isSomething":true}, {"id":123, "name": "Simple", "isSomething":true}]';
            var list:Vector.<SimpleType> = om.readObject(Vector.<SimpleType> as Class, json)  as Vector.<SimpleType>;
            Assert.assertEquals(2, list.length);
        }
        
        [Test]
        public function test_default_date_parser():void {
            var json:String = '{ "id": 1, "created": "2012-09-13 08:13:24" }';
            var instance:TypeWithDateField = om.readObject(TypeWithDateField, json);
            Assert.assertEquals(2012, instance.created.getFullYear());
            Assert.assertEquals(9, instance.created.getMonth());
            Assert.assertEquals(13, instance.created.getDate());
            Assert.assertEquals(8, instance.created.getHours());
            Assert.assertEquals(13, instance.created.getMinutes());
            Assert.assertEquals(24, instance.created.getSeconds());
        }
        
        [Test]
        public function test_custom_date_parser():void {
            om.dateParser = function(value:String):Date {
                var values:Array = value.split("-");
                return new Date(values[0], values[1], values[2]);
            }
            var json:String = '{ "id": 1, "created": "2012-09-13" }';
            var instance:TypeWithDateField = om.readObject(TypeWithDateField, json);
            Assert.assertEquals(2012, instance.created.getFullYear());
            Assert.assertEquals(9, instance.created.getMonth());
            Assert.assertEquals(13, instance.created.getDate());
        }
    }
    
}