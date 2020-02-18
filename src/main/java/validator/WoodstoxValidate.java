package validator;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.xml.namespace.QName;
import javax.xml.stream.Location;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamConstants;
import javax.xml.stream.XMLStreamException;

import org.codehaus.stax2.XMLInputFactory2;
import org.codehaus.stax2.XMLStreamReader2;
import org.codehaus.stax2.validation.ValidationProblemHandler;
import org.codehaus.stax2.validation.XMLValidationException;
import org.codehaus.stax2.validation.XMLValidationProblem;
import org.codehaus.stax2.validation.XMLValidationSchema;
import org.codehaus.stax2.validation.XMLValidationSchemaFactory;
import org.codehaus.stax2.validation.XMLValidator;

import com.ctc.wstx.stax.WstxInputFactory;

public class WoodstoxValidate
{
	private static final boolean STATS = false;

	/**
	 * Main entry point Arguments: [xml]* -e [LexicalResource|Lexicon|LexicalEntry|Sense|Synset|SenseRelation|SynsetRelation|...]*
	 * 
	 * @param args
	 *            command-line arguments
	 * @throws XMLStreamException
	 */
	public static void main(final String... args) throws XMLStreamException
	{
		// Timing
		final long startTime = System.currentTimeMillis();

		// Command-line
		String xsd = args[0];
		List<String> xmls = new ArrayList<>();
		List<String> elements = new ArrayList<>();
		boolean inQnames = false;
		for (int i = 1; i < args.length; i++)
		{
			String arg = args[i];
			if ("-e".equals(arg))
			{
				inQnames = true;
				continue;
			}
			if ("-x".equals(arg))
			{
				inQnames = false;
				continue;
			}

			if (inQnames)
			{
				elements.add(arg);
			}
			else
				xmls.add(arg);
		}

		// Validate
		WoodstoxValidate validator = new WoodstoxValidate(xsd);
		long parseEventcount = validator.validate(xmls, elements);

		// Results
		int invalidCount = validator.problems.keySet().size();

		// Done
		final long endTime = System.currentTimeMillis();
		System.err.printf("\nDone in %d ms, events %d, invalid %d%n%n", ((endTime - startTime) / 1000), parseEventcount, invalidCount);

		// Exit
		System.exit(invalidCount);
	}

	/**
	 * Schema
	 */
	private final XMLValidationSchema schema;

	/**
	 * Problems
	 */
	private Map<String, Integer> problems = new HashMap<>();

	/**
	 * Validation handler (called when a problem is found)
	 */
	private ValidationProblemHandler handler = new ValidationProblemHandler()
	{
		public void reportProblem(XMLValidationProblem problem) throws XMLValidationException
		{
			Location location = problem.getLocation();
			String file = location.getSystemId();
			int val = !WoodstoxValidate.this.problems.containsKey(file) ? 0 : WoodstoxValidate.this.problems.get(file);
			WoodstoxValidate.this.problems.put(file, val + 1);
			System.err.println("INVALID " + problem.getMessage() + " " + location);
		}
	};

	/**
	 * Constructor
	 * 
	 * @param xsd
	 *            XSD file
	 * @throws XMLStreamException
	 */
	public WoodstoxValidate(final String xsd) throws XMLStreamException
	{
		// schema
		XMLValidationSchemaFactory factory = XMLValidationSchemaFactory.newInstance(XMLValidationSchema.SCHEMA_ID_W3C_SCHEMA);
		this.schema = factory.createSchema(new File(xsd));
	}

	/**
	 * Validate data files
	 * 
	 * @param xmls
	 *            data files
	 * @param elements
	 *            list of elements to validate, null for all
	 * @return number of parse events
	 * @throws XMLStreamException
	 */
	public long validate(final List<String> xmls, final List<String> elements) throws XMLStreamException
	{
		long count = 0;
		Set<QName> qnames = makeValidatableElements(elements);

		for (String xml : xmls)
		{
			System.out.println("XML: " + xml);

			// data reader
			final XMLStreamReader2 xmlReader = makeReader(xml);
			xmlReader.setValidationProblemHandler(this.handler);

			// validate
			if (elements != null && !elements.isEmpty())
			{
				long count1 = doValidateSome(xmlReader, qnames);
				count += count1;
			}
			else
			{
				long count1 = doValidateAll(xmlReader);
				count += count1;
			}
		}
		return count;
	}

