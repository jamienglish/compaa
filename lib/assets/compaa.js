var Compaa = (function() {
  var Compaa = function() {
    this.imageTypes       = ['difference', 'animation', 'referenceImage', 'generatedImage'];
    this.compaaHost       = '';
    this.counter          = 0;
    this.differenceImages = [];
  };

  Compaa.prototype = {
    currentDifferenceImage: function() {
      return this.differenceImages[this.counter];
    },

    setCurrentDifferenceImage: function(newSrc) {
      document.getElementById('animation').src = newSrc;
    },

    differenceGifPath: function() {
      return this.currentDifferenceImage();
    },

    referenceImagePath: function() {
      return this.differenceGifPath()
        .replace('differences_in_screenshots_this_run', 'reference_screenshots')
        .replace('_difference.gif', '');
    },

    generatedImagePath: function() {
      return this.referenceImagePath()
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

    supportsBlending: function() {
      return window.navigator.userAgent.indexOf('Firefox/2') !== -1;
    },

    drawDifferenceCanvas: function() {
      var self = this,
          generatedImage = new Image(),
          referenceImage = new Image(),
          context = document.getElementById('difference').getContext('2d');

      $(referenceImage).load(function() {
        $(generatedImage).load(function() {
          $('#difference')
            .attr('width',  referenceImage.width)
            .attr('height', referenceImage.height);

          if (self.supportsBlending()) {
            context.globalCompositeOperation = 'difference';
          } else {
            context.globalAlpha = 0.5;
          }
          context.drawImage(referenceImage, 0, 0);
          context.drawImage(generatedImage, 0, 0);
        });

        generatedImage.src = self.generatedImagePath();
      });

      referenceImage.src = this.referenceImagePath();
    },

    pathFromUrl: function(url) {
      var a = document.createElement('a');
      a.href = url;
      return a.pathname;
    },

    acceptImage: function() {
      var self = this;
      var url  = this.compaaHost + '/screenshots?filepath=' + this.pathFromUrl(this.generatedImagePath());

      $.post(url, function() {
        var nextImage = self.nextDifferenceImage();

        if (nextImage) {
          self.setCurrentDifferenceImage(nextImage);
          self.setGeneratedImage();
          self.setReferenceImage();
          self.drawDifferenceCanvas();
        } else {
          self.endGame();
        }
      });
    },

    rejectImage: function() {
      var nextImage = this.nextDifferenceImage();

      if (nextImage) {
        this.setCurrentDifferenceImage(nextImage);
        this.setGeneratedImage();
        this.setReferenceImage();
        this.drawDifferenceCanvas();
      } else {
        this.endGame();
      }
    },

    attachAcceptClickHandler: function() {
      var self = this;

      $('#accept').click(function(e) {
        e.preventDefault();
        self.acceptImage();
      });
    },

    attachRejectClickHandler: function() {
      var self = this;

      $('#reject').click(function(e) {
        e.preventDefault();
        self.rejectImage();
      });
    },

    nextDifferenceImage: function() {
      this.counter += 1;
      return this.differenceImages[this.counter];
    },

    setGeneratedImage: function() {
      document.getElementById('generatedImage').src = this.generatedImagePath();
    },

    setReferenceImage: function() {
      document.getElementById('referenceImage').src = this.referenceImagePath();
    },

    setAnimationImage: function() {
      this.setCurrentDifferenceImage(this.differenceImages[0]);
    },

    endGame: function() {
      $('body').replaceWith('<h1>Done!</h1>');
    },

    init: function() {
      var self = this;

      this.attachButtonClickHandlers();
      this.attachAcceptClickHandler();
      this.attachRejectClickHandler();

      $.getJSON(this.compaaHost + '/artifacts.json', function(json) {
        self.differenceImages = json.artifacts.differenceImages;
        self.drawDifferenceCanvas();
        self.setAnimationImage();
        self.setGeneratedImage();
        self.setReferenceImage();
        self.show('difference');
      });
    }
  };

  return Compaa;
})();
