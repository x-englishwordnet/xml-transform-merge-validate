package validator;

import java.io.File;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

//import org.apache.xerces.util.XMLChar;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;

public class ValidateNamesInFiles extends DefaultHandler {

	static public void main(String[] args) throws Exception {
		parse(args);
	}

	static public void parse(String[] args) throws Exception {

		SAXParserFactory spf = SAXParserFactory.newInstance();
		spf.setNamespaceAware(true);
		SAXParser saxParser = spf.newSAXParser();
		XMLReader xmlReader = saxParser.getXMLReader();
		xmlReader.setContentHandler(new ValidateNamesInFiles());

		for (int i = 0; i < args.length; i++) {
			String filename = args[i];
			String url = convertToFileURL(filename);
			System.out.println(url);

			xmlReader.parse(url);
		}
	}

	public void startElement(String namespaceURI, String localName, String qName, Attributes atts) throws SAXException {

		for (int i = 0; i < atts.getLength(); i++) {
			String attrName = atts.getQName(i);
			String attrValue = atts.getValue(i);
			boolean ok = XMLChar.isValidName(attrName);
			if (!ok)
				System.err.printf("'%s %s' %s\n", qName, attrName, attrValue, "fail");
			// else
			// System.out.printf("'%s %s' %s\n", qName, attrName, attrValue, "ok");
		}
	}

	private static String convertToFileURL(String filename) {
		String path = new File(filename).getAbsolutePath();
		if (File.separatorChar != '/') {
			path = path.replace(File.separatorChar, '/');
		}

		if (!path.startsWith("/")) {
			path = "/" + path;
		}
		return "file:" + path;
	}
}
