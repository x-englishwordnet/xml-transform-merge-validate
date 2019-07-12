/**
 * Title : XSLT transformer
 * Description : XML transformer using XSL
 * Version : 3.x
 * Copyright : (c) 2001-2019
 * Author : Bernard Bou
 * 
 */

package transformer;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.StringWriter;
import java.net.URL;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.w3c.dom.Document;

/**
 * Transform (document to XML text)
 *
 * @author Bernard Bou
 */
public class DomTransformer
{
	/**
	 * Output as html
	 */
	private final String outputMethod;

	/**
	 * Doc type system string
	 */
	private final String docTypeSystem;

	/**
	 * Doc type public string
	 */
	private final String docTypePublic;

	// C O N S T R U C T O R

	/**
	 * Constructor
	 */
	public DomTransformer()
	{
		this(null, null, null);
	}

	/**
	 * Constructor
	 *
	 * @param outputMethod
	 *            output method
	 * @param docTypeSystem
	 *            doctype system
	 * @param docTypePublic
	 *            doctype public
	 */
	public DomTransformer(final String outputMethod, final String docTypeSystem, final String docTypePublic)
	{
		this.outputMethod = outputMethod;
		this.docTypeSystem = docTypeSystem;
		this.docTypePublic = docTypePublic;
	}

	private Transformer config(final Transformer transformer)
	{
		if (this.outputMethod != null)
		{
			transformer.setOutputProperty(javax.xml.transform.OutputKeys.METHOD, this.outputMethod);
		}
		if (this.docTypeSystem != null)
		{
			transformer.setOutputProperty(javax.xml.transform.OutputKeys.DOCTYPE_SYSTEM, this.docTypeSystem);
		}
		if (this.docTypeSystem != null)
		{
			transformer.setOutputProperty(javax.xml.transform.OutputKeys.DOCTYPE_PUBLIC, this.docTypePublic);
		}
		transformer.setOutputProperty(javax.xml.transform.OutputKeys.INDENT, "yes");
		transformer.setOutputProperty(javax.xml.transform.OutputKeys.ENCODING, "UTF8");
		transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
		return transformer;
	}

	// T O . F I L E

	/**
	 * Transform XML file to XML file using XSLT file
	 *
	 * @param inFilePath
	 *            in file
	 * @param outFilePath
	 *            out file
	 * @param xsltFilePath
	 *            xslt file
	 * @throws TransformerException
	 * @throws IOException
	 */
	public void fileToFile(final String inFilePath, final String outFilePath, final String xsltFilePath) throws TransformerException, IOException
	{
		// xsl
		final Source xsltSource = new StreamSource(new File(xsltFilePath));

		// in
		final Source xmlSource = inFilePath.equals("-") ? new StreamSource(System.in) : new StreamSource(new File(inFilePath));

		// out
		final StreamResult result = outFilePath.equals("-") ? new StreamResult(System.out) : new StreamResult(new FileWriter(outFilePath));

		// transform
		final TransformerFactory factory = TransformerFactory.newInstance();
		final Transformer transformer = config(factory.newTransformer(xsltSource));
		transformer.transform(xmlSource, result);
	}

	/**
	 * Transform DOM document to XML file
	 *
	 * @param document
	 *            is the DOM Document to be output as XML
	 * @param outputFile
	 *            is the output file
	 * @throws TransformerConfigurationException
	 * @throws TransformerException
	 * @throws IOException
	 */
	public void documentToFile(final Document document, final File outputFile) throws TransformerConfigurationException, TransformerException, IOException
	{
		toFile(document, null, outputFile);
	}

	/**
	 * Transform DOM document to XML file after applying XSL transform
	 *
	 * @param document
	 *            is the DOM Document to be output as XML
	 * @param xsltUrl
	 *            is the XSLT source file
	 * @param outputFile
	 *            is the output file
	 * @throws TransformerConfigurationException
	 * @throws TransformerException
	 * @throws IOException
	 */
	public void documentToFile(final Document document, final URL xsltUrl, final File outputFile) throws TransformerConfigurationException, TransformerException, IOException
	{
		final StreamSource xsltSource = new StreamSource(xsltUrl.openStream());
		toFile(document, xsltSource, outputFile);
	}

	// T O . S T R I N G

	/**
	 * Transform DOM document to XML string
	 *
	 * @param document
	 *            is the DOM Document to be output as XML
	 * @return XML String that represents DOM document
	 * @throws TransformerConfigurationException
	 * @throws TransformerException
	 * @throws IOException
	 */
	public String documentToString(final Document document) throws TransformerConfigurationException, TransformerException, IOException
	{
		return toString(document, (Source) null);
	}

	/**
	 * Transform DOM document to XML string after applying XSL transformation
	 *
	 * @param document
	 *            is the DOM Document to be output as XML
	 * @param xsltFile
	 *            is the XSLT source file
	 * @return XML String that represents DOM document
	 * @throws TransformerConfigurationException
	 * @throws TransformerException
	 * @throws IOException
	 */
	public String documentToString(final Document document, final File xsltFile) throws TransformerConfigurationException, TransformerException, IOException
	{
		final StreamSource xsltSource = new StreamSource(xsltFile);
		return toString(document, xsltSource);
	}

	/**
	 * Transform DOM document to XML string after applying XSL transformation
	 *
	 * @param document
	 *            is the DOM Document to be output as XML
	 * @param xsltUrl
	 *            is the XSLT source url
	 * @return XML String that represents DOM document
	 * @throws TransformerConfigurationException
	 * @throws TransformerException
	 * @throws IOException
	 */
	public String documentToString(final Document document, final URL xsltUrl) throws TransformerConfigurationException, TransformerException, IOException
	{
		final StreamSource xsltSource = new StreamSource(xsltUrl.openStream());
		return toString(document, xsltSource);
	}

