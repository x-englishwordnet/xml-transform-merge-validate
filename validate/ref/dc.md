####DC NAME SPACE

The namespace URL [http://purl.org/dc/elements/1.1/](http://purl.org/dc/elements/1.1/) redirects to
[http://dublincore.org/specifications/dublin-core/dcmi-terms/2012-06-14/?v=elements](http://dublincore.org/specifications/dublin-core/dcmi-terms/2012-06-14/?v=elements)

This [page](http://www.dublincore.org/schemas/xmls/) points to the schema location :

It contains the following:

**Target namespace:** 	http://purl.org/dc/elements/1.1/ 	
**Schema location:** http://dublincore.org/schemas/xmls/qdc/2008/02/11/dc.xsd

The latter defines

	  <xs:element name="title" substitutionGroup="any"/>
	  <xs:element name="creator" substitutionGroup="any"/>
	  <xs:element name="subject" substitutionGroup="any"/>
	  <xs:element name="description" substitutionGroup="any"/>
	  <xs:element name="publisher" substitutionGroup="any"/>
	  <xs:element name="contributor" substitutionGroup="any"/>
	  <xs:element name="date" substitutionGroup="any"/>
	  <xs:element name="type" substitutionGroup="any"/>
	  <xs:element name="format" substitutionGroup="any"/>
	  <xs:element name="identifier" substitutionGroup="any"/>
	  <xs:element name="source" substitutionGroup="any"/>
	  <xs:element name="language" substitutionGroup="any"/>
	  <xs:element name="relation" substitutionGroup="any"/>
	  <xs:element name="coverage" substitutionGroup="any"/>
	  <xs:element name="rights" substitutionGroup="any"/>
	
 * All elements are declared as substitutable for the abstract element any, 
  which means that the default type for all elements is dc:SimpleLiteral.*

**Term Name: identifier
**URI: http://purl.org/dc/elements/1.1/identifier
Label: Identifier
Definition: An unambiguous reference to the resource within a given context.
Comment: Recommended best practice is to identify the resource by means of a string conforming to a formal identification system.
Type of Term: 	Property
Version: http://dublincore.org/usage/terms/history/#identifier-006
Note: A second property with the same name as this property has been declared in the dcterms: namespace (http://purl.org/dc/terms/). See the Introduction to the document "DCMI Metadata Terms" (http://dublincore.org/specifications/dublin-core/dcmi-terms/) for an explanation.

**Term Name: subject
**URI: http://purl.org/dc/elements/1.1/subject
Label: Subject
Definition: The topic of the resource.
Comment: Typically, the subject will be represented using keywords, key phrases, or classification codes. Recommended best practice is to use a controlled vocabulary.
Type of Term: Property
Version: http://dublincore.org/usage/terms/history/#subject-007
Note: A second property with the same name as this property has been declared in the dcterms: namespace (http://purl.org/dc/terms/). See the Introduction to the document "DCMI Metadata Terms" (http://dublincore.org/specifications/dublin-core/dcmi-terms/) for an explanation.


######**VALIDATING AGAINST A DOCUMENT-SPECIFIED SCHEMA**
from https://www.ibm.com/developerworks/library/x-javaxmlvalidapi/index.html

Some documents specify the schema they expect to be validated against, typically using 
xsi:noNamespaceSchemaLocation and/or xsi:schemaLocation attributes like this:
	
	<document xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	  xsi:noNamespaceSchemaLocation="http://www.example.com/document.xsd">
	  ...
	
If you create a schema without specifying a URL, file, or source, then the Java language 
creates one that looks in the document being validated to find the schema it should use.
For example:
	
	SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
	Schema schema = factory.newSchema();
	
However, normally this isn't what you want. Usually the document consumer should choose the schema, not the document producer. 

Furthermore, this approach works only for XSD. All other schema languages require an explicitly 
specified schema location. 