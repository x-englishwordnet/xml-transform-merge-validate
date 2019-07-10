package transformer;

public class XSLTTranform
{
	public static void main(final String[] theseArgs)
	{
		try
		{
			final String xsltFilePath = theseArgs[0];
			final String sourceFilePath = theseArgs[1];
			final String resultFilePath = theseArgs[2];
			boolean outputHtml = false;
			if (theseArgs.length > 3)
			{
				final String thisFlag = theseArgs[3];
				outputHtml = thisFlag.equalsIgnoreCase("html"); //$NON-NLS-1$
			}
			String dtd = null;
			if (theseArgs.length > 4)
			{
				dtd = theseArgs[4];
			}

			new DomTransformer(outputHtml, dtd).fileToFile(sourceFilePath, resultFilePath, xsltFilePath);
		}
		catch (final Throwable e)
		{
			System.err.println("Usage: <xslt file><source file><result file><html|xml|text><dtd>"); //$NON-NLS-1$
			e.printStackTrace();
		}
		System.err.println("Done");
	}
}
