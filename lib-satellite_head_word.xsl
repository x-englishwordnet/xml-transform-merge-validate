<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (c) 2019. Bernard Bou <1313ou@gmail.com>. -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/">

	<xsl:variable name='debug' select='false()' />
	<xsl:variable name='error' select='true()' />

	<!-- S A T E L L I T E - H E A D - F A C T O R Y -->

	<xsl:template name="make-satellite-head-word">
		<xsl:param name="sensenode" />
		<xsl:param name="pos" />

		<xsl:if test='$debug = true()'>
			<xsl:message>
				<xsl:text>[D] CALLED make-satellite-head-word(sensenode_id=</xsl:text>
				<xsl:value-of select="$sensenode/@id" />
				<xsl:text>, pos=</xsl:text>
				<xsl:value-of select="$pos" />
				<xsl:text>)</xsl:text>
			</xsl:message>
		</xsl:if>

		<!-- SATELLITE HEAD -->
		<xsl:choose>
			<xsl:when test="$pos != 's'">
				<xsl:message>
					<xsl:text>[D]   not a satellite</xsl:text>
					<xsl:text>&#xa;</xsl:text>
				</xsl:message>
				<xsl:value-of select="''" />
			</xsl:when>

			<xsl:otherwise>
				<xsl:variable name="synset_id" select="$sensenode[1]/@synset" />
				<xsl:variable name="synset" select="id($synset_id)" />
				<xsl:variable name="head_synset_id" select="$synset[1]/SynsetRelation[@relType='similar']/@target" />
				<xsl:variable name="head_senses" select="//Sense[@synset=$head_synset_id]" />
				<!-- HEAD WORD : "the lemma of the sense which has an antonymy relation" /> -->
				<xsl:variable name="lemma" select="$head_senses[SenseRelation/@relType = 'antonym' ]/../Lemma/@writtenForm" />
				<xsl:variable name="headword">
					<xsl:choose>
						<xsl:when test="$lemma != ''">
							<xsl:value-of select="translate($lemma,' ','_')" />
						</xsl:when>
						<xsl:otherwise>
							<!-- HEAD WORD : "the lemma of the first word of the satellite's head synset" /> -->
							<xsl:variable name="lemma2" select="$head_senses[1]/../Lemma/@writtenForm" />
							<xsl:message>
								<xsl:text>[W]   no indirect antonym found for </xsl:text>
								<xsl:value-of select="$sensenode/@id" />
								<xsl:text> taking first of </xsl:text>
								<xsl:value-of select="count($head_senses)" />
								<xsl:text> head synset member(s) </xsl:text>
							</xsl:message>
							<xsl:value-of select="translate($lemma2,' ','_')" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:if test='$debug = true()'>
					<xsl:message>
						<xsl:text>[D]   synset_id </xsl:text>
						<xsl:value-of select="$synset_id" />
						<xsl:text>&#xa;[D]   its fetched synset </xsl:text>
						<xsl:value-of select="$synset" />
						<xsl:text>&#xa;[D]   its fetched synset count() </xsl:text>
						<xsl:value-of select="count($synset)" />
						<xsl:text>&#xa;[D]   its fetched synset/@id </xsl:text>
						<xsl:value-of select="$synset/@id" />
						<xsl:text>&#xa;[D]   head_synset_id </xsl:text>
						<xsl:value-of select="$head_synset_id" />
						<xsl:text>&#xa;[D]   head_senses[1].@id </xsl:text>
						<xsl:value-of select="$head_senses[1]/@id" />
						<xsl:text>&#xa;[D]   lemma </xsl:text>
						<xsl:value-of select="$lemma" />
						<xsl:text>&#xa;[D]   headword=</xsl:text>
						<xsl:value-of select="$headword" />
					</xsl:message>
				</xsl:if>
				<xsl:if test="$headword = '' and $error = true()">
					<xsl:message>
						<xsl:text>[E]   head not found for '</xsl:text><xsl:value-of select="$sensenode/@id" /><xsl:text>' head synset is '</xsl:text><xsl:value-of select="$head_synset_id" /><xsl:text>'</xsl:text>
					</xsl:message>
				</xsl:if>

				<xsl:value-of select="$headword" />
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- I S - S A T E L L I T E - H E A D - T E S T -->

	<xsl:template name="is-satellite-head">
		<xsl:param name="sensenode" />

		<xsl:variable name="is_a" select="$sensenode[1]/../Lemma/@partOfSpeech='a'" />
		<xsl:variable name="antonym_relation" select="$sensenode/SenseRelation[@relType='antonym']" />
		<xsl:variable name="is_head" select="$antonym_relation/@target != '' and $is_a" />

		<xsl:if test='$debug = true()'>
			<xsl:message>
				<xsl:text>[D] CALLED is-satellite-head(sensenode_id=</xsl:text>
				<xsl:value-of select="$sensenode/@id" />
				<xsl:text>)</xsl:text>
				<xsl:text>&#xa;[D]   antonym_relation </xsl:text><xsl:value-of select="$antonym_relation/@target" />
				<xsl:text>&#xa;[T]   is a '</xsl:text><xsl:value-of select="$is_a" /><xsl:text>'</xsl:text>
				<xsl:text>&#xa;[T]   is head '</xsl:text><xsl:value-of select="$is_head" /><xsl:text>'</xsl:text>
			</xsl:message>
		</xsl:if>

		<xsl:value-of select="$is_head" />
	</xsl:template>

</xsl:transform>
