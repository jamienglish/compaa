describe("Script", function() {
  var compaa;

  beforeEach(function() {
    compaa = new Compaa();
  });

  describe("filepath()", function() {
    it("pulls the filepath param from the query string", function() {
      spyOn(compaa, 'queryString').andReturn('this=that&filepath=artifacts/file.png');
      expect(compaa.filepath()).toEqual('artifacts/file.png');
    });
  });

  describe("differenceGifPath()", function() {
    it("is the same as the filepath", function() {
      var filepath = 'artifacts/differences_in_screenshots_this_run/firefox_home_move.png_difference.gif';
      spyOn(compaa, 'filepath').andReturn(filepath);
      expect(compaa.differenceGifPath()).toEqual(filepath);
    });
  });

  describe("oldImagePath()", function() {
    it("changes the directory and filename of the differenceGifPath", function() {
      var filepath, expectedOldImagePath;

      filepath             = 'artifacts/differences_in_screenshots_this_run/firefox_home_move.png_difference.gif';
      expectedOldImagePath = 'artifacts/reference_screenshots/firefox_home_move.png'

      spyOn(compaa, 'filepath').andReturn(filepath);

      expect(compaa.oldImagePath()).toEqual(expectedOldImagePath);
    });
  });

  describe("newImagePath()", function() {
    it("changes the directory to screenshots_generated_this_run and adds a png extension", function() {
      var filepath, expectedNewImagePath;

      filepath             = 'artifacts/differences_in_screenshots_this_run/firefox_home_move.png_difference.gif';
      expectedNewImagePath = 'artifacts/screenshots_generated_this_run/firefox_home_move.png'

      spyOn(compaa, 'filepath').andReturn(filepath);

      expect(compaa.newImagePath()).toEqual(expectedNewImagePath);
    });
  });

  describe("hideAllById()", function() {
    beforeEach(function() {
      ['this', 'that', 'tother'].forEach(function(element) {
        $('body').append('<div id="' + element + '"></div>');
      });
    });

    afterEach(function() {
      ['this', 'that', 'tother'].forEach(function(element) {
        $('#' + element).remove();
      });
    });

    it("hides all elements with the given ids", function() {
      compaa.hideAllById(['this', 'that', 'tother']);

      expect($('#this').css('display')).toEqual('none');
      expect($('#that').css('display')).toEqual('none');
      expect($('#tother').css('display')).toEqual('none');
    });
  });

  describe("show()", function() {
    beforeEach(function() {
      ['difference', 'animation', 'oldImage', 'newImage'].forEach(function(element) {
        $('body').append('<div id="' + element + '"></div>');
      });
    });

    afterEach(function() {
      ['difference', 'animation', 'oldImage', 'newImage'].forEach(function(element) {
        $('#' + element).remove();
      });
    });

    it("hides [difference animation oldImage newImage] elements and shows the given element", function() {
      compaa.show('difference');

      expect($('#difference').css('display')).toEqual('block');

      expect($('#animation').css('display')).toEqual('none');
      expect($('#oldImage').css('display')).toEqual('none');
      expect($('#newImage').css('display')).toEqual('none');
    });

    it("hides [difference animation oldImage newImage] elements and shows the given element", function() {
      compaa.show('newImage');

      expect($('#difference').css('display')).toEqual('none');
      expect($('#animation').css('display')).toEqual('none');
      expect($('#oldImage').css('display')).toEqual('none');
      expect($('#newImage').css('display')).toEqual('block');
    });
  });

  describe("getDifferenceImages(callback)", function() {
    it("gets artifacts json", function() {
      var callback = jasmine.createSpy();

      compaa.compaaHost = 'http://localhost:4567';
      compaa.getDifferenceImages(callback);

      waitsFor(function() {
        return callback.callCount > 0;
      }, 'getDifferenceImages callback never got called', 1000);

      runs(function() {
        var differenceImages = callback.mostRecentCall.args[0];
        expect(differenceImages.length).toEqual(3);
        expect(differenceImages[0]).toEqual('artifacts/differences_in_screenshots_this_run/one.png_difference.gif');
      });
    });
  });
});
