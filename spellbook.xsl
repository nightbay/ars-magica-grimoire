<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:java="http://xml.apache.org/xslt/java"
  exclude-result-prefixes="java" xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:param name="single" select="''"/>
  <xsl:param name="edit" select="''"/>
  <xsl:param name="cover" select="'true'"/>
  <xsl:param name="orientation" select="'portrait'"/>
  <xsl:param name="paper" select="'letter'"/>
  <xsl:param name="source" select="'true'"/>
  
  <xsl:output method="xml" indent="yes" />

  <xsl:include href="file:./pagesetup.xsl"/>
  
  <xsl:variable name="in" select="/" />
  <xsl:variable name="sortedspells">
    <xsl:for-each select="$in/ars_magica/spells/spell">
      <xsl:sort select="name"/>
      <xsl:copy-of select="current()"/>
    </xsl:for-each>
  </xsl:variable>
  
  <xsl:variable name="sortedartifacts">
    <xsl:for-each select="$in/ars_magica/artifacts/artifact">
      <xsl:sort select="name"/>
      <xsl:copy-of select="current()"/>
    </xsl:for-each>
  </xsl:variable>
  
  <xsl:variable name="spellsbybook">
    <xsl:for-each select="$in/ars_magica/spells/spell[name != '']">
      <xsl:sort select="@source"/>
      <xsl:sort select="@page" data-type="number"/>
      <xsl:sort select="name"/>
      <xsl:copy-of select="current()"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:include href="file:./styles.xsl"/>

  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="inner-leaf" page-height="{$height}" page-width="{$width}">
          <fo:region-body margin="2cm" margin-right="2cm" />
          <fo:region-before region-name="xsl-region-before" extent="3in"/>
          <fo:region-after region-name="xsl-region-after" extent=".25in" />
        </fo:simple-page-master>

        <fo:simple-page-master master-name="form-notes" page-height="{$height}" page-width="{$width}">
          <fo:region-body column-count="{$textcols}" margin="2cm"/>
          <fo:region-before region-name="xsl-region-before" margin-top="0in" extent="3in" />
          <fo:region-after region-name="xsl-region-after" extent=".5in" />
        </fo:simple-page-master>

        <fo:simple-page-master master-name="arts-guideline" page-height="{$height}" page-width="{$width}">
          <fo:region-body column-count="{$cols}" margin="2cm"/>
          <fo:region-before region-name="xsl-region-before" extent="1.9cm" />
          <fo:region-after region-name="xsl-region-after" extent=".5in" />
        </fo:simple-page-master>

        <fo:simple-page-master master-name="spell-list" page-height="{$height}" page-width="{$width}">
          <fo:region-body column-count="{$cols}" margin-bottom="0.5in"  margin-top="0.5in" margin-left="2cm" margin-right="2cm"/>
          <fo:region-before region-name="xsl-region-before" extent=".5in" />
          <fo:region-after region-name="xsl-region-after" extent=".5in" margin-right="2cm"/>
        </fo:simple-page-master>
      
        <fo:simple-page-master master-name="artifact-list" page-height="{$height}" page-width="{$width}">
          <fo:region-body column-count="{$tablecols}" margin-bottom="0.5in"  margin-top="0.5in" margin-left="2cm" margin-right="2cm"/>
          <fo:region-before region-name="xsl-region-before" extent=".5in" />
          <fo:region-after region-name="xsl-region-after" extent=".5in" margin-right="2cm"/>
        </fo:simple-page-master>
		
      </fo:layout-master-set>

      <xsl:if test="$cover = 'true'">
        <fo:page-sequence master-reference="inner-leaf">
          <xsl:if test="$edit = ''">
            <fo:static-content flow-name="xsl-region-before">
              <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
                <fo:block>
                  <fo:external-graphic src="images/leaflet{$wide}.jpg" content-height="scale-to-fit" height="{$height}" content-width="{$width}" scaling="non-uniform"/>
                </fo:block>
              <fo:block></fo:block>
              </fo:block-container>
            </fo:static-content>
          </xsl:if>
          <fo:static-content flow-name="xsl-region-after"><fo:block></fo:block></fo:static-content>
          <fo:flow flow-name="xsl-region-body">
            <xsl:apply-templates select="$in/ars_magica/preface" mode="preface"/>
         </fo:flow>
        </fo:page-sequence>
      </xsl:if>

      <xsl:for-each select="/ars_magica/arts/form/name">
        <xsl:variable name="form" select="."/>
        <xsl:if test="($single = '' ) or ($single = .)">
          <xsl:call-template name="form-notes">
            <xsl:with-param name="form" select="$form"/>
          </xsl:call-template>
          <xsl:for-each select="/ars_magica/arts/technique/name">
            <xsl:variable name="technique" select="."/>
            <xsl:call-template name="art-guidelines">
              <xsl:with-param name="form" select="$form"/>
              <xsl:with-param name="technique" select="$technique"/>
            </xsl:call-template>

            <xsl:call-template name="spellblock">
              <xsl:with-param name="form" select="$form"/>
              <xsl:with-param name="technique" select="$technique"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each>
	  
      <xsl:call-template name="artifacts"></xsl:call-template>
      <xsl:call-template name="spellindex"></xsl:call-template>
      <xsl:call-template name="bookindex"></xsl:call-template>
	  <xsl:call-template name="artifactindex"></xsl:call-template>
      <xsl:call-template name="smbonuses"></xsl:call-template>


    </fo:root>
  </xsl:template>

  <xsl:template name="form-notes">
    <xsl:param name="form"/>

    <fo:page-sequence master-reference="form-notes">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
            <fo:block>
              <fo:external-graphic src="images/{$form}-paper{wide}.jpg"  content-height="scale-to-fit" height="{$height}"  content-width="{$width}" scaling="non-uniform"/>
            </fo:block>
          </fo:block-container>
        </xsl:if>
        <fo:block></fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block color="{$handcolour}" text-align-last="justify" font-family="{$textfont}" font-size="8pt" font-weight="normal" margin-left="2cm" margin-right="2cm">
          <fo:page-number/><fo:leader leader-pattern="space" />
		  <xsl:value-of select="$form"/><xsl:text> </xsl:text>
          <fo:external-graphic  vertical-align="middle" src="images/forms/{$form}_symbol.png" width="8pt"  content-height="scale-to-fit" height="8pt"  content-width="scale-to-fit" scaling="non-uniform"/>				  
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <fo:block id="{$form}" text-align="center" font-family="{$artfont}" font-size="24pt" font-weight="normal">
          <fo:external-graphic  vertical-align="middle" src="images/forms/{$form}_symbol.png"  content-height="scale-to-fit" height="24pt" width="24pt" content-width="scale-to-fit" scaling="non-uniform"/>
		  <xsl:text> </xsl:text>
          <xsl:value-of select="$form"/>
        </fo:block>
        <xsl:apply-templates select="/ars_magica/arts/form[name = $form]/description/p" mode="notes"/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:template name="art-guidelines">
    <xsl:param name="form"/>
    <xsl:param name="technique"/>
    <xsl:param name="toc_key"><xsl:value-of select="$technique"/> <xsl:value-of select="$form"/></xsl:param>

    <fo:page-sequence master-reference="arts-guideline">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
            <fo:block>
              <fo:external-graphic src="images/{$form}-paper{$wide}.jpg" content-height="scale-to-fit" height="{$height}" content-width="{$width}" scaling="non-uniform"/>
            </fo:block>
          </fo:block-container>
        </xsl:if>
        <fo:block></fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block color="{$handcolour}" text-align-last="justify" font-family="{$artfont}" font-size="8pt" font-weight="normal" margin-left="2cm" margin-right="2cm">
          <fo:page-number/><fo:leader leader-pattern="space" />
		  <fo:external-graphic  vertical-align="middle" src="images/techniques/{$technique}_symbol.png" width="8pt"  content-height="scale-to-fit" height="8pt"  content-width="scale-to-fit" scaling="non-uniform"/>				  
		  <xsl:value-of select="$technique"/><xsl:text> </xsl:text><xsl:value-of select="$form"/>
          <xsl:text> </xsl:text>
		  <fo:external-graphic  vertical-align="middle" src="images/forms/{$form}_symbol.png" width="8pt"  content-height="scale-to-fit" height="8pt"  content-width="scale-to-fit" scaling="non-uniform"/>				  
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <fo:block  span="all" id="{$toc_key}" text-align="center" color="{$handcolour}" font-family="{$artfont}" font-size="18pt" font-weight="normal" margin-bottom="2mm">
		  <fo:external-graphic  vertical-align="middle" src="images/techniques/{$technique}_symbol.png"  content-height="scale-to-fit" height="18pt" width="18pt" content-width="scale-to-fit" scaling="non-uniform"/>
          Linee guida di <xsl:value-of select="$technique"/><xsl:text> </xsl:text><xsl:value-of select="$form"/>
		  <xsl:text> </xsl:text>
		  <fo:external-graphic  vertical-align="middle" src="images/forms/{$form}_symbol.png"  content-height="scale-to-fit" height="18pt" width="18pt"  content-width="scale-to-fit" scaling="non-uniform"/>
        </fo:block>
        <xsl:apply-templates select="/ars_magica/arts_guidelines/arts_guideline[arts/form=$form and arts/technique=$technique]/description/p" mode="guideline"/>
        <fo:block space-before="3pt" font-size="8pt"><xsl:text> </xsl:text></fo:block>
        <xsl:if test="count(/ars_magica/arts_guidelines/arts_guideline[arts/form=$form and arts/technique=$technique]/guidelines/guideline) &gt; 0">
          <fo:table>
            <fo:table-body>
              <xsl:for-each select="/ars_magica/arts_guidelines/arts_guideline[arts/form=$form and arts/technique=$technique]/guidelines/guideline">
                <fo:table-row table-layout="fixed">
                  <fo:table-cell width="4.2em">
                    <fo:block font-size="8pt">
                      <xsl:if test="not(preceding-sibling::*[1]/level = level)">
                        <xsl:if test="level != 'Generico'">Livello </xsl:if><xsl:value-of select="level"/>
                      </xsl:if>
                    </fo:block>
                  </fo:table-cell>    
                  <fo:table-cell>
                    <fo:block text-indent="-1em" font-size="8pt">
                      <xsl:if test="@mystery='true'"><fo:inline font-style="italic">Misterico </fo:inline></xsl:if>
                      <xsl:if test="@ritual='true'"><fo:inline font-style="italic">Rituale </fo:inline></xsl:if>
                      <xsl:if test="@faerie='true'"><fo:inline font-style="italic">Fatato </fo:inline></xsl:if>
                      <xsl:if test="@atlantean='true'"><fo:inline font-style="italic">Atlantideo </fo:inline></xsl:if>
                      <xsl:apply-templates select="description" mode="guideline-notes"/><xsl:call-template name="source"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:for-each>
            </fo:table-body>
          </fo:table>
        </xsl:if>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:template match="description" mode="guideline-notes">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template name="spellblock">
    <xsl:param name="form"/>
    <xsl:param name="technique"/>
    <fo:page-sequence master-reference="spell-list">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
            <fo:block>
              <fo:external-graphic src="images/{$form}-paper{$wide}.jpg"  content-height="scale-to-fit" height="{$height}"  content-width="{$width}" scaling="non-uniform"/>
            </fo:block>
          </fo:block-container>
        </xsl:if>
        <fo:block></fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block color="{$handcolour}" text-align-last="justify" font-family="{$artfont}" font-size="8pt" font-weight="normal" margin-left="2cm" margin-right="2cm">
          <fo:page-number/><fo:leader leader-pattern="space" />
		    <fo:external-graphic  vertical-align="middle" src="images/techniques/{$technique}_symbol.png" width="8pt"  content-height="scale-to-fit" height="8pt"  content-width="scale-to-fit" scaling="non-uniform"/>		
		    <xsl:value-of select="$technique"/><xsl:text> </xsl:text><xsl:value-of select="$form"/>
		    <fo:external-graphic  vertical-align="middle" src="images/forms/{$form}_symbol.png" width="8pt"  content-height="scale-to-fit" height="8pt"  content-width="scale-to-fit" scaling="non-uniform"/>		
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <fo:block text-align="center" span="all" font-family="{$artfont}" font-size="12pt" margin-bottom="8px" font-weight="normal">
          <fo:external-graphic  vertical-align="middle" src="images/techniques/{$technique}_symbol.png" width="12pt"  content-height="scale-to-fit" height="12pt"  content-width="scale-to-fit" scaling="non-uniform"/>		
		  Incantesimi <xsl:value-of select="$technique"/><xsl:text> </xsl:text><xsl:value-of select="$form"/><xsl:text> </xsl:text>
          <fo:external-graphic  vertical-align="middle" src="images/forms/{$form}_symbol.png" width="12pt" content-height="scale-to-fit" height="12pt"  content-width="scale-to-fit" scaling="non-uniform"/>		
		</fo:block>
        <xsl:variable name="generalspells" select="$in/ars_magica/spells/spell[arts/technique=$technique and arts/form=$form and level='GENERICO']"/>
        <xsl:variable name="spells" select="$in/ars_magica/spells/spell[arts/technique=$technique and arts/form=$form and level != 'GENERICO']"/>
        <xsl:variable name="levels" select="distinct-values($spells/level)"/>

        <xsl:if test="count($generalspells) &gt; 0">
          <fo:block keep-with-next.within-page="always" font-size="9pt" font-family="{$textfont}" margin-bottom="0.2em">GENERICO</fo:block>
          <xsl:call-template name="spells-at-level">
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="technique" select="$technique"/>
            <xsl:with-param name="level" select="'GENERICO'"/>
          </xsl:call-template>
          <fo:block margin-bottom="4px"> </fo:block>
        </xsl:if>
        <xsl:for-each select="$levels">
          <xsl:sort select="." data-type="number"/>
          <xsl:variable name="slevel" select="."/>
          <fo:block keep-with-next.within-page="always" font-size="9pt" font-family="{$textfont}" margin-bottom="0.2em">LIVELLO <xsl:value-of select="$slevel"/></fo:block>
          <xsl:call-template name="spells-at-level">
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="technique" select="$technique"/>
            <xsl:with-param name="level" select="$slevel"/>
          </xsl:call-template>
          <fo:block margin-bottom="4px"> </fo:block>
        </xsl:for-each>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:include href="file:./core.xsl"/>
 
  <xsl:template match="toc" mode="preface">
    <fo:block page-break-before="always"/>
    <xsl:for-each select="$in/ars_magica/arts/form">
      <xsl:variable name="form" select="name"/>

      <fo:block font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
        <fo:basic-link internal-destination="{$form}">
          <xsl:value-of select="$form" />
          <fo:leader leader-pattern="dots" />
          <fo:page-number-citation ref-id="{$form}" />
        </fo:basic-link>
      </fo:block>
      <xsl:for-each select="$in/ars_magica/arts/technique">
        <xsl:variable name="technique" select="name"/>
        <xsl:variable name="toc_key"><xsl:value-of select="$technique"/> <xsl:value-of select="$form"/></xsl:variable>
        <fo:block span="all" margin-left="1em" font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
          <fo:basic-link internal-destination="{$toc_key}">
            <xsl:value-of select="$technique" />
            <fo:leader leader-pattern="dots" />
            <fo:page-number-citation ref-id="{$toc_key}" />
          </fo:basic-link>
        </fo:block>
      </xsl:for-each>
    </xsl:for-each>
    <fo:block margin-top="0.5em" font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
      <fo:basic-link internal-destination="spell_index">
        Indice Incantesimi<fo:leader leader-pattern="dots" /><fo:page-number-citation ref-id="spell_index" />
      </fo:basic-link>
    </fo:block>
    <fo:block margin-top="0.5em" font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
      <fo:basic-link internal-destination="book_index">
        Incantesimi per Libro<fo:leader leader-pattern="dots" /><fo:page-number-citation ref-id="book_index" />
      </fo:basic-link>
    </fo:block>
    <fo:block span="all" margin-top="0.5em" font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
      <fo:basic-link internal-destination="artifacts">
        Artefatti Magici<fo:leader leader-pattern="dots" /><fo:page-number-citation ref-id="artifacts" />
      </fo:basic-link>
    </fo:block>	
    <fo:block margin-top="0.5em" font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
      <fo:basic-link internal-destination="artifact_index">
        Indice Artefatti<fo:leader leader-pattern="dots" /><fo:page-number-citation ref-id="artifact_index" />
      </fo:basic-link>
    </fo:block>
    <fo:block margin-top="0.5em" font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
      <fo:basic-link internal-destination="smbonuses">
        Bonus Foggia e Materiale<fo:leader leader-pattern="dots" /><fo:page-number-citation ref-id="smbonuses" />
      </fo:basic-link>
    </fo:block>
  </xsl:template>
 
  <xsl:template name="smbonuses">
    <fo:page-sequence master-reference="artifact-list">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
            <fo:block>
              <fo:external-graphic src="images/index-paper{$wide}.jpg" content-height="scale-to-fit" height="{$height}" content-width="{$width}" scaling="non-uniform"/>
            </fo:block>
          </fo:block-container>
        </xsl:if>
        <fo:block id="smbonuses">
          <fo:inline-container vertical-align="top" inline-progression-dimension="49.9%">
            <fo:block></fo:block>
          </fo:inline-container>
          <fo:inline-container vertical-align="top" inline-progression-dimension="49.9%">
            <fo:block></fo:block>
          </fo:inline-container>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block color="{$handcolour}" text-align-last="justify" font-family="{$textfont}" font-size="8pt" font-weight="normal" margin-left="2cm" margin-right="2cm">
          <fo:page-number/><fo:leader leader-pattern="space" /> 
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <fo:block text-align="center" span="all" keep-with-next.within-page="always" font-family="{$artfont}" font-size="14pt" font-weight="normal" margin-top="0.5em">
          Bonus Foggia e Materiale
        </fo:block>
        <xsl:apply-templates select="$in/ars_magica/sm_bonuses/sm[@name != '']">
          <xsl:sort select="@name"/> 
        </xsl:apply-templates>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:template name="artifacts">
    <fo:page-sequence master-reference="spell-list">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
            <fo:block>
              <fo:external-graphic src="images/index-paper{$wide}.jpg" content-height="scale-to-fit" height="{$height}" content-width="{$width}" scaling="non-uniform"/>
            </fo:block>
          </fo:block-container>
        </xsl:if>
        <fo:block id="artifacts">
          <fo:inline-container vertical-align="top" inline-progression-dimension="49.9%">
            <fo:block></fo:block>
          </fo:inline-container>
          <fo:inline-container vertical-align="top" inline-progression-dimension="49.9%">
            <fo:block></fo:block>
          </fo:inline-container>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block color="{$handcolour}" text-align-last="justify" font-family="{$textfont}" font-size="8pt" font-weight="normal" margin-left="2cm" margin-right="2cm">
          <fo:page-number/><fo:leader leader-pattern="space" /> 
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <fo:block text-align="center" span="all" keep-with-next.within-page="always" font-family="{$artfont}" font-size="14pt" font-weight="normal" margin-top="0.5em" margin-bottom="2mm">
          Artefatti Magici
        </fo:block>
		<xsl:for-each select="$sortedartifacts/artifact">
		  <fo:block page-break-inside="avoid" keep-together.within-column="always" >
			<fo:block id="{generate-id(.)}" font-size="12pt" text-align="center" font-style="italic" font-family="{$textfont}" font-weight="bold" >
			  <fo:inline><xsl:value-of select="name" /></fo:inline><xsl:call-template name="source"/>
			</fo:block>			
			<fo:block font-size="10pt" margin-bottom="2mm">
			  <xsl:apply-templates select="description"/>
			</fo:block>
			<xsl:for-each select="spell">
				<fo:block font-family="{$textfont}" font-size="9pt" font-weight="bold">
				  <fo:inline><xsl:value-of select="name" /></fo:inline><xsl:call-template name="source"/>
				</fo:block>
				<fo:block font-family="{$textfont}" text-indent="1em" font-size="8pt" font-weight="normal">
				  Pen:
				  <xsl:choose>
					<xsl:when test="(guideline/modifiers/modifier/@penetration)[1]"><xsl:value-of select="(guideline/modifiers/modifier/@penetration)[1]" /></xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				  </xsl:choose>,
				  <xsl:choose>
					<xsl:when test="(guideline/modifiers/modifier/@frequency)[1]"><xsl:value-of select="(guideline/modifiers/modifier/@frequency)[1]" /></xsl:when>
					<xsl:otherwise>1/giorno</xsl:otherwise>
				  </xsl:choose>
				</fo:block>			
				<fo:block font-family="{$textfont}" text-indent="1em" font-size="8pt" font-weight="normal">
				  <xsl:apply-templates select="arts/*" mode="abbreviation"><xsl:sort select="."/></xsl:apply-templates><xsl:text> </xsl:text><xsl:value-of select="level" />	
				</fo:block>
				<fo:block font-family="{$textfont}" text-indent="1em" font-size="8pt" font-weight="normal">				
				  P: <xsl:apply-templates select="range" />, D: <xsl:apply-templates select="duration" />, B: <xsl:value-of select="target" />
				  <xsl:if test="@type='mystery'">, Misterico</xsl:if>
				  <xsl:if test="@ritual='true'">, Rituale</xsl:if>
				  <xsl:if test="@faerie='true'">, Fatato</xsl:if>
				  <xsl:if test="@subtype != ''">, <xsl:value-of select="@subtype"/></xsl:if>
				  <xsl:if test="@atlantean='true'">, Atlantideo</xsl:if>
				</fo:block>
				<xsl:apply-templates select="description"/>
				<fo:block margin-bottom="2mm">
				  <fo:block font-family="{$textfont}" font-size="7pt" font-style="italic" font-weight="normal">
					<xsl:choose>
					  <xsl:when test="@type = 'standard' or @type = 'mystery'">
						<xsl:choose>
						  <xsl:when test="guideline/@ward = 'true' and string(guideline/base) = ''">(Come per linee guida di Difesa</xsl:when>                 <xsl:otherwise>
							(Base <xsl:value-of select="guideline/base" /> 
						  </xsl:otherwise>
						</xsl:choose>
						<xsl:call-template name="spell-guidelines" /> <xsl:apply-templates select="arts/requisite" mode="guideline"/>)
					  </xsl:when>
					  <xsl:when test="@type = 'non-hermetic'">(Non-Ermetico)</xsl:when>
					  <xsl:when test="@type = 'general'">(Effetto base)</xsl:when>
					  <xsl:when test="@type = 'unique'">(Incantesimo unico)</xsl:when>
					  <xsl:when test="@type = 'mercurian'">(Rituale Mercuriale)</xsl:when>
					  <xsl:when test="@type = 'special'">(Incantesimo speciale)</xsl:when>
					  <xsl:otherwise>
						ERROR
					  </xsl:otherwise>
					</xsl:choose>
				  </fo:block>
				  <xsl:if test="@link != ''">
				  <fo:block margin-top="0.5mm" font-family="{$urlfont}" font-size="7pt" font-weight="normal">
					<xsl:variable name="title" select="@link_title"/>
					<xsl:variable name="link" select="@link"/>
					Vedi <fo:inline color="{$urlcolour}" text-decoration="underline"><fo:basic-link external-destination="{$link}"><xsl:value-of select="@link_title"/></fo:basic-link></fo:inline>
				  </fo:block>
				  </xsl:if>
				</fo:block>
			</xsl:for-each>		
		  </fo:block>
		</xsl:for-each>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
  
  <xsl:template match="sm">
    <fo:block page-break-inside="avoid">
      <fo:block margin-top="0.2em" font-family="{$textfont}" font-size="9pt" font-weight="bold">
        <xsl:value-of select="@name" />
        <xsl:apply-templates select="bonus">
          <xsl:sort select="@value" data-type="number"/> 
          <xsl:sort select="text()"/> 
        </xsl:apply-templates>
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template match="bonus">
    <fo:block margin-left="1em" font-family="{$textfont}" font-size="9pt" font-weight="normal">
      +<xsl:value-of select="@value" /><xsl:text>  </xsl:text><xsl:value-of select="." /><xsl:call-template name="source"/>
    </fo:block> 
  </xsl:template>
  
  <xsl:template name="artifactindex">
    <fo:page-sequence master-reference="spell-list">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
            <fo:block>
              <fo:external-graphic src="images/index-paper{$wide}.jpg" content-height="scale-to-fit" height="{$height}" content-width="{$width}" scaling="non-uniform"/>
            </fo:block>
          </fo:block-container>
        </xsl:if>
        <fo:block id="artifact_index">
          <fo:inline-container vertical-align="top" inline-progression-dimension="49.9%">
            <fo:block></fo:block>
          </fo:inline-container>
          <fo:inline-container vertical-align="top" inline-progression-dimension="49.9%">
            <fo:block></fo:block>
          </fo:inline-container>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block color="{$handcolour}" text-align-last="justify" font-family="{$textfont}" font-size="8pt" font-weight="normal" margin-left="2cm" margin-right="2cm">
          <fo:page-number/><fo:leader leader-pattern="space" /> 
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <fo:block span="all" keep-with-next.within-page="always" font-family="{$artfont}" font-size="14pt" font-weight="normal" margin-top="0.5em">
          Indice Artefatti
        </fo:block>	  
        <xsl:for-each select="$sortedartifacts/artifact">
          <xsl:variable name="first" select="substring(name,1,1)"/>
          <xsl:variable name="prev" select="preceding-sibling::*[1]"/>
          <xsl:variable name="name" select="name"/>

          <xsl:if test="not(substring($prev/name, 1, 1)=$first)">
            <fo:block keep-with-next.within-page="always" font-family="{$artfont}" font-size="12pt" font-weight="normal" margin-top="0.5em">
              <xsl:choose>
              <xsl:when test="$first = '('"></xsl:when>
              <xsl:otherwise><xsl:value-of select="$first"/></xsl:otherwise>
              </xsl:choose>
            </fo:block>
          </xsl:if>
          <fo:block font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
            <fo:basic-link internal-destination="{generate-id(.)}">
              <xsl:value-of select="name" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="{generate-id(.)}" />              
            </fo:basic-link>
          </fo:block>
        </xsl:for-each>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
  
</xsl:stylesheet>