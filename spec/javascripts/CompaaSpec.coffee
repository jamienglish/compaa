loadFixture = ->
  document.body.innerHTML = document.body.innerHTML + """
  <div id='fixture'>
    <canvas id='offScreenCanvas' style='position: absolute; left: -9999999px;'></canvas>
    <canvas id='difference'></canvas>
    <img id='animation' style='display: none'>
    <img id='referenceImage' style='display: none'>
    <img id='generatedImage' style='display: none'>
    <div style='width: 500px; margin: 0px auto; text-align: center;'>
      <p>
        <a class='btn' href='#' id='differenceButton'>Difference</a>
        <a class='btn' href='#' id='animationButton'>Animation</a>
        <a class='btn' href='#' id='referenceImageButton'>Reference Image</a>
        <a class='btn' href='#' id='generatedImageButton'>Generated Image</a>
      </p>
      <p>
        <a class='btn btn-primary' href='#' id='accept'>Accept</a>
        <a class='btn btn-danger' href='#' id='reject'>Reject</a>
      </p>
    </div>
  </div>
  """

removeFixture = ->
  fixture = document.getElementById('fixture')
  document.body.removeChild(fixture)

describe "Compaa", ->
  compaa = undefined

  beforeEach ->
    compaa = Object.create(Compaa)
    compaa.compaaHost = "http://localhost:4567"
    loadFixture()

  afterEach -> removeFixture()

  describe "generatedImagePath()", ->
    it "changes the directory and filename of the referenceImagePath", ->
      compaa.init()
      expect(compaa.generatedImagePath()).toEqual "artifacts/screenshots_generated_this_run/firefox_home_move.png"

  describe "differenceGifPath()", ->
    it "changes the directory to screenshots_generated_this_run and adds a png extension", ->
      expectedDifferenceGifPath = "artifacts/differences_in_screenshots_this_run/firefox_home_move.png_difference.gif"
      referenceImagePath = "artifacts/reference_screenshots/firefox_home_move.png"
      spyOn(compaa, "referenceImagePath").andReturn referenceImagePath
      expect(compaa.differenceGifPath()).toEqual expectedDifferenceGifPath


  describe "show()", ->
    it "hides [difference animation referenceImage generatedImage] elements and shows the given element", ->
      compaa.show "difference"
      expect($("#difference").css("display")).toEqual "inline"
      expect($("#animation").css("display")).toEqual "none"
      expect($("#referenceImage").css("display")).toEqual "none"
      expect($("#generatedImage").css("display")).toEqual "none"

    it "hides [difference animation referenceImage generatedImage] elements and shows the given element", ->
      compaa.show "generatedImage"
      expect($("#difference").css("display")).toEqual "none"
      expect($("#animation").css("display")).toEqual "none"
      expect($("#referenceImage").css("display")).toEqual "none"
      expect($("#generatedImage").css("display")).toEqual "inline"


  describe "init", ->
    it "sets click handlers for buttons", ->
      compaa.init()
      $("#differenceButton").click()
      expect($("#difference")).not.toBeHidden()
      expect($("#animation")).toBeHidden()

    it "sets reference images", ->
      compaa.init()
      waitsFor (-> compaa.artifacts), "artifacts hasn't been set, is the mock is running??"
      runs ->
        expect(compaa.artifacts).toEqual ["artifacts/reference_screenshots/one.png", "artifacts/reference_screenshots/two.png", "artifacts/reference_screenshots/three.png", "artifacts/reference_screenshots/four.png"]
