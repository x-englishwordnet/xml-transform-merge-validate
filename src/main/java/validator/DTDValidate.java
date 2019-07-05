package validator;

import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class DTDValidate {
	/**
	 * Validate build
	 *
	 * @param dtd      dtd
	 * @param filename file
	 * @throws SAXException                 exception
	 * @throws IOException                  exception
	 * @throws ParserConfigurationException exception
	 */
	public static void validateDtdBuild(final String dtd, final String filename)
			throws SAXException, IOException, ParserConfigurationException {
		final DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
		domFactory.setValidating(true);
		final DocumentBuilder builder = domFactory.newDocumentBuilder();
		builder.setErrorHandler(new ErrorHandler() {
			@Override
			public void error(final SAXParseException e) throws SAXException {
				System.err.println(e);
			}

			@Override
			public void fatalError(final SAXParseException e) throws SAXException {
				System.err.println(e);
			}

			@Override
			public void warning(final SAXParseException e) throws SAXException {
				System.err.println(e);
			}
		});
		builder.parse(filename);
	}

	/**
	 * Main
	 *
	 * @param args args[0] xsd, args[1..] files to validate
	 * @throws SAXException exception
	 */
	public static void main(final String[] args) throws IOException, SAXException, ParserConfigurationException {
		validateDtdBuild(args[0], args[1]);
	}
}
