supportsBlending = window.navigator.userAgent.indexOf('Firefox/2') isnt -1
firstImage  = new Image()
secondImage = new Image()

makeItBlend = (firstImagePath, secondImagePath) ->
  [secondImage, firstImage].forEach (image) ->
    image.onerror = ->
      document.getElementById('difference').width = 0
      document.getElementById('difference').height = 0

  secondImage.onload = ->
    firstImage.onload = -> setBlenderWidth() and drawCanvas()
    firstImage.src = firstImagePath

  secondImage.src = secondImagePath

setBlenderWidth = ->
  document.getElementById('difference').width  = secondImage.width
  document.getElementById('difference').height = secondImage.height

drawCanvas = ->
  if supportsBlending then blendForRealz() else blendFallback()

blendForRealz = ->
  context = document.getElementById('difference').getContext('2d')
  context.globalCompositeOperation = 'difference'
  context.drawImage(secondImage, 0, 0)
  context.drawImage(firstImage, 0, 0)

blendFallback = ->
  canvas = document.createElement('canvas')
  canvas.width = firstImage.width
  canvas.height = firstImage.height

  over = canvas.getContext('2d')
  under = document.getElementById('difference').getContext('2d')

  over.clearRect(0, 0, over.canvas.width, over.canvas.height);
  under.clearRect(0, 0, under.canvas.width, under.canvas.height);

  over.drawImage(secondImage, 0, 0);
  under.drawImage(firstImage, 0, 0);

  over.blendOnto(under, 'difference');

@blender = { makeItBlend: makeItBlend }
