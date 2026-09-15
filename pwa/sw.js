/* STUB. Offline-first: serve from cache, update in the background.
   A signage screen must never show a browser error page — last-known-good
   beats an error, which is the same rule the node daemon follows. */
const CACHE = 'railworks-v1';
const ASSETS = ['./index.html', './manifest.webmanifest'];
self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(ASSETS)).then(() => self.skipWaiting()));
});
self.addEventListener('activate', e => e.waitUntil(self.clients.claim()));
self.addEventListener('fetch', e => {
  e.respondWith(caches.match(e.request).then(hit => {
    const net = fetch(e.request).then(r => {
      if (r && r.status === 200) caches.open(CACHE).then(c => c.put(e.request, r.clone()));
      return r;
    }).catch(() => hit);        // offline -> whatever we already had
    return hit || net;          // cache first, refresh behind
  }));
});
