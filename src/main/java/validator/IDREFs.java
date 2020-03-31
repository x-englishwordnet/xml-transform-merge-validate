package validator;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeMap;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.stream.XMLStreamException;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class IDREFs
{
	public static void main(final String... args) throws XMLStreamException, SAXException, ParserConfigurationException, IOException, XPathExpressionException
	{
		boolean silent = false;
		int threshold = 1;
		String xsd = null;
		String defXPath = null;
		String refXPath = null;
		List<String> xmls = new ArrayList<>();

		for (int i = 0; i < args.length; i++)
		{
			if ("--silent".equals(args[i]) || "-s".equals(args[i]))
			{
				silent = true;
				continue;
			}
			if ("--validate".equals(args[i]) || "-v".equals(args[i]))
			{
				xsd = args[++i];
				continue;
			}

			if ("--threshold".equals(args[i]) || "-t".equals(args[i]))
			{
				threshold = Integer.parseInt(args[++i]);
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
			Map<String, List<String>> refs = process(defXPath, refXPath, xsd, xml);
			if (refs != null)
			{
				if (!silent)
				{
					int count = 0;
					for (Entry<String, List<String>> entry : refs.entrySet())
					{
						String to = entry.getKey();
						List<String> from = entry.getValue();
						if (from.size() >= threshold)
						{
							String[] fromArray = entry.getValue().toArray(new String[0]);
							System.out.printf("%s <- %s%n", to, Arrays.toString(fromArray));
							count++;
						}
					}
					System.out.printf("%d refs%n", count);
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
		Map<String, List<String>> refs = new TreeMap<>();

		// Docs
		List<Document> docs = new ArrayList<>();
		for (String xml : xmls)
		{
			Document doc = Util.getDocument(xml, xsd);
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
				}

				Element ownerElement = attr.getOwnerElement();
				String anchor = Util.findAnchor(ownerElement);
				List<String> from = refs.computeIfAbsent(idRef, (l) -> new ArrayList<>());
				from.add(anchor);

				refCount++;
			}
		}
		System.out.printf("defs:%d refs:%d valid:%d invalid:%d set:%d%n", defCount, refCount, validRefCount, invalidRefCount, refs.size());
		return refs;
	}
}
