// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
	$("#event_date").datepicker();
});

$(document).ready(function(){
	
	$("#weekly_plan").hide();
	
	$("#weekly_plan").show(500);
	
	$("#weekly_plan .title").click(function() {
		$(this).parent().next("ul").children().slideToggle(500);
		return false;
	});
});