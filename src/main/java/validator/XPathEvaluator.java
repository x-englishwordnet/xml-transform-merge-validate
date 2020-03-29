package validator;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.stream.XMLStreamException;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class XPathEvaluator
{
	static boolean debug = false;

	enum SetOp
	{
		UNION, INTERSECTION, MINUS
	}

	public static void main(final String... args) throws XMLStreamException, SAXException, ParserConfigurationException, IOException, XPathExpressionException
	{
		boolean silent = false;
		SetOp op = SetOp.UNION;
		String xsd = null;
		List<String> xPaths = new ArrayList<>();
		List<String> xmls = new ArrayList<>();
		String ouputXPath = null;

		for (int i = 0; i < args.length; i++)
		{
			if ("--or".contentEquals(args[i]))
			{
				op = SetOp.UNION;
				continue;
			}
			if ("--and".equals(args[i]))
			{
				op = SetOp.INTERSECTION;
				continue;
			}
			if ("--minus".equals(args[i]))
			{
				op = SetOp.MINUS;
				continue;
			}
			if ("--debug".equals(args[i]) || "-d".equals(args[i]))
			{
				debug = true;
				continue;
			}
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
			if ("--xpath".equals(args[i]) || "-x".equals(args[i]))
			{
				xPaths.add(args[++i]);
				continue;
			}
			if ("--outputxpath".equals(args[i]) || "-o".equals(args[i]))
			{
				ouputXPath = args[++i];
				continue;
			}
			xmls.add(args[i]);
		}

		String[] xPathArray = xPaths.toArray(new String[0]);

		System.out.println("OP:     " + op);
		System.out.println("XPATHS: " + Arrays.toString(xPathArray));
		System.out.println("OUTPUT: " + ouputXPath);
		System.out.println("XSD:    " + xsd);

		for (String xml : xmls)
		{
			Set<String> result = process(xPathArray, ouputXPath, op, xsd, xml);
			if (result != null)
			{
				if (!silent)
					for (String item : result)
					{
						System.out.printf("%s%n", item);
					}
				System.out.printf("%d item(s)%n", result.size());
			}
		}
	}

	private static Set<String> process(final String[] xPathExprs, final String outputXPathExpr, final SetOp op, final String xsd, final String... xmls) throws SAXException, ParserConfigurationException, IOException, XPathExpressionException
	{
		System.out.println("XMLS:   " + Arrays.toString(xmls));

		// Result
		Set<String> result = null;

		// XPaths
		final int nXPaths = xPathExprs.length;
		final XPathExpression[] xPaths = new XPathExpression[nXPaths];
		for (int i = 0; i < nXPaths; i++)
			xPaths[i] = XPathFactory.newInstance().newXPath().compile(xPathExprs[i]);
		final XPathExpression outputXPath = outputXPathExpr == null ? null : XPathFactory.newInstance().newXPath().compile(outputXPathExpr);

		// Docs
		final List<Document> docs = new ArrayList<>();
		for (String xml : xmls)
		{
			final Document doc = Util.getDocument(xml, xsd);
			docs.add(doc);
		}

		// Eval
		for (Document doc : docs)
		{
			for (int i = 0; i < nXPaths; i++)
			{
				final Set<String> result2 = new TreeSet<>();

				final NodeList nodes = (NodeList) xPaths[i].evaluate(doc, XPathConstants.NODESET);
				final int nNodes = nodes.getLength();
				for (int j = 0; j < nNodes; j++)
				{
					final Node node = nodes.item(j);

					final String value = outputXPath != null ? Util.evaluate(outputXPath, node) : node.getNodeValue();
					result2.add(value);
					if (debug)
						System.err.println(value + " @ " + Util.findNodeAnchor(node));
				}
				if (result == null)
					result = result2;
				else
				{
					switch (op)
					{
						case UNION:
							result.addAll(result2);
							break;
						case INTERSECTION:
							result.retainAll(result2);
							break;
						case MINUS:
							result.removeAll(result2);
							break;
					}
				}
			}
		}
		return result;
	}
}
