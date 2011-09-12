// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$j = jQuery.noConflict();

function flash_message(type, message)
{
  $j("#flash").append("<div class='alert-message " + type + "'><p>" + message + "</p></div>");
}