	// T O . S T R E A M

	/**
	 * Transform DOM document to XML stream
	 *
	 * @param document
	 *            is the DOM Document to be output as XML
	 * @param outputStream
	 *            is the output stream
	 * @throws TransformerConfigurationException
	 * @throws TransformerException
	 * @throws IOException
	 */
	public void documentToStream(final Document document, final OutputStream outputStream) throws TransformerConfigurationException, TransformerException, IOException
	{
		final StreamResult result = new StreamResult(outputStream);
		toStream(document, null, result);
	}


	/**
	 * File to stream result
	 * 
	 * @param inFilePath
	 *            the file path
	 * @param streamResult
	 *            the stream result
	 * @param xsltFilePath
	 *            the XSLT source
	 * @throws TransformerException
	 */
	public void fileToStreamResult(final String inFilePath, final StreamResult streamResult, final String xsltFilePath) throws TransformerException
	{
		// xsl
		final Source xsltSource = new StreamSource(new File(xsltFilePath));

		// in
		final Source xmlSource = inFilePath.equals("-") ? new StreamSource(System.in) : new StreamSource(new File(inFilePath));

		// transform
		final TransformerFactory factory = TransformerFactory.newInstance();
		final Transformer transformer = config(factory.newTransformer(xsltSource));
		transformer.transform(xmlSource, streamResult);
	}

	// T O . D O C U M E N T

	/**
	 * File to document
	 *
	 * @param xmlUrl
	 *            XML document url
	 * @param xsltUrl
	 *            XSL url
	 * @return document
	 * @throws TransformerConfigurationException
	 * @throws TransformerException
	 * @throws IOException
	 */
	public Document fileToDocument(final URL xmlUrl, final URL xsltUrl) throws TransformerConfigurationException, TransformerException, IOException
	{
		final StreamSource xml = new StreamSource(xmlUrl.openStream());
		final StreamSource xslt = new StreamSource(xsltUrl.openStream());
		return toDocument(xml, xslt);
	}

	/**
	 * Transform DOM document to DOM document
	 *
	 * @param document
	 *            DOM document
	 * @param xsltUrl
	 *            XSLT url
	 * @return document
	 * @throws IOException
	 * @throws TransformerException
	 * @throws TransformerConfigurationException
	 */
	public Document documentToDocument(final Document document, final URL xsltUrl) throws TransformerConfigurationException, TransformerException, IOException
	{
		final DOMSource source = new DOMSource(document);
		final StreamSource styleSource = new StreamSource(xsltUrl.openStream());
		return toDocument(source, styleSource);
	}

	// H E L P E R S

	/**
	 * Transform DOM document to XML string
	 *
	 * @param document
	 *            is the DOM Document to be output as XML
	 * @param xsltSource
	 *            is the XSLT source
	 * @return XML String that represents DOM document
	 * @throws TransformerConfigurationException
	 * @throws TransformerException
	 * @throws IOException
	 */
	protected String toString(final Document document, final Source xsltSource) throws TransformerConfigurationException, TransformerException, IOException
	{
		final StringWriter writer = new StringWriter();
		final StreamResult result = new StreamResult(writer);
		toStream(document, xsltSource, result);
		return writer.toString();
	}

	/**
	 * Transform DOM document to XML file
	 *
	 * @param document
	 *            is the DOM Document to be output as XML
	 * @param xsltSource
	 *            is the XSLT source
	 * @param outFile
	 *            output file
	 * @throws TransformerConfigurationException
	 * @throws TransformerException
	 * @throws IOException
	 */
	protected void toFile(final Document document, final Source xsltSource, final File outFile) throws TransformerConfigurationException, TransformerException, IOException
	{
		final StreamResult result = new StreamResult(outFile);
		toStream(document, xsltSource, result);
	}

	/**
	 * Transform DOM document to stream result
	 *
	 * @param document
	 *            is the DOM Document to be output as XML
	 * @param xsltSource
	 *            is the XSLT source
	 * @param result
	 *            is the stream result
	 * @throws TransformerConfigurationException
	 * @throws TransformerException
	 * @throws IOException
	 */
	protected void toStream(final Document document, final Source xsltSource, final StreamResult result) throws TransformerConfigurationException, TransformerException, IOException
	{
		final DOMSource source = new DOMSource(document);

		// transform
		final TransformerFactory factory = TransformerFactory.newInstance();
		final Transformer transformer = config(xsltSource == null ? factory.newTransformer() : factory.newTransformer(xsltSource));
		config(transformer);
		transformer.transform(source, result);
	}

	/**
	 * Transform source to document
	 *
	 * @param xmlSource
	 *            the XML source
	 * @param xsltSource
	 *            the XSLT source
	 * @return document
	 * @throws TransformerConfigurationException
	 * @throws TransformerException
	 * @throws IOException
	 */
	protected Document toDocument(final Source xmlSource, final Source xsltSource) throws TransformerConfigurationException, TransformerException, IOException
	{
		final DOMResult result = new DOMResult();

		// transform
		final TransformerFactory factory = TransformerFactory.newInstance();
		final Transformer transformer = config(xsltSource == null ? factory.newTransformer() : factory.newTransformer(xsltSource));
		transformer.transform(xmlSource, result);
		return (Document) result.getNode();
	}
}