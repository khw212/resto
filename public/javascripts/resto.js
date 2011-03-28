jQuery(function($) { 

  $(".hidden").hide();
  
  /* Toggle hidden fields actions */
  $(".toggle").click( function() {
    id = $(this).attr('rel');
    $(id).toggle();
    return false;
  });
  
  $("a.overlay").overlay({top: 'center'});
  
  $("div.ellipsize").each( function(index, node) {
    $(node).find("div.full").hide();
    $(node).find("div.trim").show();
    $(node).find("a.ellipsize-trigger").click( function(e) {
      var parent = $(this).parent('.trim').parent();
      parent.find("div.full").show();
      parent.find("div.trim").hide();
      e.preventDefault();
      return false;
    });
  });

  $("a.job-overlay").overlay({
    left: 0,
    top: 'center',
    onBeforeLoad: function(event) {
      left  = this.getTrigger().parent().position().left;
      left += this.getTrigger().parent().width();
      this.getConf().left = left;
    }
  });
  
  $("input#captcha").attr("autocomplete", "off");
  
});

