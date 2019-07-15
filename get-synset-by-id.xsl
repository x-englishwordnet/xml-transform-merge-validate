<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
	<xsl:output method="text" indent="yes" />

	<!--  -->
	<xsl:comment>
	ID methods require &lt;!DOCTYPE LexicalResource SYSTEM "http://globalwordnet.github.io/schemas/WN-LMF-relaxed-1.0.dtd"&gt;
	</xsl:comment>
	
	<xsl:variable name='debug' select='true()' />

	<xsl:key name='find-synset' match='//Synset' use='@id'></xsl:key>

	<xsl:template match="/">
		<xsl:call-template name="get-synset-by-id">
			<xsl:with-param name='synset_id'>
				<xsl:value-of select="'ewn-01115676-s'" />
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="get-synset-by-key">
			<xsl:with-param name='synset_id'>
				<xsl:value-of select="'ewn-01115676-s'" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="get-synset-by-id">
		<xsl:param name="synset_id" />

		<xsl:if test='$debug = true()'>
			<xsl:message>
				<xsl:text>[D] CALLED get-synset-by-id(synset_id=</xsl:text>
				<xsl:value-of select="$synset_id" />
				<xsl:text>)</xsl:text>
				<xsl:text>&#xa;[D]   length=</xsl:text>
				<xsl:value-of select="string-length($synset_id)" />
				<xsl:text>)</xsl:text>
			</xsl:message>
		</xsl:if>

		<xsl:variable name="synset" select="id($synset_id)" />

		<xsl:text>&#xa;[BY ID]  synset/@id </xsl:text>
		<xsl:value-of select="$synset/@id" />
		<xsl:text>&#xa;[BY ID]  synset count() </xsl:text>
		<xsl:value-of select="count($synset)" />
		<xsl:text>&#xa;[BY ID]  synset </xsl:text>
		<xsl:value-of select="$synset" />

	</xsl:template>

	<xsl:template name="get-synset-by-key">
		<xsl:param name="synset_id" />

		<xsl:if test='$debug = true()'>
			<xsl:message>
				<xsl:text>[D] CALLED get-synset-by-key(synset_id=</xsl:text>
				<xsl:value-of select="$synset_id" />
				<xsl:text>)</xsl:text>
				<xsl:text>&#xa;[D]   length=</xsl:text>
				<xsl:value-of select="string-length($synset_id)" />
				<xsl:text>)</xsl:text>
			</xsl:message>
		</xsl:if>

		<xsl:variable name="synset" select="key('find-synset', $synset_id)" />

		<xsl:text>&#xa;[BY KEY] synset/@id </xsl:text>
		<xsl:value-of select="$synset/@id" />
		<xsl:text>&#xa;[BY KEY] synset count() </xsl:text>
		<xsl:value-of select="count($synset)" />
		<xsl:text>&#xa;[BY KEY] synset </xsl:text>
		<xsl:value-of select="$synset" />

	</xsl:template>

</xsl:transform>
