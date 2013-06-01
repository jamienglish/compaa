describe("blender", function() {
  describe("makeItBlend()", function() {
    it("produces a difference image", function() {
      var imageOne      = new Image(),
          imageTwo      = new Image(),
          expectedImage = new Image(),
          actual;

      this.addMatchers(imagediff.jasmine);

      expectedImage.src = '/spec/javascripts/support/expected.png';
      imageOne.src = '/spec/javascripts/support/generated.png';
      imageTwo.src = '/spec/javascripts/support/reference.png';

      waitsFor(function() {
        return imageOne.complete && imageTwo.complete && expectedImage.complete;
      });

      runs(function() {
        window.blender.makeItBlend(imageOne, imageTwo, function(blended) {
          expect(blended).toImageDiffEqual(expectedImage);
        });
      });
    });
  });
});
