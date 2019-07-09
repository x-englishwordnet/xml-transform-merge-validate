package transformer;

public class Main
{
	public static void main(final String[] theseArgs)
	{
		try
		{
			final String thisSourceFilePath = theseArgs[0];
			final String thisResultFilePath = theseArgs[1];
			final String thisXsltFilePath = theseArgs[2];
			boolean outputHtml = false;
			if (theseArgs.length > 3)
			{
				final String thisFlag = theseArgs[3];
				outputHtml = thisFlag.equalsIgnoreCase("html"); //$NON-NLS-1$
			}
			String thisDtd = null;
			if (theseArgs.length > 4)
			{
				thisDtd = theseArgs[4];
			}

			new DomTransformer(outputHtml, thisDtd).fileToFile(thisSourceFilePath, thisResultFilePath, thisXsltFilePath);
		}
		catch (final Throwable e)
		{
			System.err.println("Usage: <source file><result file><xslt file><html|xml|text><dtd>"); //$NON-NLS-1$
			e.printStackTrace();
		}
		System.out.println("Done");
	}
}
