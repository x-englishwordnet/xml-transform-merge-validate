package validator;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeMap;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.stream.XMLStreamException;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class IDREFValidator
{
	public static void main(final String... args) throws XMLStreamException, SAXException, ParserConfigurationException, IOException, XPathExpressionException
	{
		boolean silent = false;
		String xsd = null;
		String defXPath = null;
		String refXPath = null;
		List<String> xmls = new ArrayList<>();

		for (int i = 0; i < args.length; i++)
		{
			if ("--silent".contentEquals(args[i]))
			{
				silent = true;
				continue;
			}
			if ("--validate".equals(args[i]))
			{
				xsd = args[++i];
				continue;
			}

			if (defXPath == null)
			{
				defXPath = args[i];
				continue;
			}
			if (refXPath == null)
			{
				refXPath = args[i];
				continue;
			}

			xmls.add(args[i]);
		}

		System.out.println("DEF: " + defXPath);
		System.out.println("REF: " + refXPath);
		System.out.println("XSD: " + xsd);

		for (String xml : xmls)
		{
			Map<String, List<String>> noRefs = process(defXPath, refXPath, xsd, xml);
			if (noRefs != null)
			{
				if (!silent)
					for (Entry<String, List<String>> entry : noRefs.entrySet())
					{
						String to = entry.getKey();
						String[] from = entry.getValue().toArray(new String[0]);
						System.out.printf("%s <- %s%n", to, Arrays.toString(from));
					}
			}
		}
	}

	private static Map<String, List<String>> process(final String defXPathExpr, final String refXPathExpr, final String xsd, final String... xmls) throws SAXException, ParserConfigurationException, IOException, XPathExpressionException
	{
		System.out.println("XML: " + Arrays.toString(xmls));

		XPathExpression defXPath = XPathFactory.newInstance().newXPath().compile(defXPathExpr);
		XPathExpression refXPath = XPathFactory.newInstance().newXPath().compile(refXPathExpr);

		long validRefCount = 0;
		long invalidRefCount = 0;
		long defCount = 0;
		long refCount = 0;
		Map<String, List<String>> invalidRefs = new TreeMap<>();

		// Docs
		List<Document> docs = new ArrayList<>();
		for (String xml : xmls)
		{
			Document doc = getDocument(xml, xsd);
			docs.add(doc);
		}

		// Defs
		Set<String> defs = new HashSet<>();
		for (Document doc : docs)
		{
			NodeList defNodes = (NodeList) defXPath.evaluate(doc, XPathConstants.NODESET);
			int defN = defNodes.getLength();
			for (int j = 0; j < defN; j++)
			{
				Node node = defNodes.item(j);
				assert node.getNodeType() == Node.ATTRIBUTE_NODE;
				String id = node.getNodeValue();
				defs.add(id);
				defCount++;
			}
		}

		// Refs
		for (Document doc : docs)
		{
			NodeList refNodes = (NodeList) refXPath.evaluate(doc, XPathConstants.NODESET);
			int refN = refNodes.getLength();
			for (int j = 0; j < refN; j++)
			{
				Node node = refNodes.item(j);
				assert node.getNodeType() == Node.ATTRIBUTE_NODE;
				Attr attr = (Attr) node;

				String idRef = attr.getNodeValue();
				if (defs.contains(idRef))
				{
					// System.out.println(node.getNodeValue());
					validRefCount++;
				}
				else
				{
					invalidRefCount++;

					// owner element or first ancestor element with an id
					Element referringElement = attr.getOwnerElement();
					Element parentElement = referringElement;
					String parentId = null;
					while (parentElement != null && (parentId = parentElement.getAttribute("id")).isEmpty())
					{
						parentElement = (Element) parentElement.getParentNode();
					}

					String parentName = parentElement == null ? referringElement.getNodeName() : parentElement.getNodeName();
					List<String> from = invalidRefs.computeIfAbsent(idRef, (l) -> new ArrayList<>());
					from.add(parentName + ' ' + (parentId == null ? "no id" : parentId));
				}
				refCount++;
			}
		}
		System.out.printf("defs:%d refs:%d valid:%d invalid:%d set:%d%n", defCount, refCount, validRefCount, invalidRefCount, invalidRefs.size());
		return invalidRefs;
	}

	/**
	 * Build W3C Document from file
	 *
	 * @param filePath
	 *            file path
	 * @param xsd
	 *            schema
	 * @return W3C Document
	 * @throws SAXException
	 *             sax
	 * @throws ParserConfigurationException
	 *             parser configuration
	 * @throws IOException
	 *             io
	 */
	static Document getDocument(String filePath, String xsd) throws SAXException, ParserConfigurationException, IOException
	{
		DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
		builderFactory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
		builderFactory.setValidating(false);
		builderFactory.setNamespaceAware(true);
		if (xsd != null)
		{
			SchemaFactory sf = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
			Schema schema = sf.newSchema(new File(xsd));
			builderFactory.setSchema(schema);
		}
		DocumentBuilder builder = builderFactory.newDocumentBuilder();
		builder.setEntityResolver(new EntityResolver()
		{
			@Override
			public InputSource resolveEntity(String publicId, String systemId) throws SAXException, IOException
			{
				if (systemId.contains(".dtd"))
				{
					return new InputSource(new StringReader(""));
				}
				else
				{
					return null;
				}
			}
		});
		Document doc = builder.parse(new File(filePath));
		doc.getDocumentElement().normalize();
		// System.err.println("Document " + filePath);
		return doc;
	}

	/**
	 * Get node list satisfying XPath expression
	 *
	 * @param expr
	 *            XPath expression
	 * @param doc
	 *            W3C Document
	 * @return node list satisfying XPath expression
	 * @throws XPathExpressionException
	 *             xpath
	 */
	static NodeList getXPathNodeList(String expr, Document doc) throws XPathExpressionException
	{
		return (NodeList) XPathFactory.newInstance().newXPath().compile(expr);
	}
}
