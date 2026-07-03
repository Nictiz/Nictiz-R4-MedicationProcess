<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="f xs">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"></xsl:output>

    <!-- gebruik folder met de FHIR profielen als input-->
    <xsl:param name="inputDir"></xsl:param>

    <!-- output folder -->
    <xsl:param name="outputDir"></xsl:param>

    <!-- decor bestanden -->
    <xsl:param name="mpDecorInput" select="document('mp-decor.xml')"></xsl:param>
    <xsl:param name="zibDecorInput" select="document('zib2020bbr-decor.xml')"></xsl:param>

    <!-- zib prefixes -->
    <xsl:variable name="zib-prefix" as="xs:string" select="'NL-CM:'"></xsl:variable>
    <xsl:variable name="zib-oid-prefix" as="xs:string" select="'2.16.840.1.113883.2.4.3.11.60.40.1.'"></xsl:variable>

    <!-- release identity (om het makkelijk te knippen en plakken)--> 
    <xsl:variable name="release" select="'mp-dataset-mp9-300-rc3-TODO'"></xsl:variable>
    
    <!-- start inlezen profielen -->
    <xsl:template match="/">
        <xsl:for-each select="collection($inputDir)">
            <xsl:variable name="input-uri" as="xs:string" select="document-uri(.)"></xsl:variable>

            <!-- bestandsnamen-->
            <xsl:variable name="input-file-name" as="xs:string" select="replace($input-uri, '^.*/', '')"></xsl:variable>
            <xsl:variable name="base-name" as="xs:string" select="replace($input-file-name, '\.xml$', '')"></xsl:variable>

            <xsl:result-document href="{concat($outputDir, $base-name, '-nlcm-mapping.xml')}" method="xml" indent="yes" encoding="UTF-8">

                <resultaat input-bestand="{$input-file-name}">

                    <!-- code achter NL-CM uit het FHIR profiel bijvoorbeeld 9.10.19963)-->
                    <xsl:for-each select="
                            distinct-values(
                            for $map in //f:mapping/f:map[contains(@value, $zib-prefix)]
                            return
                                replace(
                                $map/@value,
                                concat('^.*', $zib-prefix, '([0-9.]+).*$'),
                                '$1'
                                )
                            )
                            ">


                        <!-- schrijf code weg als variabele  $code -->
                        <xsl:variable name="code" as="xs:string" select="."></xsl:variable>
                        <!-- maak volledig zib concept id om te kunnen zoeken in mp-decor en zib2020-decor-->
                        <xsl:variable name="zib_concept_id" as="xs:string" select="concat($zib-oid-prefix, $code)"></xsl:variable>

                        <!-- vind het concept in mp-decor.xml dat via SPEC-relatie verwijst naar het zib concept id -->
                        <xsl:variable name="mp-concepts" select="
                                $mpDecorInput//concept[
                                relationship[@type = 'SPEC' and @ref = $zib_concept_id]
                                ]"></xsl:variable>

                        
                        <concept>
                            <xsl:for-each select="$mp-concepts">
                                <!-- schrijf mp-concept weg als variabele -->
                                <xsl:variable name="mp-concept" select="."></xsl:variable>
                                <!-- pak het laatste getal achter de laatste punt van mp-decor concept/@id om "mp-dataelement9x-" te maken die in map/@value terechtkomt-->
                                <xsl:variable name="mp-element-9x-id" as="xs:string" select="replace($mp-concept/@id, '^.*\.([0-9]+)$', '$1')"></xsl:variable>
                                <xsl:variable name="name_eng" select="$mp-concept/name[@language = 'en-US'][1]"></xsl:variable>

                                <!-- oude mapping info -->
                                <old_mapping>
                                    <xsl:attribute name="name" select="$mp-concept/name[@language = 'nl-NL'][1]"></xsl:attribute>
                                    <xsl:attribute name="code" select="$code"></xsl:attribute>
                                    <!-- volledig zib id dat in ref staat en waarmee er naar een "SPEC" relationship wordt gezocht -->
                                    <xsl:attribute name="zib_concept" select="$zib_concept_id"></xsl:attribute>
                                </old_mapping>
                                <!-- nieuwe mp mapping --> 
                                <mapping>
                                    <identity>
                                        <xsl:attribute name="value" select="$release"></xsl:attribute>
                                    </identity>
                                    <map>
                                        <xsl:attribute name="value" select="concat('mp-dataelement9x-', $mp-element-9x-id)"></xsl:attribute>
                                    </map>
                                    <comment>
                                        <xsl:value-of select="$name_eng"></xsl:value-of>
                                    </comment>
                                </mapping>
                            </xsl:for-each>

                            <!-- GEEN relationship[@type="SPEC" mogelijk -->
                            <!-- dus relatie vinden via inherit + in zibdecor.xml -->
                            <xsl:if test="empty($mp-concepts)">
                                <melding>geen relationship[@type='SPEC'] voor <xsl:value-of select="."></xsl:value-of> </melding>

                                <!-- vind concept in zibdecor.xml (aanname dat dit er maar 1 is)-->
                                <xsl:variable name="zib-concept" select="$zibDecorInput//concept[@id = $zib_concept_id]"></xsl:variable>

                                <!-- vind concepten obv inherit -->
                                <xsl:variable name="mp-inherit-concepts" select="
                                        $mpDecorInput//concept[
                                        inherit[@ref = $zib_concept_id]
                                        ]"></xsl:variable>


                                <!-- sommige zib concepten komen helemaal _niet_ voor in mp-decor en alleen in zib2020-decor-->
                                <!-- de choose hieronder kijkt eerst of er wel een inherit mogelijk is -->
                                <xsl:choose>
                                    <xsl:when test="$mp-inherit-concepts">
                                        <xsl:for-each select="$mp-inherit-concepts">
                                            <xsl:variable name="mp-inherit-concept" select="."></xsl:variable>
                                            <!-- pak het laatste getal achter de laatste punt van mp-decor concept/@id om "mp-dataelement9x-" te maken die in map/@value terechtkomt -->
                                            <xsl:variable name="mp-element-9x-id" as="xs:string" select="replace($mp-inherit-concept/@id, '^.*\.([0-9]+)$', '$1')"></xsl:variable>

                                            <!-- check of de inherit naar een concept met MP9 3.0.0 versionLabel is -->
                                            <xsl:variable name="check_inherit" select="$mpDecorInput//concept[inherit/@ref = $mp-inherit-concept/@id and @versionLabel = 'MP9 3.0.0-rc']"></xsl:variable>
                                            <xsl:choose>
                                                <xsl:when test="$check_inherit">
                                                    <melding>maar wél een inherit gevonden naar MP9 3.0.0-rc in mp-decor.xml</melding>
                                                    <xsl:variable name="name_eng" select="$zib-concept/name[@language = 'en-US'][1]"></xsl:variable>
                                                    <old-mapping>
                                                        <xsl:attribute name="name" select="$zib-concept/name[@language = 'nl-NL'][1]"></xsl:attribute>
                                                        <xsl:attribute name="code" select="$code"></xsl:attribute>
                                                        <!-- volledig zib id waarmee er naar de inherit mee wordt gezocht -->
                                                        <xsl:attribute name="zib_concept" select="$zib_concept_id"></xsl:attribute>


                                                        <mapping>

                                                            <!-- Laatste getal achter de punt van het mp-decor concept/@id -->
                                                            <identity>
                                                                <xsl:attribute name="value" select="$release"></xsl:attribute>
                                                            </identity>
                                                            <map>
                                                                <xsl:attribute name="value" select="concat('mp-dataelement9x-', $mp-element-9x-id)"></xsl:attribute>
                                                            </map>
                                                            <comment>
                                                                <xsl:value-of select="$name_eng"></xsl:value-of>
                                                            </comment>
                                                        </mapping>
                                                    </old-mapping>
                                                </xsl:when>
                                                <!-- het concept verwijst niet naar een MP9.3 concept -->
                                                <xsl:otherwise>
                                                    <error>Controleer mp-decor.xml! Inherit naar een concept uit MP9 3.0.0-rc bestaat niet!</error>
                                                </xsl:otherwise>
                                            </xsl:choose>




                                        </xsl:for-each>
                                    </xsl:when>
                                    <!-- geen inherit en hoeft niet opgelost te worden omdat het waarschijnlijk geen medicatiebouwsteen is-->
                                    <xsl:otherwise>
                                        <melding>geen inherit in mp-decor.xml voor <xsl:value-of select="$zib-concept/name[@language = 'nl-NL'][1]"></xsl:value-of></melding>


                                    </xsl:otherwise>
                                </xsl:choose>


                            </xsl:if>
                        </concept>
                    </xsl:for-each>

                </resultaat>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
