self.addEventListener('install', function (e) {
  e.waitUntil(
    caches.open('dwylapp').then(function (cache) {
      return cache.addAll([
        '/',
        '/manifest.json',
        '/elm.js',
        '/assets/images/dwyl.png',
        '/assets/images/signal_wifi_off.svg',
        '/assets/css/tachyons.css',
        '/assets/css/app.css',
      ]);
    })
  );
});

self.addEventListener('fetch', function (event) {
  console.log(event.request.url);
  event.respondWith(
    caches.match(event.request).then(function (response) {
      return response || fetch(event.request);
    })
  );
});
