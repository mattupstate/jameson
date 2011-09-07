# Jameson

Jameson is an ActionScript 3 JSON document object mapper. It is partly inspired by Jackson [Java JSON Process project](http://jackson.codehaus.org/). As for now, refer to the unit tests for examples of how to use the API.

This project is very much in development and is wide open for contributions and suggestions for additional functionality. 

### Getting Started

To compile the swc or run the unit tests, create a file named user.properties and define the path to the Flex SDK and a few other properties. For example:

    FLEX_HOME = /Users/Matt/SDK/Flex/4.1
    is.unix = true # false if your on windows
    browser.exe = /path/to/browser/executable

Run unit tests:

    ant test

Build SWC:

    ant build

