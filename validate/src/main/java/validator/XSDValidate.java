package validator;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.Arrays;

import javax.xml.XMLConstants;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.transform.Source;
import javax.xml.transform.sax.SAXSource;

import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

public class XSDValidate extends BaseXSDValidate
{
	@Override
	protected Source makeSource(final String filename) throws FileNotFoundException, XMLStreamException
	{
		try
		{
			SAXParserFactory spf = SAXParserFactory.newInstance();
			spf.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
			XMLReader xmlReader;
			xmlReader = spf.newSAXParser().getXMLReader();
			InputSource inputSource = new InputSource(new FileReader(filename));
			return new SAXSource(xmlReader, inputSource);
		}
		catch (SAXException | ParserConfigurationException e)
		{
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Main
	 *
	 * @param args
	 *            args[0] xsd, args[1..] files to validate
	 * @throws SAXException
	 *             exception
	 */
	public static void main(final String[] args) throws SAXException
	{
		// Timing
		final long startTime = System.currentTimeMillis();

		// Validate
		BaseXSDValidate validator = new XSDValidate();
		validator.validate(args[0], Arrays.copyOfRange(args, 1, args.length));

		// Results
		int invalidCount = validator.problems.keySet().size();

		// Done
		final long endTime = System.currentTimeMillis();
		System.err.printf("%nDone in %d ms, invalid %d%n%n", ((endTime - startTime) / 1000), invalidCount);

		// Exit
		System.exit(invalidCount);
	}
}
