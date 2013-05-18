# See - https://github.com/Phrogz/context-blender/blob/master/context_blender.js
CanvasRenderingContext2D::blendOnto = (destinationContext, blendMode) ->
  width  = Math.min(@canvas.width,  destinationContext.canvas.width)
  height = Math.min(@canvas.height, destinationContext.canvas.height)

  source      = @getImageData(0, 0, width, height)
  destination = destinationContext.getImageData(0, 0, width, height)

  sourceData      = source.data
  destinationData = destination.data

  pixel = 0
  while pixel < destinationData.length
    redPixel   = pixel
    greenPixel = pixel + 1
    bluePixel  = pixel + 2
    alphaPixel = pixel + 3

    sourceAlpha      = sourceData[alphaPixel]      / 255
    destinationAlpha = destinationData[alphaPixel] / 255

    destinationAlpha2 = sourceAlpha + destinationAlpha - sourceAlpha * destinationAlpha
    destinationData[alphaPixel] = destinationAlpha2 * 255

    sourceRedAlpha      = sourceData[redPixel]      / 255 * sourceAlpha
    destinationRedAlpha = destinationData[redPixel] / 255 * destinationAlpha

    sourceGreenAlpha      = sourceData[greenPixel]      / 255 * sourceAlpha
    destinationGreenAlpha = destinationData[greenPixel] / 255 * destinationAlpha

    sourceBlueAlpha      = sourceData[bluePixel]      / 255 * sourceAlpha
    destinationBlueAlpha = destinationData[bluePixel] / 255 * destinationAlpha

    demultiply = 255 / destinationAlpha2
    destinationData[redPixel]   = (sourceRedAlpha   + destinationRedAlpha   - 2 * Math.min(sourceRedAlpha   * destinationAlpha, destinationRedAlpha   * sourceAlpha)) * demultiply
    destinationData[greenPixel] = (sourceGreenAlpha + destinationGreenAlpha - 2 * Math.min(sourceGreenAlpha * destinationAlpha, destinationGreenAlpha * sourceAlpha)) * demultiply
    destinationData[bluePixel]  = (sourceBlueAlpha  + destinationBlueAlpha  - 2 * Math.min(sourceBlueAlpha  * destinationAlpha, destinationBlueAlpha  * sourceAlpha)) * demultiply

    pixel += 4

  destinationContext.putImageData(destination, 0, 0)
