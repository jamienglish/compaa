(function() {
  function inGroupsOf(groupSize, collection, callback) {
    for (var i = 0; i < collection.length; i += groupSize) {
      callback(collection.slice(i, i + groupSize));
    }
  };

  function range(n) {
    var result = []
    for (var i = 0; i < n; i++) result.push(i);
    return result;
  };

  CanvasRenderingContext2D.prototype.blendOnto = function(destinationContext, blendMode) {
    var width  = Math.min(this.canvas.width, destinationContext.canvas.width),
        height = Math.min(this.canvas.height, destinationContext.canvas.height);

    var source      = this.getImageData(0, 0, width, height),
        destination = destinationContext.getImageData(0, 0, width, height);

    var sourceData = source.data,
        destinationData = destination.data;

    inGroupsOf(4, range(destinationData.length), function(pixels) {
      var redPixel   = pixels[0],
          greenPixel = pixels[1],
          bluePixel  = pixels[2],
          alphaPixel = pixels[3];


      var sourceAlpha = sourceData[alphaPixel] / 255;
      var destinationAlpha = destinationData[alphaPixel] / 255;
      var destinationAlpha2 = sourceAlpha + destinationAlpha - sourceAlpha * destinationAlpha;

      var sourceRedAlpha        = sourceData[redPixel] / 255 * sourceAlpha;
      var destinationRedAlpha   = destinationData[redPixel] / 255 * destinationAlpha;
      var sourceGreenAlpha      = sourceData[greenPixel] / 255 * sourceAlpha;
      var destinationGreenAlpha = destinationData[greenPixel] / 255 * destinationAlpha;
      var sourceBlueAlpha       = sourceData[bluePixel] / 255 * sourceAlpha;
      var destinationBlueAlpha  = destinationData[bluePixel] / 255 * destinationAlpha;
      var demultiply            = 255 / destinationAlpha2;

      destinationData[alphaPixel] = destinationAlpha2 * 255;
      destinationData[redPixel]   = (sourceRedAlpha   + destinationRedAlpha   - 2 * Math.min(sourceRedAlpha   * destinationAlpha, destinationRedAlpha   * sourceAlpha)) * demultiply;
      destinationData[greenPixel] = (sourceGreenAlpha + destinationGreenAlpha - 2 * Math.min(sourceGreenAlpha * destinationAlpha, destinationGreenAlpha * sourceAlpha)) * demultiply;
      destinationData[bluePixel]  = (sourceBlueAlpha  + destinationBlueAlpha  - 2 * Math.min(sourceBlueAlpha  * destinationAlpha, destinationBlueAlpha  * sourceAlpha)) * demultiply;
    });

    destinationContext.putImageData(destination, 0, 0);
  };
})();
