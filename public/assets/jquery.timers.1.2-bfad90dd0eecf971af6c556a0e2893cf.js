/**
 * jQuery.timers - Timer abstractions for jQuery
 * Written by Blair Mitchelmore (blair DOT mitchelmore AT gmail DOT com)
 * Licensed under the WTFPL (http://sam.zoy.org/wtfpl/).
 * Date: 2009/10/16
 *
 * @author Blair Mitchelmore
 * @version 1.2
 *
 **/
jQuery.fn.extend({everyTime:function(a,b,c,d){return this.each(function(){jQuery.timer.add(this,a,b,c,d)})},oneTime:function(a,b,c){return this.each(function(){jQuery.timer.add(this,a,b,c,1)})},stopTime:function(a,b){return this.each(function(){jQuery.timer.remove(this,a,b)})}}),jQuery.extend({timer:{global:[],guid:1,dataKey:"jQuery.timer",regex:/^([0-9]+(?:\.[0-9]*)?)\s*(.*s)?$/,powers:{ms:1,cs:10,ds:100,s:1e3,das:1e4,hs:1e5,ks:1e6},timeParse:function(a){if(a==undefined||a==null)return null;var b=this.regex.exec(jQuery.trim(a.toString()));if(b[2]){var c=parseFloat(b[1]),d=this.powers[b[2]]||1;return c*d}return a},add:function(a,b,c,d,e){var f=0;jQuery.isFunction(c)&&(e||(e=d),d=c,c=b),b=jQuery.timer.timeParse(b);if(typeof b!="number"||isNaN(b)||b<0)return;if(typeof e!="number"||isNaN(e)||e<0)e=0;e=e||0;var g=jQuery.data(a,this.dataKey)||jQuery.data(a,this.dataKey,{});g[c]||(g[c]={}),d.timerID=d.timerID||this.guid++;var h=function(){(++f>e&&e!==0||d.call(a,f)===!1)&&jQuery.timer.remove(a,c,d)};h.timerID=d.timerID,g[c][d.timerID]||(g[c][d.timerID]=window.setInterval(h,b)),this.global.push(a)},remove:function(a,b,c){var d=jQuery.data(a,this.dataKey),e;if(d){if(!b)for(b in d)this.remove(a,b,c);else if(d[b]){if(c)c.timerID&&(window.clearInterval(d[b][c.timerID]),delete d[b][c.timerID]);else for(var c in d[b])window.clearInterval(d[b][c]),delete d[b][c];for(e in d[b])break;e||(e=null,delete d[b])}for(e in d)break;e||jQuery.removeData(a,this.dataKey)}}}}),jQuery(window).bind("unload",function(){jQuery.each(jQuery.timer.global,function(a,b){jQuery.timer.remove(b)})});