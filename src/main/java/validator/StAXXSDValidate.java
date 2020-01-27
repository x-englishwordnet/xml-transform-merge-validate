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
		XMLInputFactory xmlInputFactory = XMLInputFactory.newInstance();
		XMLStreamReader xmlStreamReader = xmlInputFactory.createXMLStreamReader(new FileInputStream(filename));
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

		new StAXXSDValidate().validateAll(args[0], Arrays.copyOfRange(args, 1, args.length));

		// Done
		final long endTime = System.currentTimeMillis();
		System.err.println("\nDone " + ((endTime - startTime) / 1000) + "s\n");
	}
}
