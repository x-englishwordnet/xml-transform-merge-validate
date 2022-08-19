<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="https://globalwordnet.github.io/schemas/dc/">

	<xsl:output omit-xml-declaration="no" standalone="no" method="xml" version="1.1" encoding="UTF-8" indent="yes" />
	<xsl:strip-space elements="*" />

	<xsl:variable name="debug" select="false()" />
	<xsl:variable name="apos">
		'
	</xsl:variable>

	<xsl:template match="/">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="LexicalResource">
		<LexicalResource xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation=". https://x-englishwordnet.github.io/schemas/1.10/xEWN-LMF-1.10-relax_idrefs.xsd" xmlns:dc="https://globalwordnet.github.io/schemas/dc/">
			<xsl:apply-templates select="./*" />
		</LexicalResource>
	</xsl:template>

	<xsl:template match="Sense">
		<xsl:variable name="id0" select="substring-after(@id,'oewn-')" />
		<xsl:variable name="lemma0" select="substring-before($id0,'__')" />
		<xsl:variable name="lemma1" select="replace($lemma0,'-ap-',$apos)" />
		<xsl:variable name="lemma2" select="replace($lemma1,'-lb-','(')" />
		<xsl:variable name="lemma3" select="replace($lemma2,'-rb-',')')" />
		<xsl:variable name="lemma4" select="replace($lemma3,'-cm-',',')" />
		<xsl:variable name="lemma5" select="replace($lemma4,'-ex-','!')" />
		<xsl:variable name="lemma6" select="replace($lemma5,'-pl-','+')" />
		<xsl:variable name="lemma" select="replace($lemma6,'-sl-','/')" />

		<xsl:if test="$debug = true()">
			<xsl:message>
				<xsl:text>stripped id </xsl:text>
				<xsl:value-of select="$id0" />
			</xsl:message>
			<xsl:message>
				<xsl:text>lemma </xsl:text>
				<xsl:value-of select="$lemma0" />
			</xsl:message>
			<xsl:message>
				<xsl:text>ap </xsl:text>
				<xsl:value-of select="$lemma1" />
			</xsl:message>
			<xsl:message>
				<xsl:text>lb </xsl:text>
				<xsl:value-of select="$lemma2" />
			</xsl:message>
			<xsl:message>
				<xsl:text>rb </xsl:text>
				<xsl:value-of select="$lemma3" />
			</xsl:message>
			<xsl:message>
				<xsl:text>cm </xsl:text>
				<xsl:value-of select="$lemma4" />
			</xsl:message>
			<xsl:message>
				<xsl:text>ex </xsl:text>
				<xsl:value-of select="$lemma5" />
			</xsl:message>
			<xsl:message>
				<xsl:text>sl </xsl:text>
				<xsl:value-of select="$lemma" />
			</xsl:message>
		</xsl:if>

		<xsl:variable name="sk" select="concat($lemma,'%',translate(substring-after($id0,'__'),'.',':'))" />

		<!-- '-%04x-' % ord(c) -->

		<xsl:copy>
			<xsl:apply-templates select="@*" />

			<xsl:attribute name="sensekey">
				<xsl:value-of select="$sk" />
			</xsl:attribute>

			<xsl:apply-templates select="node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

</xsl:transform>
