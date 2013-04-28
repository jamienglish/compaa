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
      _.first($('#animation')).src = newSrc;
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

    drawDifferenceCanvas: function() {
      var generatedImg = new Image(),
          referenceImg = new Image(),
          over   = _.first($('#offScreenCanvas')).getContext('2d'),
          under  = _.first($('#difference')).getContext('2d');

      referenceImg.onload = function() {
        generatedImg.onload = function() {

          $('#difference')
            .attr('width',  referenceImg.width)
            .attr('height', referenceImg.height);

          $('#offScreenCanvas')
            .attr('width',  generatedImg.width)
            .attr('height', generatedImg.height);

          over.clearRect(0, 0, over.canvas.width, over.canvas.height);
          under.clearRect(0, 0, under.canvas.width, under.canvas.height);

          over.drawImage(referenceImg, 0, 0);
          under.drawImage(generatedImg, 0, 0);

          over.blendOnto(under, 'difference');
        }
      }

      referenceImg.src = this.referenceImagePath();
      generatedImg.src = this.generatedImagePath();
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
          $('body').replaceWith('<h1>Done!</h1>');
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
        $('body').replaceWith('<h1>Done!</h1>');
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
      $('#generatedImage').attr('src', this.generatedImagePath())
    },

    setReferenceImage: function() {
      $('#referenceImage').attr('src', this.referenceImagePath())
    },

    setAnimationImage: function() {
      this.setCurrentDifferenceImage(this.differenceImages[0]);
    },

    init: function() {
      var self = this;

      this.attachButtonClickHandlers();
      this.attachAcceptClickHandler();
      this.attachRejectClickHandler();

      $.getJSON(this.compaaHost + '/artifacts.json', function(json) {
        self.differenceImages = json.difference_images;
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
