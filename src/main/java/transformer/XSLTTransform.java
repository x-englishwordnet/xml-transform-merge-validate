package transformer;

import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.List;

import javax.xml.transform.stream.StreamResult;

public class XSLTTransform
{
	public static void main(final String[] args)
	{
		String xsltFilePath = null;
		String outputMethod = null;
		String docTypeSystem = null;
		String docTypePublic = null;
		String result = null;
		List<String> inputs = new ArrayList<>();
		String suffix = null;
		boolean toDir = false;

		try
		{
			xsltFilePath = args[0];
			result = args[1];
			for (int i = 2; i < args.length; i++)
			{
				String arg = args[i];
				if ("-xml".equals(arg))
				{
					outputMethod = "xml";
				}
				else if ("-html".equals(arg))
				{
					outputMethod = "html";
				}
				else if ("-text".equals(arg))
				{
					outputMethod = "text";
				}
				else if ("-doctype_system".equals(arg))
				{
					docTypeSystem = args[++i];
				}
				else if ("-doctype_public".equals(arg))
				{
					docTypePublic = args[++i];
				}
				else if ("-suffix".equals(arg))
				{
					suffix = args[++i];
				}
				else if ("-dir".equals(arg))
				{
					toDir = true;
				}
				else
				{
					inputs.add(arg);
				}
			}

			final DomTransformer transformer = new DomTransformer(outputMethod, docTypeSystem, docTypePublic);
			System.err.println("XSLT: " + xsltFilePath);
			System.err.println("METH: " + (outputMethod == null ? "default" : outputMethod));

			if (toDir && !"-".equals(result))
			{
				final File dir = new File(result);
				if (!dir.exists())
					dir.mkdirs();
				System.err.println("DIR:  " + dir);
				for (String sourceFilePath : inputs)
				{
					String destFileName = new File(sourceFilePath).getName();
					if (suffix != null)
					{
						if (destFileName.indexOf('.') == -1)
							destFileName += suffix;
						else
							destFileName = destFileName.replaceFirst("(\\..*)$", suffix + "$1");
					}

					final String destFilePath = new File(dir, destFileName).getCanonicalPath();
					System.err.println("XFRM: " + sourceFilePath + " -> " + destFilePath);
					transformer.fileToFile(sourceFilePath, destFilePath, xsltFilePath);
				}
			}
			else
			{
				System.err.println("OUT:  " + result);

				// out
				final boolean isFile = !"-".equals(result);
				if (isFile)
				{
					File file = new File(result);
					if (file.exists())
						file.delete();
				}

				final StreamResult streamResult = isFile ? new StreamResult(new FileWriter(result)) : new StreamResult(System.out);
				for (String sourceFilePath : inputs)
				{
					System.err.println("XFRM: " + sourceFilePath + " -> " + result);
					transformer.fileToStreamResult(sourceFilePath, streamResult, xsltFilePath);
				}
			}
		}
		catch (final ArrayIndexOutOfBoundsException e)
		{
			System.err.println("Usage: <xslt file> <result> (-dir)(-suffix suffix) (-html|-xml|-text) (-doctype_system id) (-doctype_public id) <source file>*");
		}
		catch (final Throwable e)
		{
			e.printStackTrace();
		}
		System.err.println("Done");
	}
}
