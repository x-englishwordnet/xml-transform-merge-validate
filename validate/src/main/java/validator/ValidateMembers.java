package validator;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;

import java.io.File;
import java.util.*;
import java.util.Map.Entry;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

public class ValidateMembers extends DefaultHandler
{
	private String lexId;
	private Map<String, String> synsetIdToMembers = new HashMap<>();
	private List<Entry<String, String>> wordToSynsetId = new ArrayList<>();

	static public void main(String[] args) throws Exception
	{
		parse(args);
	}

	static private void parse(String[] args) throws Exception
	{
		ValidateMembers validator = new ValidateMembers();
		SAXParserFactory spf = SAXParserFactory.newInstance();
		spf.setNamespaceAware(true);
		SAXParser saxParser = spf.newSAXParser();
		XMLReader xmlReader = saxParser.getXMLReader();
		xmlReader.setContentHandler(validator);

		for (int i = 0; i < args.length; i++)
		{
			String filename = args[i];
			String url = convertToFileURL(filename);
			System.out.println(url);

			xmlReader.parse(url);
			validator.check();
		}
	}

	private void check()
	{
		for (Entry<String, String> entry : wordToSynsetId)
		{
			String lexId = entry.getKey();
			String synsetId = entry.getValue();
			String members = synsetIdToMembers.get(synsetId);
			if (!members.contains(lexId))
			{
				System.err.println(lexId + " not in " + synsetId + " members=" + members);
			}
		}
	}

	@Override
	public void startElement(String namespaceURI, String localName, String qName, Attributes atts) throws SAXException
	{
		if ("Synset".equals(localName))
		{
			String synsetId = getAttr(atts, "id", qName);
			String members = getAttr(atts, "members", qName);
			synsetIdToMembers.put(synsetId, members);
		}
		else if ("Sense".equals(localName))
		{
			String senseId = getAttr(atts, "id", qName);
			String synsetId = getAttr(atts, "synset", qName);
			wordToSynsetId.add(new AbstractMap.SimpleEntry<>(lexId, synsetId));
		}
		else if ("LexicalEntry".equals(localName))
		{
			lexId = getAttr(atts, "id", qName);
		}
	}

	public String getAttr(Attributes atts, String name, String qName) throws IllegalStateException
	{
		for (int i = 0; i < atts.getLength(); i++)
		{
			String attrName = atts.getQName(i);
			if (name.equals(attrName))
			{
				String attrValue = atts.getValue(i);
				//System.out.printf("'%s %s' %s\n", qName, attrName, attrValue, "ok");
				return attrValue;
			}
		}
		throw new IllegalStateException(qName + " " + atts);
	}

	private static String convertToFileURL(String filename)
	{
		String path = new File(filename).getAbsolutePath();
		if (File.separatorChar != '/')
		{
			path = path.replace(File.separatorChar, '/');
		}

		if (!path.startsWith("/"))
		{
			path = "/" + path;
		}
		return "file:" + path;
	}
}
