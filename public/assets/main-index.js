(function(){this.Api={silent:function(t,e,n){return"function"==typeof e&&(n=e,e={}),/^\/api/.test(t)||(t="/api/"+t),$.post(t,e,function(t){return n&&!t.error?n(t):void 0})},send:function(t,e,n){return(null!=e?e.getAttribute:void 0)&&(e=$(e).serializeHash()),"function"==typeof e&&(n=e,e={}),/^\/api/.test(t)||(t="/api/"+t),$.post(t,e,function(t){return Info.auto(t),n&&!t.error?n(t):void 0})},rails_form:function(t,e){var n,r,i,s
t=$(t),t.find("button").each(function(){return $(this).disable("Saveing...",2e3)}),n=t.closest("form"),i=n.serializeHash()
for(r in i)s=i[r],is_.o(s)&&Api.send(n.attr("action"),s,e)
return!1}}}).call(this),function(){$(document).on("click",function(event){var conf,el,href,href_el,javascript,test_click
if(el=$(event.target),conf=el.closest("*[confirm]"),conf[0]&&!confirm(conf.attr("confirm")))return!1
if(test_click=el.closest("*[onclick], *[click]"),test_click[0]){if(test_click.attr("click"))return eval(test_click.attr("click"))}else if(href_el=el.closest("*[href]"),href_el[0]){if(href=href_el.attr("href"),"A"===href_el[0].nodeName&&href_el.attr("target"))return
return 2===event.which?!0:(javascript=href.split("javascript:"),javascript[1]?(eval(javascript[1].replace(/([^\w])this([^\w])/g,"\\$1href_el\\$2")),!1):href_el.hasClass("no-pjax")||href_el.hasClass("direct")?(location.href=href,!1):href_el.closest("widget")[0]&&href_el.closest("#big-modal-data")[0]?(IncludeWidget.load(href_el,href),!1):(Pjax.load(href),!1))}})}.call(this),function(t){t.fn.serializeHash=function(){function e(t,n){var r=t.lastIndexOf("[")
if(-1==r){var i={}
return i[t]=n,i}var s=t.substr(0,r),o={}
return o[t.substring(r+1,t.length-1)]=n,e(s,o)}var n={},r=t(this).find(":input").get()
return t.each(r,function(){if(this.name&&!this.disabled&&(this.checked||/select|textarea/i.test(this.nodeName)||/hidden|text|search|tel|url|email|password|datetime|date|month|week|time|datetime-local|number|range|color/i.test(this.type))){var r=t(this).val()
t.extend(!0,n,e(this.name,r))}}),n}}(jQuery),function(){function t(t){this.tokens=[],this.tokens.links={},this.options=t||u.defaults,this.rules=h.normal,this.options.gfm&&(this.options.tables?this.rules=h.tables:this.rules=h.gfm)}function e(t,e){if(this.options=e||u.defaults,this.links=t,this.rules=c.normal,this.renderer=this.options.renderer||new n,this.renderer.options=this.options,!this.links)throw new Error("Tokens array requires a `links` property.")
this.options.gfm?this.options.breaks?this.rules=c.breaks:this.rules=c.gfm:this.options.pedantic&&(this.rules=c.pedantic)}function n(t){this.options=t||{}}function r(t){this.tokens=[],this.token=null,this.options=t||u.defaults,this.options.renderer=this.options.renderer||new n,this.renderer=this.options.renderer,this.renderer.options=this.options}function i(t,e){return t.replace(e?/&/g:/&(?!#?\w+;)/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;").replace(/'/g,"&#39;")}function s(t){return t.replace(/&([#\w]+);/g,function(t,e){return e=e.toLowerCase(),"colon"===e?":":"#"===e.charAt(0)?"x"===e.charAt(1)?String.fromCharCode(parseInt(e.substring(2),16)):String.fromCharCode(+e.substring(1)):""})}function o(t,e){return t=t.source,e=e||"",function n(r,i){return r?(i=i.source||i,i=i.replace(/(^|[^\[])\^/g,"$1"),t=t.replace(r,i),n):new RegExp(t,e)}}function l(){}function a(t){for(var e,n,r=1;r<arguments.length;r++){e=arguments[r]
for(n in e)Object.prototype.hasOwnProperty.call(e,n)&&(t[n]=e[n])}return t}function u(e,n,s){if(s||"function"==typeof n){s||(s=n,n=null),n=a({},u.defaults,n||{})
var o,l,h=n.highlight,c=0
try{o=t.lex(e,n)}catch(p){return s(p)}l=o.length
var d=function(t){if(t)return n.highlight=h,s(t)
var e
try{e=r.parse(o,n)}catch(i){t=i}return n.highlight=h,t?s(t):s(null,e)}
if(!h||h.length<3)return d()
if(delete n.highlight,!l)return d()
for(;c<o.length;c++)!function(t){return"code"!==t.type?--l||d():h(t.text,t.lang,function(e,n){return e?d(e):null==n||n===t.text?--l||d():(t.text=n,t.escaped=!0,void(--l||d()))})}(o[c])}else try{return n&&(n=a({},u.defaults,n)),r.parse(t.lex(e,n),n)}catch(p){if(p.message+="\nPlease report this to https://github.com/chjj/marked.",(n||u.defaults).silent)return"<p>An error occured:</p><pre>"+i(p.message+"",!0)+"</pre>"
throw p}}var h={newline:/^\n+/,code:/^( {4}[^\n]+\n*)+/,fences:l,hr:/^( *[-*_]){3,} *(?:\n+|$)/,heading:/^ *(#{1,6}) *([^\n]+?) *#* *(?:\n+|$)/,nptable:l,lheading:/^([^\n]+)\n *(=|-){2,} *(?:\n+|$)/,blockquote:/^( *>[^\n]+(\n(?!def)[^\n]+)*\n*)+/,list:/^( *)(bull) [\s\S]+?(?:hr|def|\n{2,}(?! )(?!\1bull )\n*|\s*$)/,html:/^ *(?:comment *(?:\n|\s*$)|closed *(?:\n{2,}|\s*$)|closing *(?:\n{2,}|\s*$))/,def:/^ *\[([^\]]+)\]: *<?([^\s>]+)>?(?: +["(]([^\n]+)[")])? *(?:\n+|$)/,table:l,paragraph:/^((?:[^\n]+\n?(?!hr|heading|lheading|blockquote|tag|def))+)\n*/,text:/^[^\n]+/}
h.bullet=/(?:[*+-]|\d+\.)/,h.item=/^( *)(bull) [^\n]*(?:\n(?!\1bull )[^\n]*)*/,h.item=o(h.item,"gm")(/bull/g,h.bullet)(),h.list=o(h.list)(/bull/g,h.bullet)("hr","\\n+(?=\\1?(?:[-*_] *){3,}(?:\\n+|$))")("def","\\n+(?="+h.def.source+")")(),h.blockquote=o(h.blockquote)("def",h.def)(),h._tag="(?!(?:a|em|strong|small|s|cite|q|dfn|abbr|data|time|code|var|samp|kbd|sub|sup|i|b|u|mark|ruby|rt|rp|bdi|bdo|span|br|wbr|ins|del|img)\\b)\\w+(?!:/|[^\\w\\s@]*@)\\b",h.html=o(h.html)("comment",/<!--[\s\S]*?-->/)("closed",/<(tag)[\s\S]+?<\/\1>/)("closing",/<tag(?:"[^"]*"|'[^']*'|[^'">])*?>/)(/tag/g,h._tag)(),h.paragraph=o(h.paragraph)("hr",h.hr)("heading",h.heading)("lheading",h.lheading)("blockquote",h.blockquote)("tag","<"+h._tag)("def",h.def)(),h.normal=a({},h),h.gfm=a({},h.normal,{fences:/^ *(`{3,}|~{3,}) *(\S+)? *\n([\s\S]+?)\s*\1 *(?:\n+|$)/,paragraph:/^/}),h.gfm.paragraph=o(h.paragraph)("(?!","(?!"+h.gfm.fences.source.replace("\\1","\\2")+"|"+h.list.source.replace("\\1","\\3")+"|")(),h.tables=a({},h.gfm,{nptable:/^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))*)\n*/,table:/^ *\|(.+)\n *\|( *[-:]+[-| :]*)\n((?: *\|.*(?:\n|$))*)\n*/}),t.rules=h,t.lex=function(e,n){var r=new t(n)
return r.lex(e)},t.prototype.lex=function(t){return t=t.replace(/\r\n|\r/g,"\n").replace(/\t/g,"    ").replace(/\u00a0/g," ").replace(/\u2424/g,"\n"),this.token(t,!0)},t.prototype.token=function(t,e,n){for(var r,i,s,o,l,a,u,c,p,t=t.replace(/^ +$/gm,"");t;)if((s=this.rules.newline.exec(t))&&(t=t.substring(s[0].length),s[0].length>1&&this.tokens.push({type:"space"})),s=this.rules.code.exec(t))t=t.substring(s[0].length),s=s[0].replace(/^ {4}/gm,""),this.tokens.push({type:"code",text:this.options.pedantic?s:s.replace(/\n+$/,"")})
else if(s=this.rules.fences.exec(t))t=t.substring(s[0].length),this.tokens.push({type:"code",lang:s[2],text:s[3]})
else if(s=this.rules.heading.exec(t))t=t.substring(s[0].length),this.tokens.push({type:"heading",depth:s[1].length,text:s[2]})
else if(e&&(s=this.rules.nptable.exec(t))){for(t=t.substring(s[0].length),a={type:"table",header:s[1].replace(/^ *| *\| *$/g,"").split(/ *\| */),align:s[2].replace(/^ *|\| *$/g,"").split(/ *\| */),cells:s[3].replace(/\n$/,"").split("\n")},c=0;c<a.align.length;c++)/^ *-+: *$/.test(a.align[c])?a.align[c]="right":/^ *:-+: *$/.test(a.align[c])?a.align[c]="center":/^ *:-+ *$/.test(a.align[c])?a.align[c]="left":a.align[c]=null
for(c=0;c<a.cells.length;c++)a.cells[c]=a.cells[c].split(/ *\| */)
this.tokens.push(a)}else if(s=this.rules.lheading.exec(t))t=t.substring(s[0].length),this.tokens.push({type:"heading",depth:"="===s[2]?1:2,text:s[1]})
else if(s=this.rules.hr.exec(t))t=t.substring(s[0].length),this.tokens.push({type:"hr"})
else if(s=this.rules.blockquote.exec(t))t=t.substring(s[0].length),this.tokens.push({type:"blockquote_start"}),s=s[0].replace(/^ *> ?/gm,""),this.token(s,e,!0),this.tokens.push({type:"blockquote_end"})
else if(s=this.rules.list.exec(t)){for(t=t.substring(s[0].length),o=s[2],this.tokens.push({type:"list_start",ordered:o.length>1}),s=s[0].match(this.rules.item),r=!1,p=s.length,c=0;p>c;c++)a=s[c],u=a.length,a=a.replace(/^ *([*+-]|\d+\.) +/,""),~a.indexOf("\n ")&&(u-=a.length,a=this.options.pedantic?a.replace(/^ {1,4}/gm,""):a.replace(new RegExp("^ {1,"+u+"}","gm"),"")),this.options.smartLists&&c!==p-1&&(l=h.bullet.exec(s[c+1])[0],o===l||o.length>1&&l.length>1||(t=s.slice(c+1).join("\n")+t,c=p-1)),i=r||/\n\n(?!\s*$)/.test(a),c!==p-1&&(r="\n"===a.charAt(a.length-1),i||(i=r)),this.tokens.push({type:i?"loose_item_start":"list_item_start"}),this.token(a,!1,n),this.tokens.push({type:"list_item_end"})
this.tokens.push({type:"list_end"})}else if(s=this.rules.html.exec(t))t=t.substring(s[0].length),this.tokens.push({type:this.options.sanitize?"paragraph":"html",pre:"pre"===s[1]||"script"===s[1]||"style"===s[1],text:s[0]})
else if(!n&&e&&(s=this.rules.def.exec(t)))t=t.substring(s[0].length),this.tokens.links[s[1].toLowerCase()]={href:s[2],title:s[3]}
else if(e&&(s=this.rules.table.exec(t))){for(t=t.substring(s[0].length),a={type:"table",header:s[1].replace(/^ *| *\| *$/g,"").split(/ *\| */),align:s[2].replace(/^ *|\| *$/g,"").split(/ *\| */),cells:s[3].replace(/(?: *\| *)?\n$/,"").split("\n")},c=0;c<a.align.length;c++)/^ *-+: *$/.test(a.align[c])?a.align[c]="right":/^ *:-+: *$/.test(a.align[c])?a.align[c]="center":/^ *:-+ *$/.test(a.align[c])?a.align[c]="left":a.align[c]=null
for(c=0;c<a.cells.length;c++)a.cells[c]=a.cells[c].replace(/^ *\| *| *\| *$/g,"").split(/ *\| */)
this.tokens.push(a)}else if(e&&(s=this.rules.paragraph.exec(t)))t=t.substring(s[0].length),this.tokens.push({type:"paragraph",text:"\n"===s[1].charAt(s[1].length-1)?s[1].slice(0,-1):s[1]})
else if(s=this.rules.text.exec(t))t=t.substring(s[0].length),this.tokens.push({type:"text",text:s[0]})
else if(t)throw new Error("Infinite loop on byte: "+t.charCodeAt(0))
return this.tokens}
var c={escape:/^\\([\\`*{}\[\]()#+\-.!_>])/,autolink:/^<([^ >]+(@|:\/)[^ >]+)>/,url:l,tag:/^<!--[\s\S]*?-->|^<\/?\w+(?:"[^"]*"|'[^']*'|[^'">])*?>/,link:/^!?\[(inside)\]\(href\)/,reflink:/^!?\[(inside)\]\s*\[([^\]]*)\]/,nolink:/^!?\[((?:\[[^\]]*\]|[^\[\]])*)\]/,strong:/^__([\s\S]+?)__(?!_)|^\*\*([\s\S]+?)\*\*(?!\*)/,em:/^\b_((?:__|[\s\S])+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*)/,code:/^(`+)\s*([\s\S]*?[^`])\s*\1(?!`)/,br:/^ {2,}\n(?!\s*$)/,del:l,text:/^[\s\S]+?(?=[\\<!\[_*`]| {2,}\n|$)/}
c._inside=/(?:\[[^\]]*\]|[^\[\]]|\](?=[^\[]*\]))*/,c._href=/\s*<?([\s\S]*?)>?(?:\s+['"]([\s\S]*?)['"])?\s*/,c.link=o(c.link)("inside",c._inside)("href",c._href)(),c.reflink=o(c.reflink)("inside",c._inside)(),c.normal=a({},c),c.pedantic=a({},c.normal,{strong:/^__(?=\S)([\s\S]*?\S)__(?!_)|^\*\*(?=\S)([\s\S]*?\S)\*\*(?!\*)/,em:/^_(?=\S)([\s\S]*?\S)_(?!_)|^\*(?=\S)([\s\S]*?\S)\*(?!\*)/}),c.gfm=a({},c.normal,{escape:o(c.escape)("])","~|])")(),url:/^(https?:\/\/[^\s<]+[^<.,:;"')\]\s])/,del:/^~~(?=\S)([\s\S]*?\S)~~/,text:o(c.text)("]|","~]|")("|","|https?://|")()}),c.breaks=a({},c.gfm,{br:o(c.br)("{2,}","*")(),text:o(c.gfm.text)("{2,}","*")()}),e.rules=c,e.output=function(t,n,r){var i=new e(n,r)
return i.output(t)},e.prototype.output=function(t){for(var e,n,r,s,o="";t;)if(s=this.rules.escape.exec(t))t=t.substring(s[0].length),o+=s[1]
else if(s=this.rules.autolink.exec(t))t=t.substring(s[0].length),"@"===s[2]?(n=":"===s[1].charAt(6)?this.mangle(s[1].substring(7)):this.mangle(s[1]),r=this.mangle("mailto:")+n):(n=i(s[1]),r=n),o+=this.renderer.link(r,null,n)
else if(this.inLink||!(s=this.rules.url.exec(t))){if(s=this.rules.tag.exec(t))!this.inLink&&/^<a /i.test(s[0])?this.inLink=!0:this.inLink&&/^<\/a>/i.test(s[0])&&(this.inLink=!1),t=t.substring(s[0].length),o+=this.options.sanitize?i(s[0]):s[0]
else if(s=this.rules.link.exec(t))t=t.substring(s[0].length),this.inLink=!0,o+=this.outputLink(s,{href:s[2],title:s[3]}),this.inLink=!1
else if((s=this.rules.reflink.exec(t))||(s=this.rules.nolink.exec(t))){if(t=t.substring(s[0].length),e=(s[2]||s[1]).replace(/\s+/g," "),e=this.links[e.toLowerCase()],!e||!e.href){o+=s[0].charAt(0),t=s[0].substring(1)+t
continue}this.inLink=!0,o+=this.outputLink(s,e),this.inLink=!1}else if(s=this.rules.strong.exec(t))t=t.substring(s[0].length),o+=this.renderer.strong(this.output(s[2]||s[1]))
else if(s=this.rules.em.exec(t))t=t.substring(s[0].length),o+=this.renderer.em(this.output(s[2]||s[1]))
else if(s=this.rules.code.exec(t))t=t.substring(s[0].length),o+=this.renderer.codespan(i(s[2],!0))
else if(s=this.rules.br.exec(t))t=t.substring(s[0].length),o+=this.renderer.br()
else if(s=this.rules.del.exec(t))t=t.substring(s[0].length),o+=this.renderer.del(this.output(s[1]))
else if(s=this.rules.text.exec(t))t=t.substring(s[0].length),o+=i(this.smartypants(s[0]))
else if(t)throw new Error("Infinite loop on byte: "+t.charCodeAt(0))}else t=t.substring(s[0].length),n=i(s[1]),r=n,o+=this.renderer.link(r,null,n)
return o},e.prototype.outputLink=function(t,e){var n=i(e.href),r=e.title?i(e.title):null
return"!"!==t[0].charAt(0)?this.renderer.link(n,r,this.output(t[1])):this.renderer.image(n,r,i(t[1]))},e.prototype.smartypants=function(t){return this.options.smartypants?t.replace(/--/g,"—").replace(/(^|[-\u2014/(\[{"\s])'/g,"$1‘").replace(/'/g,"’").replace(/(^|[-\u2014/(\[{\u2018\s])"/g,"$1“").replace(/"/g,"”").replace(/\.{3}/g,"…"):t},e.prototype.mangle=function(t){for(var e,n="",r=t.length,i=0;r>i;i++)e=t.charCodeAt(i),Math.random()>.5&&(e="x"+e.toString(16)),n+="&#"+e+";"
return n},n.prototype.code=function(t,e,n){if(this.options.highlight){var r=this.options.highlight(t,e)
null!=r&&r!==t&&(n=!0,t=r)}return e?'<pre><code class="'+this.options.langPrefix+i(e,!0)+'">'+(n?t:i(t,!0))+"\n</code></pre>\n":"<pre><code>"+(n?t:i(t,!0))+"\n</code></pre>"},n.prototype.blockquote=function(t){return"<blockquote>\n"+t+"</blockquote>\n"},n.prototype.html=function(t){return t},n.prototype.heading=function(t,e,n){return"<h"+e+' id="'+this.options.headerPrefix+n.toLowerCase().replace(/[^\w]+/g,"-")+'">'+t+"</h"+e+">\n"},n.prototype.hr=function(){return this.options.xhtml?"<hr/>\n":"<hr>\n"},n.prototype.list=function(t,e){var n=e?"ol":"ul"
return"<"+n+">\n"+t+"</"+n+">\n"},n.prototype.listitem=function(t){return"<li>"+t+"</li>\n"},n.prototype.paragraph=function(t){return"<p>"+t+"</p>\n"},n.prototype.table=function(t,e){return"<table>\n<thead>\n"+t+"</thead>\n<tbody>\n"+e+"</tbody>\n</table>\n"},n.prototype.tablerow=function(t){return"<tr>\n"+t+"</tr>\n"},n.prototype.tablecell=function(t,e){var n=e.header?"th":"td",r=e.align?"<"+n+' style="text-align:'+e.align+'">':"<"+n+">"
return r+t+"</"+n+">\n"},n.prototype.strong=function(t){return"<strong>"+t+"</strong>"},n.prototype.em=function(t){return"<em>"+t+"</em>"},n.prototype.codespan=function(t){return"<code>"+t+"</code>"},n.prototype.br=function(){return this.options.xhtml?"<br/>":"<br>"},n.prototype.del=function(t){return"<del>"+t+"</del>"},n.prototype.link=function(t,e,n){if(this.options.sanitize){try{var r=decodeURIComponent(s(t)).replace(/[^\w:]/g,"").toLowerCase()}catch(i){return""}if(0===r.indexOf("javascript:"))return""}var o='<a href="'+t+'"'
return e&&(o+=' title="'+e+'"'),o+=">"+n+"</a>"},n.prototype.image=function(t,e,n){var r='<img src="'+t+'" alt="'+n+'"'
return e&&(r+=' title="'+e+'"'),r+=this.options.xhtml?"/>":">"},r.parse=function(t,e,n){var i=new r(e,n)
return i.parse(t)},r.prototype.parse=function(t){this.inline=new e(t.links,this.options,this.renderer),this.tokens=t.reverse()
for(var n="";this.next();)n+=this.tok()
return n},r.prototype.next=function(){return this.token=this.tokens.pop()},r.prototype.peek=function(){return this.tokens[this.tokens.length-1]||0},r.prototype.parseText=function(){for(var t=this.token.text;"text"===this.peek().type;)t+="\n"+this.next().text
return this.inline.output(t)},r.prototype.tok=function(){switch(this.token.type){case"space":return""
case"hr":return this.renderer.hr()
case"heading":return this.renderer.heading(this.inline.output(this.token.text),this.token.depth,this.token.text)
case"code":return this.renderer.code(this.token.text,this.token.lang,this.token.escaped)
case"table":var t,e,n,r,i,s="",o=""
for(n="",t=0;t<this.token.header.length;t++)r={header:!0,align:this.token.align[t]},n+=this.renderer.tablecell(this.inline.output(this.token.header[t]),{header:!0,align:this.token.align[t]})
for(s+=this.renderer.tablerow(n),t=0;t<this.token.cells.length;t++){for(e=this.token.cells[t],n="",i=0;i<e.length;i++)n+=this.renderer.tablecell(this.inline.output(e[i]),{header:!1,align:this.token.align[i]})
o+=this.renderer.tablerow(n)}return this.renderer.table(s,o)
case"blockquote_start":for(var o="";"blockquote_end"!==this.next().type;)o+=this.tok()
return this.renderer.blockquote(o)
case"list_start":for(var o="",l=this.token.ordered;"list_end"!==this.next().type;)o+=this.tok()
return this.renderer.list(o,l)
case"list_item_start":for(var o="";"list_item_end"!==this.next().type;)o+="text"===this.token.type?this.parseText():this.tok()
return this.renderer.listitem(o)
case"loose_item_start":for(var o="";"list_item_end"!==this.next().type;)o+=this.tok()
return this.renderer.listitem(o)
case"html":var a=this.token.pre||this.options.pedantic?this.token.text:this.inline.output(this.token.text)
return this.renderer.html(a)
case"paragraph":return this.renderer.paragraph(this.inline.output(this.token.text))
case"text":return this.renderer.paragraph(this.parseText())}},l.exec=l,u.options=u.setOptions=function(t){return a(u.defaults,t),u},u.defaults={gfm:!0,tables:!0,breaks:!1,pedantic:!1,sanitize:!1,smartLists:!1,silent:!1,highlight:null,langPrefix:"lang-",smartypants:!1,headerPrefix:"",renderer:new n,xhtml:!1},u.Parser=r,u.parser=r.parse,u.Renderer=n,u.Lexer=t,u.lexer=t.lex,u.InlineLexer=e,u.inlineLexer=e.output,u.parse=u,"undefined"!=typeof module&&"object"==typeof exports?module.exports=u:"function"==typeof define&&define.amd?define(function(){return u}):this.marked=u}.call(function(){return this||("undefined"!=typeof window?window:global)}()),marked.setOptions({renderer:new marked.Renderer,gfm:!0,tables:!0,breaks:!0,pedantic:!1,sanitize:!0,smartLists:!0,smartypants:!1}),function(){this.Pjax={skip_on:[],push_state:!1,refresh:function(t){return Pjax.load(location.pathname+location.search,{func:t})},init:function(t){return this.full_page=null!=t?t:!1,this.full_page?window.history&&window.history.pushState?(Pjax.push_state=!0,window.history.pushState({href:location.href,type:"init"},document.title,location.href),window.onpopstate=function(t){return console.log(t.state),t.state&&t.state.href?Pjax.load(t.state.href,{history:!0}):history.go(-2)}):void 0:alert("#full_page ID referece not defined in PJAX!\n\nWrap whole page in one DIV element")},skip:function(){var t,e,n,r
for(r=[],e=0,n=arguments.length;n>e;e++)t=arguments[e],r.push(Pjax.skip_on.push(t))
return r},redirect:function(t){return location.href=t,!1},replace:function(t,e){return document.title=t,$(this.full_page).html(e),$(document).trigger("page:change")},load:function(t,e){var n,r,i,s,o
if(null==e&&(e={}),!t)return!1
if("object"==typeof t&&(t=$(t).attr("href")),"#"!==t){if(/^http/.test(t))return this.redirect(t)
if(/#/.test(t))return this.redirect(t)
if(!Pjax.push_state)return this.redirect(t)
for(s=Pjax.skip_on,r=0,i=s.length;i>r;r++)switch(n=s[r],typeof n){case"object":if(n.test(t))return this.redirect(t)
break
case"function":if(n(t))return this.redirect(t)
break
default:if(n===t)return this.redirect(t)}return o=$.now(),$.get(t).done(function(n){return function(r){var i,s
return console.log("Pjax.load "+(e.history?"(back trigger)":"")+" "+($.now()-o)+"ms: "+t),s=$("<div>"+r+"</div>"),i=s.find(n.full_page).html()||r,Pjax.replace(s.find("title").first().html(),i),e.history||(location.href.indexOf(t)>-1?window.history.replaceState({href:t,type:"replaced"},document.title,t):window.history.pushState({href:t,type:"pushed"},document.title,t)),window._gaq&&_gaq.push(["_trackPageview"]),e.func?e.func():void 0}}(this)).error(function(t){return Info.error(t.statusText)}),!1}},on_get:function(t){return t?$(document).on("page:change",function(){return t()}):$(document).trigger("page:change")}}}.call(this),function(){window.Popup={close:function(){return $("#popup").hide()},_init:function(){var t
return console.log&&console.log("Popup._init()"),t=$('<div id="popup" style="display:none;"><span onclick="Popup.close();" style="cursor:pointer;float:right;font-size:14px; color:#aaa;">&#10006;</span><div id="popup_title"></div><div id="popup_body"></div></div>'),$(document.body).append(t)},button:function(){return $($("#popup").data("button"))},render:function(t,e,n){var r,i,s,o
return"string"!=typeof n&&(n=$(n).html()),this.refresh_button=t=$(t),s=$("#popup"),0===s.length&&(Popup._init(),s=$("#popup")),"INPUT"!==t[0].nodeName&&s.is(":visible")&&s.attr("data-popup-title")===e?void s.hide():(s.attr("data-popup-title",e),r=0,o=$(window).width()-t.offset().left,400>o&&(r=400-o),s.css("left",t.offset().left-r),s.css("top",t.offset().top+t.height()+("INPUT"===$(t)[0].nodeName?14:6)),$("#popup_title").html(e),$("#popup").data("button",t),i=$("#popup_body"),/^\//.test(n)?(i.html("..."),$.get(n,function(t){return i.html('<widget url="'+n+'">'+t+"</widget>")})):(i.html(n),setTimeout(function(t){return function(){return i.find("input").first().focus()}}(this),100)),s.show())},destroy:function(t,e,n){var r,i
return i=$("<div style='text-align:center !important;'><button class='btn btn-danger' style='margin:15px auto;'>"+e+"</button> or <button class='btn btn-small'>no</button></div>"),r=i.find("button").first(),i.find(".btn-small").on("click",function(){return Popup.close()}),r.on("mouseover",function(){return $(this).transition({scale:1.1})}),r.on("mouseout",function(){return $(this).transition({scale:1})}),r.on("click",function(){return n()}),Popup.render(t,"Sure to destroy?",i)},undelete:function(t,e,n){var r,i
return i=$("<div style='text-align:center;'><button class='btn btn-primary' style='margin:15px auto;;'>undelete?</button> or <button class='btn btn-small'>no</button></div>"),r=i.find("button").first(),i.find(".btn-small").on("click",function(){return Popup.close()}),r.on("mouseover",function(){return $(this).transition({scale:1.1})}),r.on("mouseout",function(){return $(this).transition({scale:1})}),r.on("click",function(){return Api.send("/api/"+e+"/"+n+"/undelete",{},function(){return Popup.close(),Pjax.load("/"+e+"/"+n)})}),Popup.render(t,"Recicle object from trash?",i)},refresh:function(){return Popup.close(),this.refresh_button.click()},menu:function(t,e,n){var r,i,s,o
for(r=[],s=0,o=n.length;o>s;s++)i=n[s],r.push('<a class="block" onclick="Popup.close();'+i[1]+'">'+i[0]+"</a>")
return this.render(t,e,r.join(""))},data:function(t){return $("#popup_body").html(t),Pjax.on_get()}}}.call(this),function(){window.TopModal={render:function(t,e){return $(document.body).append('<div id="top_modal">\n  <div style="position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(100, 100, 100, 0.5) ;z-index:10;"></div>\n  <div id="top_modal_panel" style="position:fixed; z-index:11; display:none; top:0; left:50%; width:700px; margin-left:-350px; background-color:#fff; border:1px solid #ccc; padding:20px; border-top:none; border-bottom-right-radius: 4px; border-bottom-left-radius: 4px;">\n    <div style="border-bottom:1px solid #ddd; padding-bottom:20px; font-size:120%;">\n      <span style="cursor:pointer; float:right; color:#aaa;" onclick="TopModal.close()">&#10006;</span>\n      '+t+'\n    </div>\n    <div style="padding-top:20px;">'+e+"</div>\n  </div>\n</div>"),$("#top_modal_panel").slideDown(100)},close:function(){return $("#top_modal").remove()},load:function(t,e){return $.get(e,function(e){return TopModal.render(t,e)})},app:{select_bucket:function(t){return TopModal.load("Select bucket","/bucket/select?id="+t)}}}}.call(this),function(){"use strict"
window.Widget={count:0,widgets:{},registered_widgets:{},register:function(t,e){this.registered_widgets[t]=e},load_all:function(t){var e,n
void 0==t&&(t=window.document)
var r=t.getElementsByClassName("w")
for(e in r){var i=r[e]
i.nodeName&&(n=i.getAttribute(n),n&&this.widgets[n]||Widget.bind_to_dom_node(i))}},bind_to_dom_node:function(t){var e,n,r=t.getAttribute("class"),i=t.getAttribute("id")
i||(++this.count,i="widget-"+this.count,t.setAttribute("id",i))
var s={}
for(e in t.attributes){var o=t.attributes[e]
void 0!==o.value&&(s[o.name]=o.value)}var l=r.split(" ")[1],a=this.registered_widgets[l]
if(!a)return void alert("Widget "+l+" is not registred")
var u={}
for(e in Object.keys(a))n=Object.keys(a)[e],u[n]=a[n]
u.init||(u.init=function(){}),u.render||(u.render=function(){}),u.root=t,u.opts=s,u.get=function(t){return this.opts[t]},u.set=function(t,e){return this.opts[t]=e,e},u.destroy=function(t,e){delete Widget.widgets[this.get("id")],this.root.parentNode.removeChild(this.root)},u.inner_html=function(t){this.root.innerHTML=t,Widget.load_all(this.root)},u.init(),u.render(),Widget.widgets[i]=u},is_widget:function(t){var e=t.getAttribute("class")
return e&&"w"===e.split(" ")[0]?t:void 0}},window.$w=function(t,e){var n=function(){for(;t;){if(Widget.is_widget(t))return t
t=t.parentNode}}()
return n?Widget.widgets[n.getAttribute("id")]:alert("Widget node not found")}}.apply(window),Widget.load_all(),function(){Widget.register("markdown",{init:function(){return"undefined"==typeof marked||null===marked?alert("Marked markdown parser is not loaded"):/\w/.test(this.root.innerHTML)?this.root.innerHTML=marked(this.root.innerHTML):""}})}.call(this),function(){Widget.register("toggle",{init:function(){var t
return t=$(this.root),this.on_state=t.find(".on").first().html(),this.off_state=t.find(".off").first().html(),this.opts.button&&(this.on_state='<button class="btn btn-default" onclick="'+this.widget+'.toggle()">'+this.opts.button+" &darr;</button>",this.off_state=t.html(),this.opts.close)?this.off_state='<span style="float:right; color:#aaa; font-size:18pt; font-weight:bold; margin-right:10px; margin-bottom:-40px;" onclick="$w(this).toggle()" title="Zatvori">&times;</span>'+this.off_state:void 0},render:function(){return this.opts.inactive?this.root.innerHTML=this.off_state:this.root.innerHTML=this.on_state},toggle:function(){return this.set("inactive",this.opts.inactive?0:1),this.render(),this.opts.inactive&&this.opts.animate?(this.root.hide(),this.root.slideDown(200)):void 0}})}.call(this),function(){Widget.register("view-note",{init:function(){return this.note=JSON.parse(this.root.innerHTML)},render:function(){var t
return this.root.style.display="block",t=marked(this.note.data||""),this.html('<div class="bucket note" href="'+this.note.path+'">\n  <div class="wrap">\n    <h4>'+this.note.name+"</h4>\n    "+t+"    \n  </div>\n</div>")}})}.call(this),function(){this.Info={ok:function(t){return Info.show("success",t)},info:function(t){return Info.show("info",t)},noteice:function(t){return Info.show("info",t)},success:function(t){return Info.show("success",t)},error:function(t){return Info.show("error",t)},alert:function(t){return Info.show("error",t)},warning:function(t){return Info.show("warning",t)},auto:function(t,e){return"string"==typeof t&&(t=jQuery.parseJSON(t)),t.info?Info.show("info",t.info):t.error?Info.show("error",t.error):t.message?Info.show("info",t.message):Info.show("info",t.data),t.redirect_to&&e&&(location.href=t.redirect_to),!0},show:function(t,e){var n,r
return"notice"===t&&(t="info"),"alert"===t&&(t="error"),r=$('<div class="toast toast-'+t+'" class="toast-top-right"><div class="toast-message">'+e+"</div></div>"),n=$("#toast-container"),n[0]||($("body").append('<div id="toast-container" class="toast-bottom-right"></div>'),n=$("#toast-container")),n.append(r),r.css("top",0),setTimeout(function(t){return function(){return r.remove()}}(this),4500)}},window.alert=Info.error}.call(this),function(){$(function(){return Pjax.init("#full-page"),Pjax.on_get(function(){return Popup.close(),Widget.load_all()}),Pjax.on_get()}),window.delete_object=function(t,e){return confirm("Are you shure?")?Api.send(t+"/"+e+"/destroy",{},function(){return Pjax.load("/"+t)}):void 0},window.restore_object=function(t,e){return Api.send(t+"/"+e+"/undelete",{},function(t){return Pjax.load(t.path)})},Popup.go={clients:function(t,e,n){var r
return Popup.render(t,"Izaberite klijenta","..."),window.modal_click_target=n,r='<div style="width:350px;">\n  <input type="text" placeholder="traži" onkeyup="$w(\'#c_in_t\').set(\'q\', this.value)" class="form-control" style="width:150px; display:inline-block;" />\n  <a class="btn btn-default fr" href="/orgs/'+e+'/new_client">+ novi klijent</a>\n</div>\n<div id="c_in_t" class="widget clients_in_table" org="'+e+'" style="max-height:400px;overflow:auto;"></div>',Popup.data(r)},form:function(t,e,n,r,i,s){var o
return null==s&&(s={}),o='<input type="text" class="form-control" name="'+r+'" value="'+i+'" style="width:250px;" id="popup_input" />',"editor"===s.as&&(o='<div style="width:500px;"><textarea id="popup_editor" class="widget editor form-control" name="'+r+'" style="width:100%; height:150px;">'+i+"</textarea></div><br>"),o="<form onsubmit=\"_t=this; Api.send('"+n+'\', this, function(){ Pjax.refresh(true); }); return false;" method="post">'+o+'<button class="btn btn-primary" style="float:right;">Create</button></form>',Popup.render(t,e,o),"editor"===s.as?init_html_editor():void 0}},this.Tag={toggle:function(t,e,n){return Api.send(e+"/toggle_tag",{tag:n},function(e){return e.present?$(t).attr("class","label label-primary"):$(t).attr("class","label label-default")})},add:function(t){var e
return e=$("#add_tag").val(),e?Api.send(t+"/toggle_tag",{tag:e},function(){return App.reload_container("#tags_list")}):(alert("Label is requred"),void $("#add_tag").focus())}},window.App={reload_container:function(t){var e,n
return e=$(t),n=e.attr("data-url"),n?$.get(n,function(t){return e.html(t),Widgets.load()}):alert("data-url not defined")},create_link:function(t){return Api.send("links/create",t,function(){return Pjax.load("/links")}),!1},add_bucket_to_bucket:function(t,e){return TopModal.close(),Api.send("buckets/"+t+"/add_bucket?id="+e,Pjax.refresh)}},$(window).keydown(function(t){return 27===t.which?TopModal.close():void 0})}.call(this)
