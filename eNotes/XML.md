# XML (Extensible Markup Language)

---

## What is XML?

XML is a markup language that defines a set of rules for encoding documents in a format that is both human-readable and machine-readable. The World Wide Web Consortium's XML 1.0 Specification of 1998 and several other related specifications—all of them free open standards—define XML.

#### Documentation Comments in XML

1. Starting of a documentation comments

```xml
<?xml version = "1.0"?>
<!-- COMMENTS HERE -->
```

2. ```<Summary></summary>``` Tag

To add small/simple/brief description to an element.

3. ```<Para></Para>``` Tag

To add a paragraph to the description.

4. ```<See>``` Tag

   To add references to other elements.

*Syntax*

```xml
<See cref="classname/fun-name"/>
```

5. ```<Seealso>``` Tag
   
To look up the documentation of the namespace.

*Syntax*

```xml
<Seealso cref="namespacename"/>
```

6. ```<remarks></remarks>``` Tag
   
To add the bulk of the documentation. you can include <para> tag and bulleted lists and ```<para ref>``` tag in the remarks section.

*Syntax*

```xml
<list type="bullet">
    <item>customets
        <see cref="A()"/>
    </item>
</list>
```

7. ```<paramref>``` Tag
   
To reference and describe a parameter that is passed to a constructor.

*Syntax*

```xml
<remarks>stores URL from parameter
    <paramref name="strURL"/>
</remarks>
```

8. ```<example></example>``` Tag

Encloses the entire example including the description

9. ```<code></code>``` Tag

Encloses only the examples code

*Syntax*

```xml
<example>
    <name>hello.cs</name>
    <code>
        public class abc
        {
        // write code here
        }
    </code>
</example>
```

10. ```<param></param>``` Tag
    
To describe the parameters of constructors, methods, etc. i.e. ```<param name="strURL">used to hand over the URL of the web page</param>```

11. ```<value></value>``` Tag
    
To describe each classes property. it more or less replaces the ```<summary>``` tag.

```xml
<value>the property URL is to get & set URL</value>
```

##### Compiling the documentation

```shell
csc /doc : filename.xml sourcefile.cs <Enter>
```

##### Contents of xml file

```xml
<?xml version = "1.0"?>
<doc>
    <assembly>
        <name>Lakra's XML Example</name>
    </assembly>
    <members>
        <member name="className">Employee</member>
        <member name="className">Department</member>
    </members>
    <!-- write more tags here -->
</doc>
```

- Descriptions
    - ID => the member's name attribute
    - N => Denotes a namespace
    - T => identify a type. it can be class, interface struct, enum etc.
    - F => describe a field of a class
    - P => refers to a property
    - M => identify a method. it includes special methods such as constructors & operators
    - E => denotes Events
    - ! => denotes an error string

### QFE - (Quick Fix Engineering)

#### Versioning your Code

```
Version: - major version.minor version.build number.revision
```

- To add version information to your document, a.version switch is used.

```shell
csc /a.version:1.0.1.0 /t:library /out:file.dll source.cs
```

---

# Author

- Rohtash Lakra
