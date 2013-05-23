imageTypes = ['difference', 'animation', 'referenceImage', 'generatedImage']
compaaHost = ''
artifacts  = ''

init = ->
  attachClickHandlers()
  storeArtifacts ->
    paintThePicture()
    show('difference')

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
  @blender.makeItBlend(generatedImagePath(), referenceImagePath())
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
