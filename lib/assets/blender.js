(function() {
  var supportsBlending = window.navigator.userAgent.indexOf('Firefox/2') !== -1,
      firstImage  = new Image(),
      secondImage = new Image(),
      differenceCanvas = document.createElement('canvas');

  function resize(subject, width, height) {
    subject.width  = width;
    subject.height = height;
  };

  function makeItBlend(imageOne, imageTwo, callback) {
    firstImage  = imageOne;
    secondImage = imageTwo;

    setBlenderWidth();
    drawCanvas();
    callback(differenceCanvas);
  };

  function setBlenderWidth() {
    resize(differenceCanvas, secondImage.width, secondImage.height);
  };

  function drawCanvas() {
    supportsBlending ? blendForRealz() : blendFallback();
  };

  function blendForRealz() {
    var context;

    context = differenceCanvas.getContext('2d');
    context.globalCompositeOperation = 'difference';
    context.drawImage(secondImage, 0, 0);
    context.drawImage(firstImage, 0, 0);
  };

  function blendFallback() {
    var canvas, over, under;

    canvas = document.createElement('canvas');
    resize(canvas, firstImage.width, firstImage.height);

    over = canvas.getContext('2d');
    under = differenceCanvas.getContext('2d');

    over.clearRect(0, 0, over.canvas.width, over.canvas.height);
    under.clearRect(0, 0, under.canvas.width, under.canvas.height);

    over.drawImage(secondImage, 0, 0);
    under.drawImage(firstImage, 0, 0);

    over.blendOnto(under, 'difference');
  };

  window.blender = {
    makeItBlend: makeItBlend
  };
})();
