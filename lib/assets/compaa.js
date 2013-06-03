(function() {
  var imageTypes = ['difference', 'referenceImage', 'generatedImage'],
      compaaHost = '',
      artifacts  = [],
      generatedImage = new Image(),
      referenceImage = new Image();

  function init() {
    attachClickHandlers();

    storeArtifacts(function() {
      paintThePicture();
      show('difference');
    });
  };

  function storeArtifacts(callback) {
    var xhr;

    xhr = new XMLHttpRequest();
    xhr.open('GET', compaaHost + '/artifacts.json', true);
    xhr.onload = function() {
      artifacts = JSON.parse(xhr.responseText).artifacts;
      callback();
    };
    xhr.send();
  };

  function attachClickHandlers() {
    attachButtonClickHandlers();
    attachAcceptClickHandler();
    attachRejectClickHandler();
  };

  function replaceCanvasWith(newCanvas) {
    newCanvas.id = 'difference';
    document.body.replaceChild(newCanvas, document.getElementById('difference'));
  };

  function blend() {
    window.blender.makeItBlend(generatedImage, referenceImage, function(blendedImage) {
      enableOtherButtons();
      replaceCanvasWith(blendedImage);
      setGeneratedImage();
      setReferenceImage();
      show('difference');
    });
  };

  function noBlend() {
    setGeneratedImage();
    setReferenceImage();
    disableOtherButtons();
    show('generatedImage');
  };

  function paintThePicture() {
    generatedImage.onload = function() {
      referenceImage.onload  = blend;
      referenceImage.onerror = noBlend;
      referenceImage.src     = referenceImagePath();
    };

    generatedImage.src = generatedImagePath();
  };

  function disableOtherButtons() {
    allButtons().forEach(function(element) {
      element.className = element.className + ' disabled';
    });
  };

  function enableOtherButtons() {
    allButtons().forEach(function(element) {
      element.className = element.className.replace('disabled', '');
    });
  };

  function allButtons() {
    return imageTypes.map(function(element) {
      return document.getElementById(element + 'Button');
    })
  };

  function show(mode) {
    imageTypes.forEach(function(type) {
      document.getElementById(type).style.display = 'none';
    });

    document.getElementById(mode).style.display = 'inline';
  };

  function attachButtonClickHandlers() {
    imageTypes.forEach(function(element) {
      document.getElementById(element + 'Button').onclick = function() {
        show(element);
      };
    });
  };

  function acceptImage() {
    var url, xhr;

    url = compaaHost + '/screenshots?filepath=' + generatedImagePath();
    xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.onload = moveToNextArtifact;
    xhr.send();
  };

  function moveToNextArtifact() {
    artifacts.shift();
    if (currentArtifact()) {
      paintThePicture();
    } else {
      endGame();
    }
  };

  function attachAcceptClickHandler() {
    document.getElementById('accept').onclick = acceptImage;
  };

  function attachRejectClickHandler() {
    document.getElementById('reject').onclick = moveToNextArtifact;
  };

  function setGeneratedImage() {
    document.getElementById('generatedImage').src = generatedImagePath();
  };

  function setReferenceImage() {
    document.getElementById('referenceImage').src = referenceImagePath();
  };

  function referenceImagePath() {
    return generatedImagePath().replace('screenshots_generated_this_run', 'reference_screenshots');
  };

  function generatedImagePath() {
    return currentArtifact();
  };

  function currentArtifact() {
    return artifacts[0];
  };

  function endGame() {
    document.body.innerHTML = '<h1>Done!</h1>';
  };

  window.Compaa = {
    init: init
  };
})();
