imageTypes = ['difference', 'animation', 'referenceImage', 'generatedImage']
compaaHost = ''
artifacts  = ''

init = ->
  attachClickHandlers()
  storeArtifacts ->
    paintThePicture()

storeArtifacts = (callback) ->
  xhr = new XMLHttpRequest()
  xhr.open "GET", compaaHost + "/artifacts.json", true
  xhr.onload = ->
    artifacts = JSON.parse(xhr.responseText).artifacts
    callback()
  xhr.send()

attachClickHandlers = ->
  attachButtonClickHandlers()
  attachAcceptClickHandler()
  attachRejectClickHandler()

paintThePicture = ->
  drawDifferenceCanvas()
  setDifferenceImage()
  setGeneratedImage()
  setReferenceImage()
  show "generatedImage"

show = (mode) ->
  imageTypes.forEach (type) ->
    document.getElementById(type).style.display = "none"

  document.getElementById(mode).style.display = "inline"

attachButtonClickHandlers = ->
  imageTypes.forEach (element) ->
    document.getElementById(element + "Button").onclick = (evt) ->
      evt.preventDefault()
      show element

supportsBlending = ->
  window.navigator.userAgent.indexOf("Firefox/2") isnt -1

drawDifferenceCanvas = ->
  generatedImage = new Image()
  referenceImage = new Image()
  context = document.getElementById("difference").getContext("2d")
  [referenceImage, generatedImage].forEach (image) ->
    document.getElementById("difference").width = 0
    document.getElementById("difference").height = 0

  referenceImage.onload = ->
    generatedImage.onload = ->
      document.getElementById("difference").width = referenceImage.width
      document.getElementById("difference").height = referenceImage.height

      if supportsBlending()
        context.globalCompositeOperation = "difference"
      else
        context.globalAlpha = 0.5

      context.drawImage referenceImage, 0, 0
      context.drawImage generatedImage, 0, 0

    generatedImage.src = generatedImagePath()

  referenceImage.src = referenceImagePath()

acceptImage = ->
  url = compaaHost + "/screenshots?filepath=" + generatedImagePath()
  xhr = new XMLHttpRequest()
  xhr.open "POST", url, true
  xhr.onload = -> moveToNextArtifact()
  xhr.send()

moveToNextArtifact = ->
  artifacts.shift()
  if currentArtifact() then paintThePicture() else endGame()

attachAcceptClickHandler = ->
  document.getElementById("accept").onclick = (evt) ->
    evt.preventDefault()
    acceptImage()

attachRejectClickHandler = ->
  document.getElementById("reject").onclick = (evt) ->
    evt.preventDefault()
    moveToNextArtifact()

setGeneratedImage = ->
  document.getElementById("generatedImage").src = generatedImagePath()

setReferenceImage = ->
  document.getElementById("referenceImage").src = referenceImagePath()

setDifferenceImage = ->
  document.getElementById("animation").src = differenceGifPath()

differenceGifPath = ->
  referenceImagePath().replace("reference_screenshots", "differences_in_screenshots_this_run") + "_difference.gif"

referenceImagePath = ->
  currentArtifact()

generatedImagePath = ->
  referenceImagePath().replace "reference_screenshots", "screenshots_generated_this_run"

currentArtifact = ->
  artifacts[0]

endGame = ->
  document.body.innerHTML = "<h1>Done!</h1>"

@Compaa = { init: init }
