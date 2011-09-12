package net.nobien.jameson {
    
    import net.nobien.jameson.client.LoaderFactoryTests;
    import net.nobien.jameson.client.RestTemplateTests;
    import net.nobien.jameson.mapping.ObjectMapperTests;
    
    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class JamesonTestSuite {
        
        public var objectMapperTests:ObjectMapperTests;
        public var loaderFactoryTests:LoaderFactoryTests;
        public var restTempalteTests:RestTemplateTests;
        
    }
    
}