imageTypes = ['difference', 'animation', 'referenceImage', 'generatedImage']
compaaHost = ''
artifacts  = ''
supportsBlending = window.navigator.userAgent.indexOf('Firefox/2') isnt -1

init = ->
  attachClickHandlers()
  storeArtifacts ->
    paintThePicture()
    show('generatedImage')

storeArtifacts = (callback) ->
  xhr = new XMLHttpRequest()
  xhr.open('GET', compaaHost + '/artifacts.json', true)
  xhr.onload = ->
    artifacts = JSON.parse(xhr.responseText).artifacts
    callback()
  xhr.send()

attachClickHandlers = ->
  attachButtonClickHandlers()
  attachAcceptClickHandler()
  attachRejectClickHandler()

paintThePicture = ->
  makeItBlend()
  setDifferenceImage()
  setGeneratedImage()
  setReferenceImage()

show = (mode) ->
  imageTypes.forEach (type) ->
    document.getElementById(type).style.display = 'none'

  document.getElementById(mode).style.display = 'inline'

attachButtonClickHandlers = ->
  imageTypes.forEach (element) ->
    document.getElementById(element + 'Button').onclick = (evt) ->
      evt.preventDefault()
      show(element)

makeItBlend = ->
  generatedImage = new Image()
  referenceImage = new Image()

  [referenceImage, generatedImage].forEach (image) ->
    image.onerror = ->
      document.getElementById('difference').width = 0
      document.getElementById('difference').height = 0

  referenceImage.onload = ->
    generatedImage.onload = ->
      setBlenderWidth(referenceImage)
      drawCanvas(referenceImage, generatedImage)

    generatedImage.src = generatedImagePath()

  referenceImage.src = referenceImagePath()

setBlenderWidth = (referenceImage) ->
  document.getElementById('difference').width  = referenceImage.width
  document.getElementById('difference').height = referenceImage.height

drawCanvas = (referenceImage, generatedImage) ->
  if supportsBlending
    blendForRealz(referenceImage, generatedImage)
  else
    blendFallback(referenceImage, generatedImage)

blendForRealz = (referenceImage, generatedImage) ->
  context = document.getElementById('difference').getContext('2d')
  context.globalCompositeOperation = 'difference'
  context.drawImage(referenceImage, 0, 0)
  context.drawImage(generatedImage, 0, 0)

blendFallback = (referenceImage, generatedImage) ->
  canvas = document.createElement('canvas')
  canvas.width = generatedImage.width
  canvas.height = generatedImage.height

  over = canvas.getContext('2d')
  under = document.getElementById('difference').getContext('2d')

  over.clearRect(0, 0, over.canvas.width, over.canvas.height);
  under.clearRect(0, 0, under.canvas.width, under.canvas.height);

  over.drawImage(referenceImage, 0, 0);
  under.drawImage(generatedImage, 0, 0);

  over.blendOnto(under, 'difference');

acceptImage = ->
  url = compaaHost + '/screenshots?filepath=' + generatedImagePath()
  xhr = new XMLHttpRequest()
  xhr.open('POST', url, true)
  xhr.onload = -> moveToNextArtifact()
  xhr.send()

moveToNextArtifact = ->
  artifacts.shift()
  if currentArtifact() then paintThePicture() else endGame()

attachAcceptClickHandler = ->
  document.getElementById('accept').onclick = (evt) ->
    evt.preventDefault()
    acceptImage()

attachRejectClickHandler = ->
  document.getElementById('reject').onclick = (evt) ->
    evt.preventDefault()
    moveToNextArtifact()

setGeneratedImage = ->
  document.getElementById('generatedImage').src = generatedImagePath()

setReferenceImage = ->
  document.getElementById('referenceImage').src = referenceImagePath()

setDifferenceImage = ->
  document.getElementById('animation').src = differenceGifPath()

differenceGifPath = ->
  referenceImagePath().replace('reference_screenshots', 'differences_in_screenshots_this_run') + '_difference.gif'

referenceImagePath = ->
  currentArtifact()

generatedImagePath = ->
  referenceImagePath().replace('reference_screenshots', 'screenshots_generated_this_run')

currentArtifact = ->
  artifacts[0]

endGame = ->
  document.body.innerHTML = '<h1>Done!</h1>'

@Compaa = { init: init }