	/**
	 * Full validation. Note that IDREF(s) are checked.
	 * 
	 * @param xmlReader
	 *            xml reader
	 * @return number of parse events
	 * @throws XMLStreamException
	 */
	public long doValidateAll(final XMLStreamReader2 xmlReader) throws XMLStreamException
	{
		long[] stats = new long[15];

		xmlReader.validateAgainst(this.schema);

		long count = 0;
		while (xmlReader.hasNext())
		{
			int type = xmlReader.next();
			if (type < stats.length)
				stats[type]++;
			count++;
		}
		xmlReader.close();

		if (STATS)
		{
			System.out.println("start:		" + stats[XMLStreamConstants.START_ELEMENT]);
			System.out.println("end:		" + stats[XMLStreamConstants.END_ELEMENT]);
			System.out.println("comment:	" + stats[XMLStreamConstants.COMMENT]);
			System.out.println("characters:	" + stats[XMLStreamConstants.CHARACTERS]);
			System.out.println("spaces:		" + stats[XMLStreamConstants.SPACE]);
		}
		return count;
	}

	/**
	 * Partial validation of found qNames. Note that IDREF(s) are NOT checked.
	 * 
	 * @param xmlReader
	 *            xml reader
	 * @param qNames
	 *            qNames that start validation when element start is found and stop it when element end is found
	 * @return number of parse events
	 * @throws XMLStreamException
	 */
	public long doValidateSome(final XMLStreamReader2 xmlReader, final Set<QName> qNames) throws XMLStreamException
	{
		long[] stats = new long[15];

		long count = 0;
		while (xmlReader.hasNext())
		{
			int type = xmlReader.next();
			if (type < stats.length)
				stats[type]++;
			switch (type)
			{
				case XMLStreamConstants.START_ELEMENT:
				{
					QName qName = xmlReader.getName();
					if (qNames.contains(qName))
					{
						xmlReader.validateAgainst(this.schema);
					}
					break;
				}

				case XMLStreamConstants.END_ELEMENT:
				{
					QName name = xmlReader.getName();
					if (qNames.contains(name))
					{
						XMLValidator validator = xmlReader.stopValidatingAgainst(this.schema);
						if (validator == null)
							System.err.println("Validator not started for " + name);
						count++;
					}
					break;
				}

				//@formatter:off
				/*
				// Not called 
				case XMLStreamConstants.ATTRIBUTE:
				{
					// xmlReader.validateAgainst(this.schema);
					// xmlReader.stopValidatingAgainst(this.schema);
					// count++;
					break;
				}
				*/
				//@formatter:on

				default:
				{
				}
			}
		}
		xmlReader.close();

		if (STATS)
		{
			System.out.println("start:		" + stats[XMLStreamConstants.START_ELEMENT]);
			System.out.println("end:		" + stats[XMLStreamConstants.END_ELEMENT]);
			System.out.println("comment:	" + stats[XMLStreamConstants.COMMENT]);
			System.out.println("characters:	" + stats[XMLStreamConstants.CHARACTERS]);
			System.out.println("spaces:		" + stats[XMLStreamConstants.SPACE]);
		}
		return count;
	}

	/**
	 * Make stream reader
	 * 
	 * @param xml
	 *            xml file path
	 * @return stream reader
	 * @throws XMLStreamException
	 */
	private XMLStreamReader2 makeReader(final String xml) throws XMLStreamException
	{
		XMLInputFactory2 factory = new WstxInputFactory();
		factory.setProperty(XMLInputFactory.IS_VALIDATING, false);
		return factory.createXMLStreamReader(new File(xml));
	}

	/**
	 * Make set of validatable elements
	 * 
	 * @param elements
	 *            list of element tags
	 * @return set of qNames
	 */
	private static Set<QName> makeValidatableElements(final List<String> elements)
	{
		if (elements == null || elements.isEmpty())
			return null;

		Set<QName> qNames = new HashSet<>();
		for (String element : elements)
		{
			QName qName = new QName(null, element);
			qNames.add(qName);
		}
		System.out.println("qnames: " + qNames);
		return qNames;
	}
}
