package validator;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
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

			if (refXPath == null)
			{
				refXPath = args[i];
				continue;
			}

			xmls.add(args[i]);
		}

		System.out.println("REF: " + refXPath);
		System.out.println("XSD: " + xsd);

		for (String xml : xmls)
		{
			Map<String, List<String>> refs = process(refXPath, xsd, xml);
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

	private static Map<String, List<String>> process(final String refXPathExpr, final String xsd, final String... xmls) throws SAXException, ParserConfigurationException, IOException, XPathExpressionException
	{
		System.out.println("XML: " + Arrays.toString(xmls));

		XPathExpression refXPath = XPathFactory.newInstance().newXPath().compile(refXPathExpr);

		long refCount = 0;
		Map<String, List<String>> refs = new TreeMap<>();

		// Docs
		List<Document> docs = new ArrayList<>();
		for (String xml : xmls)
		{
			Document doc = Util.getDocument(xml, xsd);
			docs.add(doc);
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
				Element ownerElement = attr.getOwnerElement();
				String anchor = Util.findAnchor(ownerElement);
				List<String> from = refs.computeIfAbsent(idRef, (l) -> new ArrayList<>());
				from.add(anchor);

				refCount++;
			}
		}
		System.out.printf("refs:%d set:%d%n", refCount, refs.size());
		return refs;
	}
}
