// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
    selected_item = $("#selected").text();
    if (selected_item) {
        $('#'+selected_item).addClass("selected");
    }
	
	$("#weekly_plan").hide();
	
	$("#weekly_plan").show(500);
	
	$("#weekly_plan .title").click(function() {
		$(this).parent().next("ul").children().slideToggle(500);
		return false;
	});

    $("#wdays").hide();
    $("#mdays").hide();
    $("#repeating_type").hide();

    $("#repeated").click(function() {
        $("#repeating_type").toggle(500);
    });

    $("#r_type_1").click(function() {
        $("#mdays").hide(500);
        $("#wdays").show(500);
    });

    $("#r_type_2").click(function() {
        $("#wdays").hide(500);
        $("#mdays").show(500);
    });
});