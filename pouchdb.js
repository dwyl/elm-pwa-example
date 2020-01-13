var db = new PouchDB('dwyl');

function saveCapture(capture) {
    var capture = {
        _id: new Date().toISOString(),
        text: capture
      };
    db.put(capture, function callback(err, result) {
      if (!err) {
        console.log('Successfully saved capture!');
      }
    });
}

function showCaptures() {
    db.allDocs({include_docs: true, descending: true}, function(err, doc) {
      console.log(doc.rows)
    });
}