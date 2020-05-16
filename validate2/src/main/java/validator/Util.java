package validator;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
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

public class Util
{
	private Util()
	{
	}

	/**
	 * Get anchor (a loose indication of location: first element ancestor (or this node) with id, tag)
	 *
	 * @param node
	 *            node
	 * @return anchor
	 */
	public static String findNodeAnchor(final Node node)
	{
		int type = node.getNodeType();
		switch (type)
		{
			case Node.ATTRIBUTE_NODE:
				Attr attr = (Attr) node;
				// owner element or first ancestor element with an id
				Element ownerElement = attr.getOwnerElement();
				return findAnchor(ownerElement);

			case Node.ELEMENT_NODE:
				Element element = (Element) node;
				return findAnchor(element);

			case Node.TEXT_NODE:
				Element parentElement = (Element) node.getParentNode();
				return findAnchor(parentElement);

			default:
				return null;
		}
	}

	/**
	 * Find anchor
	 *
	 * @param element
	 *            start element
	 * @return anchor
	 */
	public static String findAnchor(final Element element)
	{
		Element parentElement = findElementWithId(element);
		if (parentElement != null)
			return parentElement.getNodeName() + ' ' + parentElement.getAttribute("id");
		else
			return element.getNodeName() + ' ' + element.getAttribute("id");
	}

	/**
	 * Find first element on ancestor axis with an 'id' attribute
	 *
	 * @param element
	 *            start element
	 * @return first ancestor with an 'id', or this element if not found
	 */
	public static Element findElementWithId(final Element element)
	{
		Element parentElement = element;
		while (parentElement != null && parentElement.getAttribute("id").isEmpty())
		{
			parentElement = (Element) parentElement.getParentNode();
		}
		return parentElement;
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
	public static Document getDocument(String filePath, String xsd) throws SAXException, ParserConfigurationException, IOException
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
	 * Evaluate xPath as string in the context of node
	 *
	 * @param xPath
	 *            xPath
	 * @param node
	 *            node that serves as context
	 * @return string
	 * @throws XPathExpressionException
	 *             XPath expression exception
	 */
	public static String evaluate(final XPathExpression xPath, Node node) throws XPathExpressionException
	{
		return xPath.evaluate(node);
	}

	/**
	 * Evaluate xPath as nideset in the context of node
	 *
	 * @param xPath
	 *            xPath
	 * @param node
	 *            node that serves as context
	 * @return string
	 * @throws XPathExpressionException
	 *             XPath expression exception
	 */
	public static String evaluateAsNodeSet(XPathExpression xPath, Node node) throws XPathExpressionException
	{
		NodeList nodes = (NodeList) xPath.evaluate(node, XPathConstants.NODESET);
		int n = nodes.getLength();
		if (n == 0)
			return "";
		else if (n == 0)
			return nodes.item(0).getNodeValue();
		StringBuilder sb = new StringBuilder();
		sb.append('[');
		for (int i = 0; i < n; i++)
		{
			if (i != 0)
				sb.append(' ');
			sb.append(nodes.item(i).getNodeValue());
		}
		sb.append(']');
		return sb.toString();
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
	public static NodeList getXPathNodeList(String expr, Document doc) throws XPathExpressionException
	{
		return (NodeList) XPathFactory.newInstance().newXPath().compile(expr);
	}
}
