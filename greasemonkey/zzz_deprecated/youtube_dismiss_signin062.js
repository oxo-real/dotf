// https://greasyfork.org/en/scripts/412178-youtube-dismiss-sign-in/code
// ==UserScript==
// @name         Youtube - dismiss sign-in
// @name:fr      Youtube - cacher "connectez-vous"
// @namespace    https://github.com/Procyon-b
// @version      0.6.2
// @description  Hide the "sign-in" and cookies dialogs. Prevent the dialogs from pausing the video.
// @description:fr  Cache le dialogue "connectez-vous" et le dialogue des cookies. Empêche ces popups de stopper la vidéo.
// @author       Achernar
// @match        https://*.youtube.com/*
// @exclude      https://www.youtube.com/embed/*
// @run-at       document-start
// @grant        none
// ==/UserScript==

(function(){
"use strict";
function consent() {
  var t, e=document.querySelector('#introAgreeButton') || ( (t=document.querySelectorAll('form button')) && (t.length == 1) && (e=t[0]) );
  e && e.click();
  }
if (location.href.startsWith('https://consent.youtube.com/')) {
  if (document.readyState != 'loading') consent();
  else document.addEventListener('DOMContentLoaded', consent);
  return;
  }

if (window !== window.top) return;

function cookies() {
  var r={}, a=document.cookie;
  a.split(';').forEach(function(e){
    var p=e.split('=');
    if (p[0]) r[p.shift().trim()]=p.join('=');
    });
  return r;
  }

var ck=cookies();
if (ck['APISID']) return;

function hasDismiss(e, l=1) {
  var p=e;
  while (p && l-- && (p=p.parentNode)) {
    if (p.id=='dismiss-button') return p;
    }
  }

function SImutF(mutL){
  for (let mut of mutL) {
    let t=mut.target, db=t;
    if ( (t.id=='dismiss-button') || (db=hasDismiss(t,2)) ) {
      if (db.__c__) continue;
      if (t.classList.contains('yt-upsell-dialog-renderer') || t.classList.contains('ytd-mealbar-promo-renderer')) ;
      else if (t.classList.contains('yt-tooltip-renderer')) {
        t=t.querySelector('yt-button-renderer');
        if (!t) continue;
        }
      else continue;
      db.__c__=true;
      setTimeout(function(){
        t.click();
        delete db.__c__;
        }, 300);
      subObs.observe(t,{attributes: true, subtree: true});
      }
    }
  }
var obs=new MutationObserver(SImutF);
var subObs=new MutationObserver(SImutF);
var obs_w4PU=new MutationObserver(function(mutL){
  for (let mut of mutL) {
    for (let n of mut.addedNodes) {
      if (n.nodeName == 'YTD-POPUP-CONTAINER') {
        this.disconnect();
        setObs();
        return;
        }
      }
    }
  });
var obs_w4ErRd=new MutationObserver(function(mutL){
  for (let mut of mutL) {
    for (let n of mut.addedNodes) {
      if (n.id == 'columns') {
        let r=n.querySelector('yt-playability-error-supported-renderers');
        if (r) {
          this.disconnect();
          setErRdObs();
          return;
          }
        }
      }
    }
  });
var obsCk=new MutationObserver(function(mutL){
  for (let mut of mutL) {
    for (let n of mut.addedNodes) {
      if (n.nodeName == 'YTD-CONSENT-BUMP-LIGHTBOX') {
        this.disconnect();
        setTimeout(function(){
          let ck=cookies();
          if (ck['CONSENT'] && !ck['CONSENT'].startsWith('YES')) document.cookie='CONSENT=YES+;path=/;secure;domain=youtube.com;expires='+(new Date(Date.now()+567648000000)).toUTCString()+';';
          }, 5000);
        return;
        }
      }
    }
  });

var ErRd, ErRdIT,
 obsErRd=new MutationObserver(function(mutL){
  var t, ITc=30;
  for (let mut of mutL) {
    t=mut.target;
    if (t.id=='dismiss-button') {
      if (t.classList.contains('yt-player-error-message-renderer')) t=t.querySelector(':scope yt-button-renderer paper-button#button');
      else continue;
      if (ErRdIT) clearInterval(ErRdIT);
      ErRdIT=setInterval(function(){
        if (!ITc-- || ErRd.hidden || !t) {
          clearInterval(ErRdIT);
          ErRdIT=0;
          }
        else t.click();
        }, 300);
      return;
      }
    }
  });

function init() {
  var t;
  if (document.querySelector('ytm-app')) {
    new MutationObserver(function(mutL){
      for (let mut of mutL) {
        for (let n of mut.addedNodes) {
          if (n.classList.contains('upsell-dialog-lightbox') || n.classList.cotains('consent-bump-lightbox') ) {
            if (t=document.querySelector('.upsell-dialog-dismiss-button button, .consent-bump-button-wrapper button')) {
              t.click();
              }
            }
          }
        }
      }).observe(document.body, {childList: true, subtree: false});
    }

  setObs();
  setErRdObs();
  if (ck['CONSENT'] && !ck['CONSENT'].startsWith('YES')) {
    obsCk.observe(document.body, {childList:true});
    setTimeout(function(){obsCk.disconnect();},30000);
    }
  }

var c=1;
function setObs(){
  var r=document.querySelector('ytd-app ytd-popup-container');
  if (!r) {
    if (c--) obs_w4PU.observe(document.querySelector('ytd-app'), {childList:true});
    return;
    }
  obs.observe(r, {childList: true, subtree: true});
  }

function setErRdObs() {
  ErRd=document.querySelector('ytd-app yt-playability-error-supported-renderers');
  if (!ErRd) {
    obs_w4ErRd.observe(document.querySelector('ytd-app'), {childList: true, subtree: true});
    setTimeout(function(){obs_w4ErRd.disconnect();}, 20000);
    }
  else obsErRd.observe(ErRd ,{childList: true, subtree: true, attributes: true});
  }

if (document.readyState != 'loading') init();
else document.addEventListener('DOMContentLoaded', init);

var s=document.createElement('style');
(document.head || document.documentElement).appendChild(s);
s.textContent="#consent-bump,iron-overlay-backdrop,yt-upsell-dialog-renderer{opacity:0;}yt-upsell-dialog-renderer *,yt-bubble-hint-renderer,.upsell-dialog-lightbox,.consent-bump-lightbox{display:none !important;}ytd-app > ytd-consent-bump-lightbox,ytd-app ~ iron-overlay-backdrop,ytd-app ~ tp-yt-iron-overlay-backdrop{display:none;}";

s=document.createElement('script');
s.textContent= `(function(){var c=80, pl, plR, oldp={}, t;
  function f(){
    plR=document.querySelector('ytd-player#ytd-player');
    if (plR) pl=plR.getPlayer();
    if (!pl) {
      if (--c) setTimeout(f,200);
      else if (plR) {
        if (t=document.querySelector('ytd-app'))  new MutationObserver(function(mutL){
          for (let mut of mutL) {
            for (let n of mut.addedNodes) {
              if (n.id == 'movie_player') {
                this.disconnect();
                pl=plR.getPlayer();
                init();
                return;
                }
              }
            }
          }).observe(t, {childList: true, subtree: true});
        }
      return;
      }
    else init();
    }
  if (document.readyState != 'loading') f();
  else document.addEventListener('DOMContentLoaded', f);

  function init() {
    for (let i in pl) if (typeof pl[i] == 'function') {
      if ( !['cancelPlayback', 'pauseVideo', 'stopVideo', 'playVideo'].includes(i) ) continue;
      oldp[i]=pl[i];
      pl[i]=function() {
        let st=(new Error()).stack;
        if ( (st.search(/(\\.onFulfilled|scheduler\\.js:|handlePopupClose_)/)>0) && (st.search(/onYtStopOldPlayer_/) ==-1) ) return;
        oldp[i].apply(this,arguments);
        }
      }
    }
  })();`;

(document.head || document.documentElement).appendChild(s);
if (s.parentNode) s.parentNode.removeChild(s);
})();n
