self.addEventListener('install', function (e) {
  e.waitUntil(
    caches.open('dwylapp').then(function (cache) {
      return cache.addAll([
        '/elm-pwa-example',
        '/elm-pwa-example/manifest.json',
        '/elm-pwa-example/elm.js',
        '/elm-pwa-example/assets/images/dwyl.png',
        '/elm-pwa-example/assets/images/signal_wifi_off.svg',
        '/elm-pwa-example/assets/css/tachyons.css',
        '/elm-pwa-example/assets/css/app.css',
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
