function flash_message(type, message)
{
  $j("#flash").append("<div class='alert alert-box alert-" + type + "'>" + message + "</div>");
}