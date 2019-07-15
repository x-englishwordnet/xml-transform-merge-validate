<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:strip-space elements="*" />
	<xsl:output method="text" />

	<xsl:variable name='debug' select='false()' />

	<xsl:template match="/">
		<xsl:call-template name='dummy'>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name='dummy'>
		<xsl:message>
			<xsl:text>debug=</xsl:text>
			<xsl:value-of select='$debug' />
		</xsl:message>
	</xsl:template>

</xsl:transform>
