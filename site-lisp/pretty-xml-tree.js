// ==UserScript==
// @name Pretty XML tree
// @author Jakub Roztocil <jakub@roztocil.name>
// @version 0.4
// @ujs:published 2008-06-23
// @ujs:updated 2009-07-20
// @ujs:download http://www.webkitchen.cz/lab/opera/pretty-xml-tree/files/pretty-xml-tree.js
// @ujs:documentation http://blog.webkitchen.cz/pretty-xml-tree
// ==/UserScript==

/* CHANGELOG:

0.4 - fixed missing "/" in closing tags

0.3 - added a check whether document is a WML document (thx arjanm)
    - fixed conflict with anchorize.js

*/

window.addEventListener('DOMContentLoaded', function() {


var tree = {
	create: function() {
		var processor = new XSLTProcessor();
		processor.importStylesheet(tree.getStylesheet());
		processor.setParameter(null, 'xml-declaration', tree.getXmlDeclaration());
		processor.setParameter(null, 'doctype', tree.getDoctype());
		document.replaceChild(processor.transformToDocument(document).documentElement, document.documentElement);
		tree.init();
	},

	init: function () {
		function higlight() {
			this.parentNode.className += ' tag-hover';
		}
		function unhiglight() {
			this.parentNode.className = this.parentNode.className.replace('tag-hover', '');
		}
		function toggle() {
			if (this.parentNode.className.indexOf('closed') > -1) {
				this.parentNode.className =  this.parentNode.className.replace('closed', '');
			} else {
				this.parentNode.className += ' closed';
			}
		}
		var result = document.evaluate("//[contains(@class, 'tag-start') or  contains(@class, 'tag-end')]", document, null, XPathResult.UNORDERED_NODE_SNAPSHOT_TYPE, null);
		var node, i = 0;
		while (node = result.snapshotItem(i++)) {
			node.onmouseover = higlight;
			node.onmouseout = unhiglight;
			node.onclick = toggle;
		}
	},

	getDoctype: function() {
		var dt = '';
		if (document.doctype) {
			var dt = '<!DOCTYPE ' + document.doctype.name;
			if (document.doctype.publicId) {
				dt += ' "' + document.doctype.publicId + '"';
			}
			if (document.doctype.systemId) {
				dt += ' "' + document.doctype.systemId + '"';
			}
			if (document.doctype.internalSubset) {
				dt += ' [' + document.doctype.internalSubset + ']';
			}
			dt += '>';
		}
		return dt;
	},

	getXmlDeclaration: function() {
		var xmlDecl = new XMLSerializer().serializeToString(document).match(/^(\s*)(<\?xml.+?\?>)/i);
		return xmlDecl[2];
	},

	getStylesheet: function() {
		if (tree.xslt) {
			return new DOMParser().parseFromString(tree.xslt, "text/xml");
		} else {
			// for testing
			var request = new XMLHttpRequest();
			request.open('GET', 'pretty-xml-tree.xsl?' + (new Date().getTime()), false);
			request.send(null);
			return request.responseXML;
		}
	},

	xslt: '<?xml version="1.0" encoding="utf-8"?> <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0"> <xsl:output encoding="utf-8" method="xml" indent="no" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/> <xsl:param name="doctype"/> <xsl:param name="xml-declaration"/> <xsl:template match="/"> <html> <head> <title>Pretty XML tree</title> <style type="text/css"> body, html { margin: 0; padding: 0; } #info { background: #ccc; border-bottom: 3px solid #000; padding: 1em; margin-bottom: 2em; } #xml-declaration { font-weight: bold; } #doctype { font-weight: bold; color: green; margin: 0; } #tree { font: 13px/1.2 monospace; padding-left: .4em; } .ele { margin: 2px 0 5px; border-left: 1px dotted #fff; } .ele .ele { margin-left: 40px } .content { display: inline; } div.inline, div.inline * { display: inline; margin: 0; border-left: none; } .name, .prefix { color: purple; font-weight: bold; } .a-value { color: blue; } .a-name { font-weight: bold; } .comment { color: green; font-style: italic; } .text { white-space: pre; color: #484848; } .pi { color: orange; font-weight: bold; } .tag { color: #000; } .tag-start, .tag-end { cursor: pointer; } .tag-hover > .tag:last-child, .tag-hover > .tag:first-child { background: #eee; } .tag-hover { border-left-style: solid; border-left-color: #ccc; } .closed > .content { display: none; } .closed > .tag-start:after { content: \'...\'; background: lime; } </style> </head> <body> <div id="info"> <p>This XML file does not appear to have any style information associated with it. The document tree is shown below.</p> </div> <div id="tree"> <div id="xml-declaration"> <xsl:value-of select="$xml-declaration"/> </div> <xsl:apply-templates select="processing-instruction()" /> <xsl:if test="$doctype"> <pre id="doctype"> <xsl:value-of select="$doctype"/> </pre> </xsl:if> <xsl:apply-templates select="node()[not(self::processing-instruction())]" /> </div> </body> </html> </xsl:template> <xsl:template match="a[@class = \'x-opera-anchorized\']"> <xsl:apply-templates select="text()"/> </xsl:template> <xsl:template match="*"> <div class="ele"> <xsl:if test="(preceding-sibling::text()[normalize-space(.)] or following-sibling::text()[normalize-space(.)]) and not(*)"> <xsl:attribute name="class"> <xsl:text> inline</xsl:text> </xsl:attribute> </xsl:if> <xsl:if test="namespace-uri(.)"> <xsl:attribute name="title"> <xsl:value-of select="namespace-uri(.)"/> </xsl:attribute> </xsl:if> <xsl:variable name="tag"> <xsl:if test="contains(name(.), \':\')"> <span class="prefix"> <xsl:value-of select="substring-before(name(.), \':\')"/> </span> <xsl:text>:</xsl:text> </xsl:if> <span class="name"> <xsl:value-of select="local-name(.)"/> </span> </xsl:variable> <span id="start-{generate-id(.)}"> <xsl:attribute name="class"> <xsl:text>tag tag-</xsl:text> <xsl:choose> <xsl:when test="node()">start</xsl:when> <xsl:otherwise>self-close</xsl:otherwise> </xsl:choose> </xsl:attribute> <xsl:text>&lt;</xsl:text> <xsl:copy-of select="$tag"/> <xsl:apply-templates select="@*"/> <xsl:if test="not(node())"> <xsl:text> /</xsl:text> </xsl:if> <xsl:text>&gt;</xsl:text> </span> <xsl:if test="node()"> <div class="content"> <xsl:apply-templates /> </div> <span class="tag tag-end" id="end-{generate-id(.)}"> <xsl:text>&lt;/</xsl:text> <xsl:copy-of select="$tag"/> <xsl:text>&gt;</xsl:text> </span> </xsl:if> </div> </xsl:template> <xsl:template match="@*"> <xsl:text> </xsl:text> <span class="a-name"> <xsl:value-of select="name(.)"/> </span> <xsl:text>=</xsl:text> <span class="a-value"> <xsl:value-of select="concat(\'&quot;\', ., \'&quot;\')"/> </span> </xsl:template> <xsl:template match="text()"> <xsl:if test="normalize-space(.)"> <span class="text"> <xsl:value-of select="."/> </span> </xsl:if> </xsl:template> <xsl:template match="comment()"> <span class="comment"> <xsl:text>,,&lt;--</xsl:text> <xsl:value-of select="."/> <xsl:text>--&gt;</xsl:text> </span> </xsl:template> <xsl:template match="processing-instruction()"> <div class="pi"> <xsl:text>&lt;?</xsl:text> <xsl:value-of select="name(.)"/> <xsl:text> </xsl:text> <xsl:value-of select="."/> <xsl:text>?&gt;</xsl:text> </div> </xsl:template> </xsl:stylesheet>'
}

if ((document.styleSheets.length && document.documentElement.tagName != 'xsl:stylesheet')
	|| document.documentElement.tagName == 'html'
	|| document.documentElement.tagName == 'wml'
	|| !document.documentElement
	|| !(document instanceof XMLDocument))
{
	return;
}
tree.create();


}, false);


