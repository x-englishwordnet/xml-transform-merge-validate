package validator;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.xml.namespace.QName;
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
	// [xml]* -e [LexicalResource|Lexicon|LexicalEntry|Sense|Synset|SenseRelation|SynsetRelation|...]*
	public static void main(final String... args) throws XMLStreamException
	{
		// Timing
		final long startTime = System.currentTimeMillis();

		// command-line
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

		// validate
		long count = new WoodstoxValidate(xsd).validate(xmls, elements);

		// Done
		final long endTime = System.currentTimeMillis();
		System.err.println("\n" + "Done " + ((endTime - startTime) / 1000) + "s, " + count + " parsing events\n");
	}

	private final XMLValidationSchema schema;

	private ValidationProblemHandler handler = new ValidationProblemHandler()
	{
		public void reportProblem(XMLValidationProblem problem) throws XMLValidationException
		{
			System.err.println("INVALID " + problem.getMessage() + " " + problem.getLocation());
		}
	};

	public WoodstoxValidate(final String xsd) throws XMLStreamException
	{
		// schema
		XMLValidationSchemaFactory factory = XMLValidationSchemaFactory.newInstance(XMLValidationSchema.SCHEMA_ID_W3C_SCHEMA);
		this.schema = factory.createSchema(new File(xsd));
	}

	public long validate(final List<String> xmls, final List<String> elements) throws XMLStreamException
	{
		long count = 0;
		Set<QName> qnames = makeVadidatableElements(elements);

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

	public long doValidateAll(final XMLStreamReader2 xmlReader) throws XMLStreamException
	{
		Map<Integer, Integer> distrib = new HashMap<>();

		xmlReader.validateAgainst(this.schema);

		long count = 0;
		while (xmlReader.hasNext())
		{
			int type = xmlReader.next();
			distrib.put(type, (!distrib.containsKey(type) ? 0 : distrib.get(type)) + 1);
			count++;
		}
		xmlReader.close();
		for (Entry<Integer, Integer> entry : distrib.entrySet())
			System.out.println(entry.getKey() + ": " + entry.getValue());
		return count;
	}

	public long doValidateSome(final XMLStreamReader2 xmlReader, final Set<QName> qNames) throws XMLStreamException
	{
		Map<Integer, Integer> distrib = new HashMap<>();

		long count = 0;
		while (xmlReader.hasNext())
		{
			int type = xmlReader.next();
			distrib.put(type, (!distrib.containsKey(type) ? 0 : distrib.get(type)) + 1);
			switch (type)
			{
				case XMLStreamConstants.START_ELEMENT:
				{
					QName name = xmlReader.getName();
					if (qNames.contains(name))
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

				default: // if (type == XMLStreamConstants.ATTRIBUTE)
				{
					// xmlReader.validateAgainst(this.schema);
					// xmlReader.stopValidatingAgainst(this.schema);
					// count++;
				}
			}
		}
		xmlReader.close();
		for (Entry<Integer, Integer> entry : distrib.entrySet())
			System.out.println(entry.getKey() + ": " + entry.getValue());
		return count;
	}

	private XMLStreamReader2 makeReader(final String xml) throws XMLStreamException
	{
		XMLInputFactory2 factory = new WstxInputFactory();
		factory.setProperty(XMLInputFactory.IS_VALIDATING, false);
		return factory.createXMLStreamReader(new File(xml));
	}

	private static Set<QName> makeVadidatableElements(final List<String> elements)
	{
		if (elements == null || elements.isEmpty())
			return null;

		Set<QName> qNames = new HashSet<>();
		for (String element : elements)
		{
			QName qname = new QName(null, element);
			qNames.add(qname);
		}
		System.out.println("qnames: " + qNames);
		return qNames;
	}
}
