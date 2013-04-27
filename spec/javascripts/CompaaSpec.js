describe("Compaa", function() {
  var compaa;

  beforeEach(function() {
    compaa = new Compaa();
    compaa.compaaHost = 'http://localhost:4567';
    loadFixtures('body.html');
  });

  describe("oldImagePath()", function() {
    it("changes the directory and filename of the differenceGifPath", function() {
      var filepath, expectedOldImagePath;

      filepath             = 'artifacts/differences_in_screenshots_this_run/firefox_home_move.png_difference.gif';
      expectedOldImagePath = 'artifacts/reference_screenshots/firefox_home_move.png'

      spyOn(compaa, 'differenceGifPath').andReturn(filepath);

      expect(compaa.oldImagePath()).toEqual(expectedOldImagePath);
    });
  });

  describe("newImagePath()", function() {
    it("changes the directory to screenshots_generated_this_run and adds a png extension", function() {
      var filepath, expectedNewImagePath;

      filepath             = 'artifacts/differences_in_screenshots_this_run/firefox_home_move.png_difference.gif';
      expectedNewImagePath = 'artifacts/screenshots_generated_this_run/firefox_home_move.png'

      spyOn(compaa, 'differenceGifPath').andReturn(filepath);

      expect(compaa.newImagePath()).toEqual(expectedNewImagePath);
    });
  });

  describe("show()", function() {
    it("hides [difference animation oldImage newImage] elements and shows the given element", function() {
      compaa.show('difference');

      expect($('#difference').css('display')).toEqual('inline');

      expect($('#animation').css('display')).toEqual('none');
      expect($('#oldImage').css('display')).toEqual('none');
      expect($('#newImage').css('display')).toEqual('none');
    });

    it("hides [difference animation oldImage newImage] elements and shows the given element", function() {
      compaa.show('newImage');

      expect($('#difference').css('display')).toEqual('none');
      expect($('#animation').css('display')).toEqual('none');
      expect($('#oldImage').css('display')).toEqual('none');
      expect($('#newImage').css('display')).toEqual('inline');
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
      });
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
