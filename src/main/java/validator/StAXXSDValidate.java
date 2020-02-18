package validator;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.Arrays;

import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.transform.Source;
import javax.xml.transform.stax.StAXSource;

import org.xml.sax.SAXException;

public class StAXXSDValidate extends BaseXSDValidate
{
	@Override
	protected Source makeSource(final String filename) throws FileNotFoundException, XMLStreamException
	{
		XMLInputFactory factory = XMLInputFactory.newInstance();
		factory.setProperty(XMLInputFactory.IS_VALIDATING, false);
		XMLStreamReader xmlStreamReader = factory.createXMLStreamReader(new FileInputStream(filename));
		return new StAXSource(xmlStreamReader);
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
		BaseXSDValidate validator = new StAXXSDValidate();
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
