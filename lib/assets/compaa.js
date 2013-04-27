var Compaa = (function() {
  var Compaa = function() {
    this.imageTypes = ['difference', 'animation', 'oldImage', 'newImage'];
    this.compaaHost = '';
    this.counter = 0;
    this.differenceImages = [];
  };

  Compaa.prototype = {
    currentDifferenceImage: function() {
      return this.differenceImages[this.counter];
    },

    setCurrentDifferenceImage: function(newSrc) {
      _.first($('#animation')).src = newSrc;
    },

    differenceGifPath: function() {
      return this.currentDifferenceImage();
    },

    oldImagePath: function() {
      return this.differenceGifPath()
        .replace('differences_in_screenshots_this_run', 'reference_screenshots')
        .replace('_difference.gif', '');
    },

    newImagePath: function() {
      return this.oldImagePath()
        .replace('reference_screenshots', 'screenshots_generated_this_run');
    },

    generatedImageFromDifferenceImage: function(differenceImagePath) {
      return differenceImagePath
        .replace('differences_in_screenshots_this_run', 'screenshots_generated_this_run')
        .replace('_difference.gif', '');
    },

    show: function(mode) {
      _.each(this.imageTypes, function(type) {
        $('#' + type).hide();
      });

      $('#' + mode).show();
    },

    attachButtonClickHandlers: function() {
      var self = this;

      _.each(this.imageTypes, function(element) {
        $('#' + element + 'Button').click(function(evt) {
          evt.preventDefault();
          self.show(element);
        });
      });
    },

    drawDifferenceCanvas: function() {
      var $newImg, $oldImg, over, under;

      $oldImg = $('<img src="' + this.oldImagePath() + '" />');
      $newImg = $('<img src="' + this.newImagePath() + '" />');

      over  = _.first($('#offScreenCanvas')).getContext('2d');
      under = _.first($('#difference')).getContext('2d');

      $oldImg.on('load', function() {
        $newImg.on('load', function() {
          var newImg = _.first($newImg),
              oldImg = _.first($oldImg);

          $('#difference')
            .attr('width', oldImg.width)
            .attr('height', oldImg.height);

          $('#offScreenCanvas')
            .attr('width',  newImg.width)
            .attr('height', newImg.height);

          over.drawImage(oldImg, 0, 0);
          under.drawImage(newImg, 0, 0);
          over.blendOnto(under, 'difference');
        });
      });
    },

    pathFromUrl: function(url) {
      var a = document.createElement('a');
      a.href = url;
      return a.pathname;
    },

    acceptImage: function() {
      var self = this;
      var url  = this.compaaHost + '/screenshots?filepath=' + this.pathFromUrl(this.newImagePath());

      $.post(url, function() {
        var nextImage = self.nextDifferenceImage();
        if (nextImage) {
          self.setCurrentDifferenceImage(nextImage);
          self.setNewImage();
          self.setOldImage();
        } else {
          $('body').replaceWith('<h1>Done!</h1>');
        }
      });
    },

    attachAcceptClickHandler: function() {
      var self = this;

      $('#accept').click(function(e) {
        e.preventDefault();
        self.acceptImage();
      });
    },

    nextDifferenceImage: function() {
      this.counter += 1;
      return this.differenceImages[this.counter];
    },

    setNewImage: function() {
      $('#newImage').attr('src', this.newImagePath())
    },

    setOldImage: function() {
      $('#oldImage').attr('src', this.oldImagePath())
    },

    setAnimationImage: function() {
      this.setCurrentDifferenceImage(this.differenceImages[0]);
    },

    init: function() {
      var self = this;
      this.attachButtonClickHandlers();
      $.getJSON(this.compaaHost + '/artifacts.json', function(json) {
        self.differenceImages = json.difference_images;
        self.drawDifferenceCanvas();
        self.setAnimationImage();
        self.setNewImage();
        self.setOldImage();
        self.show('difference');
      });
      this.attachAcceptClickHandler();
    }
  };

  return Compaa;
})();
