<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://hl7.org/fhir"
    xmlns:f="http://hl7.org/fhir"
    xmlns:saxon="http://saxon.sf.net/"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:output indent="yes" saxon:indent-spaces="2"/>
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Edit MP9-2 mapping to conventions at https://informatiestandaarden.nictiz.nl/wiki/FHIR:V1.0_FHIR_Profiling_Guidelines_R4#Current_implementation -->
    <xsl:template match="f:StructureDefinition/f:mapping[f:identity/@value = 'Medication-Process-v9-2-0-0']">
        <xsl:call-template name="_editMP92Mapping"/>
    </xsl:template>
    
    <!-- Add MP9-3 mapping declaration to profiles where it isn't present yet -->
    <xsl:template match="f:StructureDefinition/f:mapping[f:identity/@value = 'Medication-Process-v9-2-0-0'][not(following-sibling::*[1][self::f:mapping/f:identity/@value = 'MP9-3'])]">
        <!-- Either copy or edit following conventions at https://informatiestandaarden.nictiz.nl/wiki/FHIR:V1.0_FHIR_Profiling_Guidelines_R4#Current_implementation -->
        <!--<xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>-->
        <xsl:call-template name="_editMP92Mapping"/>
        <xsl:call-template name="_editMP93Mapping"/>
    </xsl:template>
    
    <!-- Where MP9-3 mapping is already present, update it -->
    <xsl:template match="f:StructureDefinition/f:mapping[f:identity/@value = 'MP9-3']">
        <xsl:call-template name="_editMP93Mapping"/>
    </xsl:template>
    
    <xsl:template name="_editMP92Mapping">
        <mapping>
            <identity value="mp-dataset-mp9-200-20220402" />
            <uri value="https://decor.nictiz.nl/pub/medicatieproces/mp-html-20220402T205710/ds-2.16.840.1.113883.2.4.3.11.60.20.77.1.4-2022-01-05T132845.html" />
            <name value="ART-DECOR Dataset MP9 2.0.0 20220402" />
        </mapping>
    </xsl:template>
    
    <xsl:template name="_editMP93Mapping">
        <mapping>
            <identity value="mp-dataset-mp9-300-beta1-20230217" />
            <uri value="https://decor.nictiz.nl/pub/medicatieproces/mp-html-20230217T123829/ds-2.16.840.1.113883.2.4.3.11.60.20.77.1.4-2022-06-30T000000.html" />
            <name value="ART-DECOR Dataset MP9 3.0.0-beta.1 20230217" />
        </mapping>
    </xsl:template>
    
    <xsl:template match="f:element/f:mapping[f:identity/@value = 'Medication-Process-v9-2-0-0']">
        <xsl:copy>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
        <xsl:choose>
            <!-- If this mapping is deprecated, don't add MP9-3 -->
            <xsl:when test="contains(f:comment/@value, '[DEPRECATED]')"/>
            <!-- If this mapping is already followed by an MP9-3 mapping, do nothing -->
            <xsl:when test="following-sibling::*[1][self::f:mapping/f:identity/@value = 'MP9-3']"/>
            <!-- Otherwise, add MP9-3 mapping -->
            <xsl:otherwise>
                <mapping>
                    <identity value="mp-dataset-mp9-300-20230217"/>
                    <map value="{replace(f:map/@value, 'mp-dataelement920-', 'mp-dataelement9x-')}"/>
                    <comment value="{f:comment/@value}"/>
                </mapping>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="f:element/f:mapping/f:identity[@value = 'Medication-Process-v9-2-0-0']">
        <identity value="mp-dataset-mp9-200-20220402"/>
    </xsl:template>
    
    <xsl:template match="f:element/f:mapping/f:identity[@value = 'MP9-3']">
        <identity value="mp-dataset-mp9-300-20230217"/>
    </xsl:template>
    
</xsl:stylesheet>