package validator;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import javax.xml.XMLConstants;
import javax.xml.stream.XMLStreamException;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public abstract class BaseXSDValidate
{
	/**
	 * Problems
	 */
	protected Map<String, Integer> problems = new HashMap<>();

	/**
	 * Make source
	 * 
	 * @param filename
	 *            file to validate
	 * @return source
	 * @throws FileNotFoundException
	 * @throws XMLStreamException
	 */
	protected abstract Source makeSource(final String filename) throws FileNotFoundException, XMLStreamException;

	/**
	 * Make validator
	 *
	 * @param xsd
	 *            xsd file
	 * @return validator
	 * @throws SAXException
	 *             exception
	 */
	private Validator makeValidator(final String xsd) throws SAXException
	{
		URL xsdUrl;
		try
		{
			// give it a try as resource
			xsdUrl = BaseXSDValidate.class.getResource(xsd);
			// returns null if fails but does not raise exception
			if (xsdUrl == null)
				throw new IllegalArgumentException(xsd);
		}
		catch (final Exception e)
		{
			try
			{
				// give it a try as url
				xsdUrl = new URL(xsd);
			}
			catch (final Exception e1)
			{
				try
				{
					// give it a try as file
					xsdUrl = new File(xsd).toURI().toURL();
				}
				catch (final Exception e2)
				{
					throw new RuntimeException("No validator XSD file " + xsd);
				}
			}
		}

		final SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
		final Schema schema = schemaFactory.newSchema(xsdUrl);
		final Validator validator = schema.newValidator();
		System.out.println("XSD: " + xsdUrl);
		return validator;
	}

	/**
	 * Validate
	 *
	 * @param validator
	 *            validator
	 * @param source
	 *            source to validate
	 * @throws SAXException
	 *             exception
	 * @throws IOException
	 *             exception
	 */
	private void validate(final Validator validator, final Source source) throws SAXException, IOException
	{
		validator.setErrorHandler(new ErrorHandler()
		{
			@Override
			public void warning(SAXParseException e) throws SAXException
			{
				String file = source.getSystemId();
				int val = !BaseXSDValidate.this.problems.containsKey(file) ? 0 : BaseXSDValidate.this.problems.get(file);
				BaseXSDValidate.this.problems.put(file, val + 1);
				System.err.printf("[W] %s %s%n", e, source);
			}

			@Override
			public void error(SAXParseException e) throws SAXException
			{
				String file = source.getSystemId();
				int val = !BaseXSDValidate.this.problems.containsKey(file) ? 0 : BaseXSDValidate.this.problems.get(file);
				BaseXSDValidate.this.problems.put(file, val + 1);
				System.err.printf("[E] %s %s%n", e, source);
			}

			@Override
			public void fatalError(SAXParseException e) throws SAXException
			{
				String file = source.getSystemId();
				int val = !BaseXSDValidate.this.problems.containsKey(file) ? 0 : BaseXSDValidate.this.problems.get(file);
				BaseXSDValidate.this.problems.put(file, val + 1);
				System.err.printf("[F] %s %s%n", e, file);
				throw e;
			}
		});
		validator.validate(source);
	}

	/**
	 * Validate
	 *
	 * @param validator
	 *            validator
	 * @param file
	 *            file to validate
	 * @throws SAXException
	 *             exception
	 * @throws IOException
	 *             exception
	 */
	private void validate(final Validator validator, final String filename) throws SAXException, IOException
	{
		System.out.println("XML: " + filename);
		validate(validator, new StreamSource(filename));
	}

	/**
	 * Validate
	 *
	 * @param xsd
	 *            xsd path
	 * @param filenames
	 *            files
	 * @throws SAXException
	 *             exception
	 */
	public void validate(final String xsd, final String... filenames) throws SAXException
	{
		final Validator validator = makeValidator(xsd);
		for (final String filename : filenames)
		{
			// System.out.println("\n* validating " + filename);
			try
			{
				validate(validator, filename);
			}
			catch (final SAXException | IOException e)
			{
				System.out.println("FAILURE");
				System.err.println(e.getMessage());
			}
		}
	}
}
