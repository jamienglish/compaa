function valuesOf(images) {
  return Object.getOwnPropertyNames(images).map(function(property) {
    return images[property];
  });
};

describe("compaa", function() {
  var compaa = Object.create(Compaa);

  describe("equal()", function() {
    var images = {
      one: new Image(),
      two: new Image(),
      three: new Image(),
      blueRadioButton: new Image(),
      greyRadioButton: new Image()
    };

    beforeEach(function() {
      images.one.src = '/spec/javascripts/support/generated.png';
      images.two.src = '/spec/javascripts/support/reference.png';
      images.three.src = '/spec/javascripts/support/generated.png';
      images.blueRadioButton.src = '/spec/javascripts/support/blue_radio_button.png';
      images.greyRadioButton.src = '/spec/javascripts/support/grey_radio_button.png';

      waitsFor(function() {
        return valuesOf(images).every(function(image) {
          return image.complete;
        });
      });
    });

    it("is false when both images are very different", function() {
      expect(compaa.equal(images.one, images.two)).toBe(false);
    });

    it("is true when both images are the same", function() {
      expect(compaa.equal(images.one, images.three)).toBe(true);
    });
    
    it("allows for slight differences", function() {
      expect(compaa.equal(images.blueRadioButton, images.greyRadioButton)).toBe(true);
    });
  });
});
