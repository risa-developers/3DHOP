<%@ page import = "java.io.*,java.util.*"%>

<!DOCTYPE>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">

<head>
	<meta content="charset=UTF-8" />
	<title>3DHOP - 3D Heritage Online Presenter</title>
	<!--STYLESHEET-->
	<link type="text/css" rel="stylesheet" href="stylesheet/3dhop.css" />
	<!--SPIDERGL-->
	<script type="text/javascript" src="js/spidergl.js"></script>
	<!--JQUERY-->
	<script type="text/javascript" src="js/jquery.js"></script>
	<!--PRESENTER-->
	<script type="text/javascript" src="js/presenter.js"></script>
	<!--3D MODELS LOADING AND RENDERING-->
	<script type="text/javascript" src="js/nexus.js"></script>
	<script type="text/javascript" src="js/ply.js"></script>
	<!--TRACKBALLS-->
	<script type="text/javascript" src="js/trackball_sphere.js"></script>
	<script type="text/javascript" src="js/trackball_turntable.js"></script>
	<script type="text/javascript" src="js/trackball_turntable_pan.js"></script>
	<script type="text/javascript" src="js/trackball_pantilt.js"></script>
	<!--UTILITY-->
	<script type="text/javascript" src="js/init.js"></script>
</head>

<body>
  <div id="selectModel" style="top:20em;z-index:1;position:absolute;">
		<select name="models" id="models" class="models">
		</select>
  </div>
	<div id="3dhop" class="tdhop" onmousedown="if (event.preventDefault) event.preventDefault()">
		<div id="tdhlg"></div>
		<div id="toolbar">
			<img id="home" title="Home" src="skins/dark/home.png" /><br />
			<img id="zoomin" title="Zoom In" src="skins/dark/zoomin.png" /><br />
			<img id="zoomout" title="Zoom Out" src="skins/dark/zoomout.png" /><br />
			<img id="light_on" title="Disable Light Control" src="skins/dark/lightcontrol_on.png"
				style="position:absolute; visibility:hidden;" />
			<img id="light" title="Enable Light Control" src="skins/dark/lightcontrol.png" /><br />
			<img id="full_on" title="Exit Full Screen" src="skins/dark/full_on.png"
				style="position:absolute; visibility:hidden;" />
			<img id="full" title="Full Screen" src="skins/dark/full.png" />
		</div>
		<canvas id="draw-canvas" style="background-image: url(skins/backgrounds/light.jpg)" />
	</div>
</body>

<script type="text/javascript">
	const presenter = new Presenter("draw-canvas");
  var models = [];
  var loadModel;
	
  // read dir
  const files = "<%final String path = "/3dhop_models";
                  File folder = new File(path);
                  File[] listOfFiles = folder.listFiles();
									if (listFiles != null) {
                  	for(int i = 0; i < listOfFiles.length; ++i)
                    	out.print(listOfFiles[i].getName() + '|');
									}%>";
  
  function prepareModels() {
    const splitFiles = files.split('|');
    for (var i = 0; i < splitFiles.length; ++i) {
      if (splitFiles[i] != '' && splitFiles[i].toLowerCase().includes(window.location.href.split('/').at(-1).split('.').at(0).toLowerCase()))
        models.push(splitFiles[i]);
    }

    loadModel = models[0];
    setup3dhop();
  }

  function createSelect() {
    const select = document.getElementById("models");
     
    for (const val of models) {
        const option = document.createElement("option");
        option.value = val;
        option.text = val;
        select.appendChild(option);
    }
 
    var label = document.createElement("label");
    label.innerHTML = "Choose your model: "
    label.htmlFor = "models";
 
    document.getElementById("selectModel").appendChild(label).appendChild(select);
  }

  $( ".models" ).change(function() {
		presenter.toggleInstanceVisibilityByName('Model', true);
    loadModel = $("#models option:selected").text();
    setup3dhop();
  });

	function setup3dhop() {
		presenter = new Presenter("draw-canvas");
    console.log(loadModel)

		presenter.setScene({
			meshes: {
				"Monument": { url: "models/" + loadModel }
			},
			modelInstances: {
				"Model": {
					mesh: "Monument"
				}
			}
		});
	}

	function actionsToolbar(action) {
		if (action == 'home') presenter.resetTrackball();
		else if (action == 'zoomin') presenter.zoomIn();
		else if (action == 'zoomout') presenter.zoomOut();
		else if (action == 'light' || action == 'light_on') { presenter.enableLightTrackball(!presenter.isLightTrackballEnabled()); lightSwitch(); }
		else if (action == 'full' || action == 'full_on') fullscreenSwitch();
	}

	$(document).ready(function () {
    prepareModels();
    createSelect();
		init3dhop();
	});
</script>

</html>
