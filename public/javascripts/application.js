// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//jQuery(function($) { 
  
//  //Remove uploaded document field.
//  $("a[rel='#remove_document']").click( function() {
//    $(this).parents('div.document').remove();
//    return false;
//  });
//  
//  //Add new uploaded document via ajax
//  $("a[rel='#add_document']").click( function() {
//    $.get("document_partial/0", null, function(data) {
//      $("#documents").append(data);
//    }, "html");
//    return false;
//  });

//  // Logs toggle display
//  $("div#full-logs").hide();
//  $("a[rel='#toggle_full-logs']").click( function() {
//    $("div#full-logs").toggle();
//  });

//  
//  // Tooltip
//  $(".tooltip-trigger").tooltip({
//    position: ["center", "right"]//,
////    offset: [0,20],
////    opacity: 0.7
//  });

//  // Function for creating new item for Line of business,Cost center,Job capacity,Salary type,Experience level
//  $("a[rel]").overlay(function() {
//    // overlay object
//    var overlay = this;
//    // content wrapper
//    var wrap    = overlay.getContent().find("div.wrap");
//    // select element for this overlay
//    var list    = overlay.getTrigger().parents("li.select").children("select");
//    console.log(list);
//    // load the new resource form
//    wrap.load(overlay.getTrigger().attr("href"), null, function(responseText, textStatus, XMLHttpRequest) {
//      // auto-grow text area
//      $("textarea").autogrow({
//		    maxHeight: 100,
//		    minHeight: 30,
//		    lineHeight: 16
//	    });
//      // modify form submit to load via ajax
//      wrap.find("form").submit(function() {
//        // submit the form
//        $.post( $(this).attr("action"), $(this).serialize(), function(data) {
//          // detect created object type
//          var key;
//          for (var i in data) { key = i };
//          // generate the option html
//          var option = "<option selected = \"true\" value=\""+ data[key].id + ">" + data[key].name + "</option>"
//          // add the option to list
//          list.append(option);
//          // close the overlay when data successfully created.
//          overlay.close();
//        }, "json");
//        //intercept normal form submit.
//        return false;
//      });
//    });
//  });
  
//});
