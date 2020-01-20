<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">

	<xsl:import href = 'lib-sensekey.xsl' />
	<xsl:strip-space elements="*" />
	<xsl:output method="text" indent="yes" />

	<xsl:variable name='debug' select='false()' />

	<xsl:template match="/">
		<xsl:apply-templates select="//Sense" />
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>

	<xsl:template match="Sense">
		<xsl:text>&#xa;</xsl:text>
		<xsl:variable name="senseidx">
			<xsl:number />
		</xsl:variable>
		<xsl:variable name="nth" select="./@n" />

		<!--  legacy -->
		<xsl:variable name="legacy_lexid" select="substring-before(substring-after(substring-after(substring-after(./@dc:identifier,'%'),':'),':'),':')" />
		<xsl:variable name="legacy_sensekey">
			<xsl:call-template name="make-sensekey">
				<xsl:with-param name="sensenode" select="." />
				<xsl:with-param name="method" select="'legacy'" />
			</xsl:call-template>
		</xsl:variable>

		<!--  based on index of <Sense> in <LexicalEntry> -->
		<xsl:variable name="idx_sensekey">
			<xsl:call-template name="make-sensekey">
				<xsl:with-param name="sensenode" select="." />
				<xsl:with-param name="method" select="'idx'" />
			</xsl:call-template>
		</xsl:variable>

		<!--  based on ordering of 'n' attribute, floored to min value of n -->
		<xsl:variable name="nbased_sensekey">
			<xsl:call-template name="make-sensekey">
				<xsl:with-param name="sensenode" select="." />
				<xsl:with-param name="method" select="'nbased'" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:text>&#xa;sense #</xsl:text>
		<xsl:value-of select="$nth" />

		<xsl:text>&#xa;n </xsl:text>
		<xsl:value-of select="./@n" />

		<xsl:text>&#xa;pos </xsl:text>
		<xsl:value-of select="../Lemma/@partOfSpeech" />

		<xsl:text>&#xa;sense idx in lexical entry </xsl:text>
		<xsl:value-of select="format-number($senseidx - 1,'#0')" />

		<xsl:text>&#xa;checked_synset </xsl:text>
		<xsl:value-of select="id(./@synset)/@id" />

		<xsl:text>&#xa;lexfile </xsl:text>
		<xsl:value-of select="id(./@synset)/@dc:subject" />

		<xsl:text>&#xa;wn sensekey          </xsl:text>
		<xsl:value-of select="./@dc:identifier" />

		<xsl:text>&#xa;ewn legacy sensekey  </xsl:text>
		<xsl:value-of select="$legacy_sensekey" />

		<xsl:text>&#xa;ewn nbased sensekey  </xsl:text>
		<xsl:value-of select="$nbased_sensekey" />

		<xsl:text>&#xa;ewn idx sensekey     </xsl:text>
		<xsl:value-of select="$idx_sensekey" />

		<xsl:text>&#xa;legacy_equals </xsl:text>
		<xsl:value-of select="$legacy_sensekey = ./@dc:identifier" />

		<xsl:text>&#xa;nbased_equals </xsl:text>
		<xsl:value-of select="$nbased_sensekey = ./@dc:identifier" />

		<xsl:text>&#xa;idx_equals    </xsl:text>
		<xsl:value-of select="$idx_sensekey = ./@dc:identifier" />

	</xsl:template>

</xsl:transform>
