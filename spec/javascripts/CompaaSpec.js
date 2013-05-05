describe("Compaa", function() {
  var compaa;

  beforeEach(function() {
    compaa = new Compaa();
    compaa.compaaHost = 'http://localhost:4567';
    loadFixtures('body.html');
  });

  describe("referenceImagePath()", function() {
    it("changes the directory and filename of the differenceGifPath", function() {
      var filepath, expectedReferenceImagePath;

      filepath = 'artifacts/differences_in_screenshots_this_run/firefox_home_move.png_difference.gif';
      expectedReferenceImagePath = 'artifacts/reference_screenshots/firefox_home_move.png'

      spyOn(compaa, 'differenceGifPath').andReturn(filepath);

      expect(compaa.referenceImagePath()).toEqual(expectedReferenceImagePath);
    });
  });

  describe("generatedImagePath()", function() {
    it("changes the directory to screenshots_generated_this_run and adds a png extension", function() {
      var filepath, expectedGeneratedImagePath;

      filepath             = 'artifacts/differences_in_screenshots_this_run/firefox_home_move.png_difference.gif';
      expectedGeneratedImagePath = 'artifacts/screenshots_generated_this_run/firefox_home_move.png'

      spyOn(compaa, 'differenceGifPath').andReturn(filepath);

      expect(compaa.generatedImagePath()).toEqual(expectedGeneratedImagePath);
    });
  });

  describe("show()", function() {
    it("hides [difference animation referenceImage generatedImage] elements and shows the given element", function() {
      compaa.show('difference');

      expect($('#difference').css('display')).toEqual('inline');

      expect($('#animation').css('display')).toEqual('none');
      expect($('#referenceImage').css('display')).toEqual('none');
      expect($('#generatedImage').css('display')).toEqual('none');
    });

    it("hides [difference animation referenceImage generatedImage] elements and shows the given element", function() {
      compaa.show('generatedImage');

      expect($('#difference').css('display')).toEqual('none');
      expect($('#animation').css('display')).toEqual('none');
      expect($('#referenceImage').css('display')).toEqual('none');
      expect($('#generatedImage').css('display')).toEqual('inline');
    });
  });

  describe("init", function() {
    it("sets click handlers for buttons", function() {
      compaa.init();
      $('#differenceButton').click();
      expect($('#difference')).not.toBeHidden();
      expect($('#animation')).toBeHidden();
    });

    it("sets difference images", function() {
      spyOn(compaa, 'setAnimationImage');
      compaa.init();
      waitsFor(function() {
        return compaa.setAnimationImage.callCount > 0;
      }, 'setAnimationImage didnt get called, is the mock is running??');
      runs(function() {
        expect(compaa.differenceImages).toEqual([
          'artifacts/differences_in_screenshots_this_run/one.png_difference.gif',
          'artifacts/differences_in_screenshots_this_run/two.png_difference.gif',
          'artifacts/differences_in_screenshots_this_run/three.png_difference.gif'
        ]);
      });
    });
  });
});
