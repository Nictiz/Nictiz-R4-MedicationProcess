<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://hl7.org/fhir"
    xmlns:f="http://hl7.org/fhir"
    xmlns:saxon="http://saxon.sf.net/"
    exclude-result-prefixes="#all"
    version="2.0" >
    
    <xsl:output indent="yes" encoding="utf-8"/>
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:variable name="antepenultimateRelease" select="'mp-dataset-mp9-300-beta2-20231017'"/>
    <xsl:variable name="penultimateRelease" select="'mp-dataset-mp9-300-beta3-20240229'"/>
    <xsl:variable name="currentRelease" select="'mp-dataset-mp9-300-beta4-20241118'"/>
    <xsl:variable name="currentReleaseUri" select="'https://decor.nictiz.nl/pub/medicatieproces/mp-html-20241118T151205/ds-2.16.840.1.113883.2.4.3.11.60.20.77.1.4-2022-06-30T000000.html'"/>
    <xsl:variable name="currentReleaseName" select="'ART-DECOR Dataset MP9 3.0.0-beta.4 20241118'"/>
    
    <!-- Remove mapping declarations to antepenultimate release -->
    <xsl:template match="f:StructureDefinition/f:mapping[f:identity/@value = $antepenultimateRelease]"/>
    <xsl:template match="f:element/f:mapping[f:identity/@value = $antepenultimateRelease]"/>
    
    <!-- Add mapping declaration to current release in all profiles where it isn't present yet -->
    <xsl:template match="f:StructureDefinition/f:mapping[f:identity/@value = $penultimateRelease][not(following-sibling::*[1][self::f:mapping/f:identity/@value = $currentRelease])]">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
        <xsl:call-template name="_addCurrentReleaseMapping"/>
    </xsl:template>
    
    <xsl:template match="f:element/f:mapping[f:identity/@value = $penultimateRelease]">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
        <xsl:choose>
            <!-- If this mapping is deprecated, don't add mapping to current release -->
            <xsl:when test="contains(f:comment/@value, '[DEPRECATED]')"/>
            <!-- If this mapping is already followed by a mapping to current release, do nothing -->
            <xsl:when test="following-sibling::*[1][self::f:mapping/f:identity/@value = $currentRelease]"/>
            <!-- Otherwise, add mapping to current release -->
            <xsl:otherwise>
                <mapping>
                    <identity value="{$currentRelease}"/>
                    <map value="{f:map/@value}"/>
                    <comment value="{f:comment/@value}"/>
                </mapping>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="_addCurrentReleaseMapping">
        <mapping>
            <identity value="{$currentRelease}"/>
            <uri value="{$currentReleaseUri}"/>
            <name value="{$currentReleaseName}"/>
        </mapping>
    </xsl:template>
    
</xsl:stylesheet>